import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:audionyx/core/constants/app_strings.dart';

import '../../../../domain/song_model/song_model.dart';

class PlaylistService {
  final _storage = const FlutterSecureStorage();

  Future<String?> _getAuthToken() async {
    final token = await _storage.read(key: 'jwt_token');
    print('Auth token from secure storage: $token');
    return token;
  }

  Future<String?> getUserId() async {
    final userId = await _storage.read(key: 'userId');
    print('User ID: $userId');
    return userId;
  }

  Future<List<dynamic>> fetchUserPlaylists() async {
    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('Authentication token is missing');
      }

      final url = '${AppStrings.baseUrl}playlists';
      print('Fetching playlists from: $url');

      final response = await http
          .get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      )
          .timeout(const Duration(seconds: 10));

      print(
          'Fetch playlists response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception(
            'Playlist endpoint not found. Please check the server configuration.');
      } else {
        throw Exception(
            'Failed to load playlists: Status ${response.statusCode}, ${response
                .body}');
      }
    } catch (e) {
      print('Fetch playlists error: $e');
      throw Exception('Error fetching playlists: $e');
    }
  }

  Future<void> createPlaylist(String playlistName) async {
    if (playlistName.isEmpty) {
      throw Exception('Playlist name cannot be empty');
    }

    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('Authentication token is missing');
      }

      final url = '${AppStrings.baseUrl}playlists/create';
      print('Creating playlist at: $url');

      final response = await http
          .post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': playlistName,
          'description': 'A new playlist created by the user',
          'thumbnailUrl': '',
          'songs': [],
        }),
      )
          .timeout(const Duration(seconds: 10));

      print(
          'Create playlist response: ${response.statusCode} ${response.body}');

      if (response.statusCode != 201) {
        if (response.statusCode == 404) {
          throw Exception(
              'Playlist creation endpoint not found. Please check the server.');
        }
        throw Exception(
            'Failed to create playlist: Status ${response
                .statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Create playlist error: $e');
      throw Exception('Error creating playlist: $e');
    }
  }

  Future<void> deletePlaylist(String playlistId) async {
    final token = await _getAuthToken();
    final userId = await getUserId();

    print('Playlist ID: $playlistId');
    print('User ID: $userId');
    print('Auth token: $token');

    if (playlistId.isEmpty || token == null || userId == null) {
      throw Exception('Playlist ID, user ID, or token is missing');
    }

    final url = '${AppStrings
        .baseUrl}playlists/users/$userId/playlists/$playlistId';
    print('Delete playlist URL: $url');

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print(
          'Delete playlist response: ${response.statusCode} ${response.body}');

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete playlist: Status ${response
                .statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Delete playlist error: $e');
      throw Exception('Error deleting playlist: $e');
    }
  }

  static const String baseUrl = 'http://192.168.0.59:4000/api/playlists'; // Replace with your backend URL

  // Add a full song to a playlist
  static Future<Map<String, dynamic>> addSongsToPlaylist(
      String token,
      String playlistId,
      String songId,
      ) async {
    try {
      if (playlistId.isEmpty || songId.isEmpty) {
        throw Exception('Playlist ID and Song ID are required.');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/add-song'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'playlistId': playlistId,
          'songId': songId,
        }),
      );

      print('Response: ${response.statusCode} | ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Unknown error');
      }
    } catch (e) {
      print('Add song error: $e');
      rethrow;
    }
  }

}
