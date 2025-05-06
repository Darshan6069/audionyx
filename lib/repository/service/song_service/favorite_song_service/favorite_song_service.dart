import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../domain/song_model/song_model.dart';

class FavoriteSongService {
  static const String baseUrl = 'http://192.168.0.58:4000/api'; // Replace with your backend URL

  // Placeholder for retrieving auth token (e.g., from shared preferences or secure storage)

  Future<String> _getAuthToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'jwt_token');
    if (token == null) {
      throw Exception('No auth token found');
    }
    return token;
  }

  Future<void> likeSong(String songId) async {
    final token = await _getAuthToken();
    final response = await http.post(
      Uri.parse('$baseUrl/songs/$songId/like'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to like song: ${response.body}');
    }
  }

  Future<void> unlikeSong(String songId) async {
    final token = await _getAuthToken();
    final response = await http.post(
      Uri.parse('$baseUrl/songs/$songId/unlike'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unlike song: ${response.body}');
    }
  }

  Future<bool> getLikeStatus(String songId) async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$baseUrl/songs/$songId/like-status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['isLiked'] as bool;
    } else {
      throw Exception('Failed to fetch like status: ${response.body}');
    }
  }


  Future<List<SongData>> getLikedSongs() async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$baseUrl/songs/liked'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final songs = (data['songs'] as List)
          .map((song) => SongData.fromJson(song))
          .toList();
      return songs;
    } else {
      throw Exception('Failed to fetch liked songs: ${response.body}');
    }
  }
}