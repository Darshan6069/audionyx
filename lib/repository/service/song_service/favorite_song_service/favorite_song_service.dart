import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../domain/song_model/song_model.dart';

class FavoriteSongService {
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Get the user-specific key for SharedPreferences
  static Future<String> _getUserSpecificKey() async {
    final userId = await _storage.read(key: 'userId') ?? 'default_user';
    return 'favorite_songs_$userId';
  }

  // Get all favorite songs for the current user
  Future<List<SongData>> getFavoriteSongs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = await _getUserSpecificKey();
      final String? favoriteList = prefs.getString(key);

      if (favoriteList == null || favoriteList.isEmpty) {
        return [];
      }

      List<dynamic> decodedList = jsonDecode(favoriteList);
      return decodedList.map((item) => SongData.fromJson(item)).toList();
    } catch (e) {
      print('Error getting favorite songs: $e');
      return [];
    }
  }

  // Check if a song is in favorites for the current user
  Future<bool> isSongFavorite(SongData song) async {
    try {
      final List<SongData> songs = await getFavoriteSongs();
      return songs.any((favSong) => favSong.id == song.id);
    } catch (e) {
      print('Error checking favorite song: $e');
      return false;
    }
  }

  // Add a song to favorites for the current user
  Future<bool> addToFavorites(SongData song) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = await _getUserSpecificKey();
      final List<SongData> currentFavorites = await getFavoriteSongs();

      // Check if the song already exists in favorites
      if (currentFavorites.any((favSong) => favSong.id == song.id)) {
        return true; // Song is already in favorites
      }

      // Add the song and save
      currentFavorites.add(song);

      // Convert list to JSON and save
      List<Map<String, dynamic>> jsonList = currentFavorites.map((song) => song.toMap()).toList();
      await prefs.setString(key, jsonEncode(jsonList));

      return true;
    } catch (e) {
      print('Error adding song to favorites: $e');
      return false;
    }
  }

  // Remove a song from favorites for the current user
  Future<bool> removeFromFavorites(SongData song) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = await _getUserSpecificKey();
      final List<SongData> currentFavorites = await getFavoriteSongs();

      // Remove the song if it exists
      currentFavorites.removeWhere((favSong) => favSong.id == song.id);

      // Convert list to JSON and save
      List<Map<String, dynamic>> jsonList = currentFavorites.map((song) => song.toMap()).toList();
      await prefs.setString(key, jsonEncode(jsonList));

      return true;
    } catch (e) {
      print('Error removing song from favorites: $e');
      return false;
    }
  }

  // Toggle favorite status for the current user
  Future<bool> toggleFavorite(SongData song) async {
    try {
      final bool isFavorite = await isSongFavorite(song);
      return isFavorite ? await removeFromFavorites(song) : await addToFavorites(song);
    } catch (e) {
      print('Error toggling favorite: $e');
      return false;
    }
  }

  // Clear favorite songs for the current user
  Future<void> clearFavoriteSongs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = await _getUserSpecificKey();
      await prefs.remove(key);
    } catch (e) {
      print('Error clearing favorite songs: $e');
    }
  }
}
