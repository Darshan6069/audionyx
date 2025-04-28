 import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../domain/song_model/song_model.dart';

class DownloadSong {
   Future<void> downloadSong(
       String url,
       String fileName,
       String thumbnailUrl,
       SongData songData,
       BuildContext context
       ) async {
     // Check Android version to determine if permission is needed
     bool needsStoragePermission = false;
     if (Platform.isAndroid) {
       try {
         final androidInfo = await DeviceInfoPlugin().androidInfo;
         final sdkInt = androidInfo.version.sdkInt;
         // Request storage permission only for Android 10 (API 29) and below
         needsStoragePermission = sdkInt < 30;
       } catch (e) {
         print('Failed to get device info: $e');
         // Fallback: Assume Android 11+ (no permission needed for app-specific storage)
         needsStoragePermission = false;
       }
     }

     PermissionStatus status = PermissionStatus.granted;

     if (needsStoragePermission) {
       // Check and request storage permission
       if (await Permission.storage.isDenied) {
         status = await Permission.storage.request();
       }
     }

     // Handle denied or permanently denied permissions
     if (status.isDenied || status.isPermanentlyDenied) {
       if (status.isPermanentlyDenied) {
         // Prompt user to enable permission in settings
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: const Text(
                 'Storage permission is required to save downloads. Please enable it in settings.'),
             action: SnackBarAction(
               label: 'Settings',
               onPressed: () async {
                 await openAppSettings();
               },
             ),
           ),
         );
       } else {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Storage permission not granted')),
         );
       }
       return;
     }

     try {
       // Fetch file size to validate URL
       final headResponse = await http.head(Uri.parse(url));
       if (headResponse.statusCode != 200) {
         throw Exception('Failed to fetch file info: ${headResponse.statusCode}');
       }
       final contentLength = int.parse(headResponse.headers['content-length'] ?? '0');
       print('File size from server: $contentLength bytes');

       // Use app-specific storage directory
       Directory downloadDir;
       if (Platform.isAndroid) {
         // Use app-specific external storage (no permission needed on Android 11+)
         final externalDir = await getExternalStorageDirectory();
         if (externalDir == null) {
           throw Exception('Unable to access external storage directory');
         }
         downloadDir = Directory('${externalDir.path}/Downloads');
       } else {
         // Use documents directory for iOS
         downloadDir = await getApplicationDocumentsDirectory();
       }

       // Create directory if it doesn't exist
       if (!downloadDir.existsSync()) {
         downloadDir.createSync(recursive: true);
       }
       print('Saving files to: ${downloadDir.path}');

       // Download the song using http
       final response = await http.get(Uri.parse(url));
       if (response.statusCode != 200) {
         throw Exception('Failed to download song: ${response.statusCode}');
       }

       // Save the song file
       final songFile = File('${downloadDir.path}/$fileName');
       await songFile.writeAsBytes(response.bodyBytes);
       print('Song saved to: ${songFile.path}');

       // Download and save thumbnail
       if (thumbnailUrl.isNotEmpty) {
         final thumbnailResponse = await http.get(Uri.parse(thumbnailUrl));
         if (thumbnailResponse.statusCode == 200) {
           final thumbnailFileName = '${fileName.replaceAll('.mp3', '')}_thumbnail.jpg';
           final thumbnailFile = File('${downloadDir.path}/$thumbnailFileName');
           await thumbnailFile.writeAsBytes(thumbnailResponse.bodyBytes);
           print('Thumbnail saved to: ${thumbnailFile.path}');
         } else {
           print('Failed to download thumbnail: ${thumbnailResponse.statusCode}');
         }
       }

       // Save metadata
       final metadataFile = File('${downloadDir.path}/${fileName.replaceAll('.mp3', '.json')}');
       final metadata = {
         'id': songData.id,
         'title': songData.title,
         'artist': songData.artist,
         'album': songData.album,
         'thumbnail': '${fileName.replaceAll('.mp3', '')}_thumbnail.jpg',
         'genre': songData.genre,
       };
       await metadataFile.writeAsString(jsonEncode(metadata));
       print('Metadata saved to: ${metadataFile.path}');

       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Downloaded: $fileName to ${downloadDir.path}')),
       );
     } catch (e) {
       print('Download error: $e');
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Download failed: $e')),
       );
     }
   }
 }