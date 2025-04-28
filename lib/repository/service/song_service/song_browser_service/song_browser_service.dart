import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:audionyx/repository/service/song_service/recently_play_song/recently_played_manager.dart';
import 'package:audionyx/song_play_screen.dart';
import 'package:flutter/material.dart';

class SongBrowserService {
  List<String> getUniqueGenres(List<SongData> songs) {
    return songs.map((e) => e.genre).toSet().toList()..sort();
  }

  List<String> getUniqueArtists(List<SongData> songs) {
    return songs.map((e) => e.artist).toSet().toList()..sort();
  }

  List<String> getUniqueAlbums(List<SongData> songs) {
    return songs.map((e) => e.album).toSet().toList()..sort();
  }

  List<SongData> filterSongs(
      List<SongData> songs,
      String searchQuery,
      String? genre,
      String? artist,
      String? album,
      ) {
    return songs.where((song) {
      final matchesSearch = searchQuery.isEmpty ||
          song.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          song.artist.toLowerCase().contains(searchQuery.toLowerCase()) ||
          song.album.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesGenre = genre == null || song.genre == genre;
      final matchesArtist = artist == null || song.artist == artist;
      final matchesAlbum = album == null || song.album == album;

      return matchesSearch && matchesGenre && matchesArtist && matchesAlbum;
    }).toList();
  }

  Future<void> playSong(BuildContext context, SongData song, int index, List<SongData> songs) async {
    await RecentlyPlayedManager.addSongToRecentlyPlayed(song);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongPlayerScreen(
          songList: songs,
          initialIndex: index,
        ),
      ),
    );
  }
}
