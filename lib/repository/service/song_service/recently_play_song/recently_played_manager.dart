import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../domain/song_model/song_model.dart';

class RecentlyPlayedManager {
  static List<SongData> recentlyPlayed = [];
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Get the user-specific key for SharedPreferences
  static Future<String> _getUserSpecificKey() async {
    final userId = await _storage.read(key: 'userId') ?? 'default_user';
    return 'recentlyPlayed_$userId';
  }

  // Load recently played songs for the current user
  static Future<List<SongData>> loadRecentlyPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getUserSpecificKey();
    final songsJson = prefs.getStringList(key) ?? [];
    recentlyPlayed = songsJson.map((e) => SongData.fromJson(json.decode(e))).toList();
    return recentlyPlayed;
  }

  // Add a song to the recently played list for the current user
  static Future<void> addSongToRecentlyPlayed(SongData song) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = await _getUserSpecificKey();

      // Remove if already exists (avoid duplicates)
      recentlyPlayed.removeWhere((s) => s.id == song.id);

      // Add at the start
      recentlyPlayed.insert(0, song);

      // Limit list to last 10 songs
      if (recentlyPlayed.length > 10) {
        recentlyPlayed = recentlyPlayed.sublist(0, 10);
      }

      // Save updated list
      final songsJson = recentlyPlayed.map((e) => json.encode(e.toMap())).toList();
      await prefs.setStringList(key, songsJson);
    } catch (e) {
      print('Error saving recently played: $e');
    }
  }

  // Clear recently played songs for the current user
  static Future<void> clearRecentlyPlayed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = await _getUserSpecificKey();
      recentlyPlayed.clear();
      await prefs.remove(key);
    } catch (e) {
      print('Error clearing recently played: $e');
    }
  }
}