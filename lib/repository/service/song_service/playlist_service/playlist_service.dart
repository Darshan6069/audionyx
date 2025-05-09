import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:audionyx/repository/service/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../main.dart';

class PlaylistService {
  final _storage = const FlutterSecureStorage();
  final ApiService _apiService = ApiService(navigatorKey);


  Future<String?> _getUserId() async {
    final userId = await _storage.read(key: 'userId');
    return userId;
  }

  Future<List<dynamic>> fetchUserPlaylists() async {
    try {
      final response = await _apiService.get('playlists');
      return response.data;
    } catch (e) {
      print('Fetch playlists error: $e');
      rethrow;
    }
  }

  Future<void> createPlaylist(String name) async {
    if (name.isEmpty) throw Exception('Playlist name cannot be empty');

    try {
      final response = await _apiService.post(
        'playlists/create',
        data: {
          'name': name,
          'description': 'A new playlist created by the user',
          'thumbnailUrl': '',
          'songs': [],
        },
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
      final userId = await _getUserId();

      if (userId == null || playlistId.isEmpty) {
        throw Exception('Missing userId/playlistId');
      }

      final response = await _apiService.delete(
        'playlists/users/$userId/playlists/$playlistId',
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
      final response = await _apiService.post(
        'playlists/add-song',
        data: {'playlistId': playlistId, 'songId': songId},
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
      final response = await _apiService.get('playlists/$playlistId');

      if (response.statusCode == 200) {
        final data = response.data['songs']; // List<dynamic>
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
      final response = await _apiService.post(
        'playlists/remove-song',
        data: {'playlistId': playlistId, 'songId': songId},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Remove song error: $e');
      return false;
    }
  }
}