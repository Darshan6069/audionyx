import 'dart:convert';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:audionyx/core/constants/app_strings.dart';

class PlaylistService {
  final _storage = const FlutterSecureStorage();
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: '${AppStrings.baseUrl}playlists',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<String?> _getAuthToken() async {
    final token = await _storage.read(key: 'jwt_token');
    print('Auth token: $token');
    return token;
  }

  Future<String?> _getUserId() async {
    final userId = await _storage.read(key: 'userId');
    print('User ID: $userId');
    return userId;
  }

  Future<List<dynamic>> fetchUserPlaylists() async {
    try {
      final token = await _getAuthToken();
      if (token == null) throw Exception('Token missing');

      final response = await _dio.get(
        '',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('Playlists fetched: ${response.data}');
      return response.data;
    } catch (e) {
      print('Fetch playlists error: $e');
      rethrow;
    }
  }

  Future<void> createPlaylist(String name) async {
    if (name.isEmpty) throw Exception('Playlist name cannot be empty');

    try {
      final token = await _getAuthToken();
      if (token == null) throw Exception('Token missing');

      final response = await _dio.post(
        '/create',
        data: {
          'name': name,
          'description': 'A new playlist created by the user',
          'thumbnailUrl': '',
          'songs': [],
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create playlist: ${response.data}');
      }

      print('Playlist created: ${response.data}');
    } catch (e) {
      print('Create playlist error: $e');
      rethrow;
    }
  }

  Future<void> deletePlaylist(String playlistId) async {
    try {
      final token = await _getAuthToken();
      final userId = await _getUserId();

      if (token == null || userId == null || playlistId.isEmpty) {
        throw Exception('Missing token/userId/playlistId');
      }

      final response = await _dio.delete(
        '/users/$userId/playlists/$playlistId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete playlist: ${response.data}');
      }

      print('Playlist deleted: ${response.data}');
    } catch (e) {
      print('Delete playlist error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addSongToPlaylist(
      String playlistId,
      String songId,
      ) async {
    try {
      final token = await _getAuthToken();
      if (token == null) throw Exception('Token missing');

      final response = await _dio.post(
        '/add-song',
        data: {'playlistId': playlistId, 'songId': songId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Unknown error');
      }
    } catch (e) {
      print('Add song error: $e');
      rethrow;
    }
  }

  Future<List<SongData>> fetchSongsFromPlaylist(String playlistId) async {
    try {
      final token = await _getAuthToken();
      if (token == null) throw Exception('Token missing');

      final response = await _dio.get(
        '/$playlistId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data['songs']; // ✅ This is now List<dynamic>
        final List<SongData> songs = data.map<SongData>((json) => SongData.fromJson(json)).toList();

        return songs;
      } else {
        throw Exception(response.data['message'] ?? 'Unknown error');
      }
    } catch (e) {
      print('Fetch songs error: $e');
      rethrow;
    }
  }

  Future<bool> removeSongFromPlaylist(String playlistId, String songId) async {
    try {
      final token = await _getAuthToken();
      if (token == null) throw Exception('Token missing');

      final response = await _dio.post(
        '/remove-song',
        data: {'playlistId': playlistId, 'songId': songId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Remove song error: $e');
      return false;
    }
  }
}
