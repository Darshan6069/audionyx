import 'dart:io';
import 'dart:typed_data';
import 'package:audionyx/repository/service/api_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:dio/dio.dart';

import '../../../../main.dart';

class UploadSongService {
  Uint8List? songBytes;
  Uint8List? thumbnailBytes;
  Uint8List? lyricsBytes;
  String? songFileName;
  String? thumbnailFileName;
  String? lyricsFileName;
  File? selectedSongFile;
  File? selectedThumbnailFile;
  File? selectedLyricsFile;

  final ApiService _apiService = ApiService(navigatorKey);

  Future<void> pickSongFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final platformFile = result.files.single;
        songFileName = platformFile.name;
        if (platformFile.bytes != null) {
          songBytes = platformFile.bytes;
          selectedSongFile = null;
        } else if (platformFile.path != null) {
          selectedSongFile = File(platformFile.path!);
          songBytes = null;
        }
      }
    } catch (e) {
      throw Exception('Error picking song: $e');
    }
  }

  Future<void> pickThumbnailFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final platformFile = result.files.single;
        thumbnailFileName = platformFile.name;
        if (platformFile.bytes != null) {
          thumbnailBytes = platformFile.bytes;
          selectedThumbnailFile = null;
        } else if (platformFile.path != null) {
          selectedThumbnailFile = File(platformFile.path!);
          thumbnailBytes = null;
        }
      }
    } catch (e) {
      throw Exception('Error picking thumbnail: $e');
    }
  }

  Future<void> pickLyricsFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'lrc'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final platformFile = result.files.single;
        lyricsFileName = platformFile.name;
        if (platformFile.bytes != null) {
          lyricsBytes = platformFile.bytes;
          selectedLyricsFile = null;
        } else if (platformFile.path != null) {
          selectedLyricsFile = File(platformFile.path!);
          lyricsBytes = null;
        }
      }
    } catch (e) {
      throw Exception('Error picking lyrics: $e');
    }
  }

  Future<String> uploadSong({
    required String title,
    required String artist,
    required String album,
  }) async {
    if (songBytes == null && selectedSongFile == null) {
      throw Exception('No song file selected');
    }
    if (title.isEmpty || artist.isEmpty || album.isEmpty) {
      throw Exception('All fields are required');
    }

    try {
      // Create FormData object for file uploads
      FormData formData = FormData();

      // Add song file
      if (songBytes != null && songFileName != null) {
        final songMimeType = lookupMimeType(songFileName!) ?? 'audio/mpeg';
        formData.files.add(
          MapEntry(
            'file',
            MultipartFile.fromBytes(
              songBytes!,
              filename: songFileName,
              contentType: MediaType.parse(songMimeType),
            ),
          ),
        );
      } else if (selectedSongFile != null && songFileName != null) {
        final songMimeType = lookupMimeType(songFileName!) ?? 'audio/mpeg';
        formData.files.add(
          MapEntry(
            'file',
            await MultipartFile.fromFile(
              selectedSongFile!.path,
              filename: songFileName,
              contentType: MediaType.parse(songMimeType),
            ),
          ),
        );
      }

      // Add thumbnail file (optional)
      if (thumbnailBytes != null && thumbnailFileName != null) {
        final imgMimeType = lookupMimeType(thumbnailFileName!) ?? 'image/jpeg';
        formData.files.add(
          MapEntry(
            'thumbnail',
            MultipartFile.fromBytes(
              thumbnailBytes!,
              filename: thumbnailFileName,
              contentType: MediaType.parse(imgMimeType),
            ),
          ),
        );
      } else if (selectedThumbnailFile != null && thumbnailFileName != null) {
        final imgMimeType = lookupMimeType(thumbnailFileName!) ?? 'image/jpeg';
        formData.files.add(
          MapEntry(
            'thumbnail',
            await MultipartFile.fromFile(
              selectedThumbnailFile!.path,
              filename: thumbnailFileName,
              contentType: MediaType.parse(imgMimeType),
            ),
          ),
        );
      }

      // Add lyrics file (optional)
      if (lyricsBytes != null && lyricsFileName != null) {
        final lyricsMimeType = lookupMimeType(lyricsFileName!) ?? 'text/plain';
        formData.files.add(
          MapEntry(
            'subtitles',
            MultipartFile.fromBytes(
              lyricsBytes!,
              filename: lyricsFileName,
              contentType: MediaType.parse(lyricsMimeType),
            ),
          ),
        );
      } else if (selectedLyricsFile != null && lyricsFileName != null) {
        final lyricsMimeType = lookupMimeType(lyricsFileName!) ?? 'text/plain';
        formData.files.add(
          MapEntry(
            'subtitles',
            await MultipartFile.fromFile(
              selectedLyricsFile!.path,
              filename: lyricsFileName,
              contentType: MediaType.parse(lyricsMimeType),
            ),
          ),
        );
      }

      // Add metadata
      formData.fields.add(MapEntry('title', title));
      formData.fields.add(MapEntry('artist', artist));
      formData.fields.add(MapEntry('album', album));

      // Send the request using ApiService
      final response = await _apiService.post('songs/upload', data: formData);

      if (response.statusCode == 201) {
        // Clear file data
        songBytes = null;
        songFileName = null;
        selectedSongFile = null;
        thumbnailBytes = null;
        thumbnailFileName = null;
        selectedThumbnailFile = null;
        lyricsBytes = null;
        lyricsFileName = null;
        selectedLyricsFile = null;
        return 'Upload successful!';
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Upload error: $e');
    }
  }
}
