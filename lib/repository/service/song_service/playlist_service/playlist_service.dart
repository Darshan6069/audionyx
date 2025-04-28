import 'dart:convert';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:http/http.dart' as http;

import '../../../../domain/song_model/playlist_model.dart';

class PlaylistService {
  // Use 10.0.2.2 for Android emulator, or your server's IP for physical device
  static const String baseUrl = 'http://192.168.0.3:4000/api';
  // Replace with a valid MongoDB user _id
  static const String userId = '6809d4a5735e2eeb7d88b2b4'; // E.g., "671234567890123456789012"

  static Future<List<PlaylistModel>> fetchPlaylists() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/playlists/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((json) => PlaylistModel.fromJson(json)).toList();
      } else {
        print('Failed to fetch playlists: ${response.statusCode} ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching playlists: $e');
      return [];
    }
  }

  static Future<List<SongData>> fetchSongs() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/songs'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((json) => SongData.fromMap(json)).toList();
      } else {
        print('Failed to fetch songs: ${response.statusCode} ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching songs: $e');
      return [];
    }
  }

  static Future<bool> createPlaylist(String name, String description) async {
    final url = Uri.parse('$baseUrl/playlists/create');
    final body = {
      'userId': userId,
      'name': name,
      'description': description,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Failed: ${response.body}');
      return false;
    }
  }

  static Future<bool> addSongToPlaylist(String playlistId, String songId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/playlists/$playlistId/add-song'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'songId': songId}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to add song: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error adding song: $e');
      return false;
    }
  }

  static Future<bool> removeSongFromPlaylist(String playlistId, String songId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/playlists/$playlistId/remove-song'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'songId': songId}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to remove song: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error removing song: $e');
      return false;
    }
  }
}