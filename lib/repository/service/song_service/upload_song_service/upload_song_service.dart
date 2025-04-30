import 'dart:io';
import 'dart:typed_data';
import 'package:audionyx/core/constants/app_strings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class UploadSongService {
  Uint8List? songBytes;
  Uint8List? thumbnailBytes;
  String? songFileName;
  String? thumbnailFileName;
  File? selectedSongFile;
  File? selectedThumbnailFile;

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
      final uri = Uri.parse('${AppStrings.baseUrl}songs/upload');
      final request = http.MultipartRequest('POST', uri);

      // Add song file
      if (songBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes('file', songBytes!,
              filename: songFileName),
        );
      } else if (selectedSongFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('file', selectedSongFile!.path,
              filename: songFileName),
        );
      }

      // Add thumbnail file (optional)
      if (thumbnailBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes('thumbnail', thumbnailBytes!,
              filename: thumbnailFileName),
        );
      } else if (selectedThumbnailFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
              'thumbnail', selectedThumbnailFile!.path,
              filename: thumbnailFileName),
        );
      }

      // Add metadata
      request.fields['title'] = title;
      request.fields['artist'] = artist;
      request.fields['album'] = album;

      final response = await request.send();
      if (response.statusCode == 201) {
        // Clear file data
        songBytes = null;
        songFileName = null;
        selectedSongFile = null;
        thumbnailBytes = null;
        thumbnailFileName = null;
        selectedThumbnailFile = null;
        return 'Upload successful!';
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Upload error: $e');
    }
  }
}