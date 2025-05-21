import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../domain/song_model/song_model.dart';

class DownloadSong {
  final Function(double)? onProgress;
  final Function(String, bool)? onStatusUpdate;

  DownloadSong({this.onProgress, this.onStatusUpdate});

  Future<void> downloadSong(
    String url,
    String fileName,
    String thumbnailUrl,
    SongData songData,
    BuildContext context,
  ) async {
    // Notify start of download
    onStatusUpdate?.call('Starting download for ${songData.title}', true);

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Storage permission is required to save downloads. Please enable it in settings.',
            ),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () async {
                await openAppSettings();
              },
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Storage permission not granted')));
      }
      onStatusUpdate?.call('Download failed: Permission not granted', false);
      return;
    }

    try {
      // Initialize Dio
      final dio = Dio();

      // Use app-specific storage directory
      Directory downloadDir;
      if (Platform.isAndroid) {
        final externalDir = await getExternalStorageDirectory();
        if (externalDir == null) {
          throw Exception('Unable to access external storage directory');
        }
        downloadDir = Directory('${externalDir.path}/Downloads');
      } else {
        downloadDir = await getApplicationDocumentsDirectory();
      }

      // Create directory if it doesn't exist
      if (!downloadDir.existsSync()) {
        downloadDir.createSync(recursive: true);
      }
      print('Saving files to: ${downloadDir.path}');

      // Download the song with Dio
      final songFilePath = '${downloadDir.path}/$fileName';
      await dio.download(
        url,
        songFilePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;
            onProgress?.call(progress.clamp(0.0, 1.0));
          }
        },
      );
      print('Song saved to: $songFilePath');

      // Download and save thumbnail
      if (thumbnailUrl.isNotEmpty) {
        final thumbnailFileName = '${fileName.replaceAll('.mp3', '')}_thumbnail.jpg';
        final thumbnailFilePath = '${downloadDir.path}/$thumbnailFileName';
        try {
          await dio.download(
            thumbnailUrl,
            thumbnailFilePath,
            onReceiveProgress: (received, total) {
              if (total != -1) {
                final progress = received / total;
                onProgress?.call(progress.clamp(0.0, 1.0));
              }
            },
          );
          print('Thumbnail saved to: $thumbnailFilePath');
        } catch (e) {
          print('Failed to download thumbnail: $e');
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
        'downloadDate': DateTime.now().toIso8601String(),
      };
      await metadataFile.writeAsString(jsonEncode(metadata));
      print('Metadata saved to: ${metadataFile.path}');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Downloaded: $fileName to ${downloadDir.path}')));
      onStatusUpdate?.call('Download completed: ${songData.title}', true);
    } catch (e) {
      print('Download error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Download failed: $e')));
      onStatusUpdate?.call('Download failed: ${songData.title} - $e', false);
    }
  }
}
