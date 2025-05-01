
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../domain/song_model/song_model.dart';

class RecentlyPlayedManager {
  static List<SongData> recentlyPlayed = [];

  static Future<List<SongData>> loadRecentlyPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    final songsJson = prefs.getStringList('recentlyPlayed') ?? [];
    recentlyPlayed = songsJson
        .map((e) => SongData.fromJson(json.decode(e)))
        .toList();
    return recentlyPlayed;
  }

  static Future<void> addSongToRecentlyPlayed(SongData song) async {
    final prefs = await SharedPreferences.getInstance();

    // Remove if already exists (avoid duplicates)
    recentlyPlayed.removeWhere((s) => s.id == song.id);

    // Add at the start
    recentlyPlayed.insert(0, song);

    // Limit list to, say, last 10 songs
    if (recentlyPlayed.length > 10) {
      recentlyPlayed = recentlyPlayed.sublist(0, 10);
    }

    // Save updated list
    final songsJson = recentlyPlayed
        .map((e) => json.encode(e.toMap()))
        .toList();
    await prefs.setStringList('recentlyPlayed', songsJson);
  }
}
