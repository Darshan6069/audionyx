import 'dart:convert';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteSongService {
  static const String _favoriteSongsKey = 'favorite_songs';

  // Get all favorite songs
  Future<List<SongData>> getFavoriteSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoriteList = prefs.getString(_favoriteSongsKey);

    if (favoriteList == null || favoriteList.isEmpty) {
      return [];
    }

    List<dynamic> decodedList = jsonDecode(favoriteList);
    return decodedList.map((item) => SongData.fromJson(item)).toList();
  }

  // Check if a song is in favorites
  Future<bool> isSongFavorite(SongData song) async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoriteList = prefs.getString(_favoriteSongsKey);

    if (favoriteList == null || favoriteList.isEmpty) {
      return false;
    }

    List<dynamic> decodedList = jsonDecode(favoriteList);
    List<SongData> songs = decodedList.map((item) => SongData.fromJson(item)).toList();

    // Check if song exists by its ID or unique identifier
    return songs.any((favSong) => favSong.id == song.id);
  }

  // Add a song to favorites
  Future<bool> addToFavorites(SongData song) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<SongData> currentFavorites = await getFavoriteSongs();

      // Check if the song already exists in favorites
      if (currentFavorites.any((favSong) => favSong.id == song.id)) {
        return true; // Song is already in favorites
      }

      // Add the song and save
      currentFavorites.add(song);

      // Convert list to JSON and save
      List<Map<String, dynamic>> jsonList = currentFavorites.map((song) => song.toMap()).toList();
      await prefs.setString(_favoriteSongsKey, jsonEncode(jsonList));

      return true;
    } catch (e) {
      print('Error adding song to favorites: $e');
      return false;
    }
  }

  // Remove a song from favorites
  Future<bool> removeFromFavorites(SongData song) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<SongData> currentFavorites = await getFavoriteSongs();

      // Remove the song if it exists
      currentFavorites.removeWhere((favSong) => favSong.id == song.id);

      // Convert list to JSON and save
      List<Map<String, dynamic>> jsonList = currentFavorites.map((song) => song.toMap()).toList();
      await prefs.setString(_favoriteSongsKey, jsonEncode(jsonList));

      return true;
    } catch (e) {
      print('Error removing song from favorites: $e');
      return false;
    }
  }

  // Toggle favorite status
  Future<bool> toggleFavorite(SongData song) async {
    final bool isFavorite = await isSongFavorite(song);

    if (isFavorite) {
      return await removeFromFavorites(song);
    } else {
      return await addToFavorites(song);
    }
  }
}