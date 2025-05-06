import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:audionyx/repository/service/song_service/recently_play_song/recently_played_manager.dart';
import 'package:flutter/material.dart';

import '../../../../presentation/song_play_screen/song_play_screen.dart';

class SongBrowserService {
  List<String> getUniqueGenres(List<SongData> songs) {
    final genres = songs.map((e) => e.genre).toSet().toList()..sort();
    return genres.where((genre) => genre.isNotEmpty).toList();
  }

  List<String> getUniqueArtists(List<SongData> songs) {
    final artists = songs.map((e) => e.artist).toSet().toList()..sort();
    return artists.where((artist) => artist.isNotEmpty).toList();
  }

  List<String> getUniqueAlbums(List<SongData> songs) {
    final albums = songs.map((e) => e.album).toSet().toList()..sort();
    return albums.where((album) => album.isNotEmpty).toList();
  }

  List<SongData> filterSongs(
      List<SongData> songs,
      String searchQuery,
      String? genre,
      String? artist,
      String? album,
      ) {
    if (searchQuery.isEmpty && genre == null && artist == null && album == null) {
      return songs;
    }

    final normalizedQuery = searchQuery.toLowerCase().trim();

    return songs.where((song) {
      // Handle search query - match against multiple fields with weighted relevance
      final matchesSearch = searchQuery.isEmpty ||
          song.title.toLowerCase().contains(normalizedQuery) ||
          song.artist.toLowerCase().contains(normalizedQuery) ||
          song.album.toLowerCase().contains(normalizedQuery) ||
          song.genre.toLowerCase().contains(normalizedQuery);

      // Handle filters
      final matchesGenre = genre == null || song.genre == genre;
      final matchesArtist = artist == null || song.artist == artist;
      final matchesAlbum = album == null || song.album == album;

      return matchesSearch && matchesGenre && matchesArtist && matchesAlbum;
    }).toList();
  }

  Future<void> playSong(BuildContext context, SongData song, int index, List<SongData> songs) async {
    try {
      // Add to recently played
      await RecentlyPlayedManager.addSongToRecentlyPlayed(song);

      // Navigate to player screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SongPlayerScreen(
            songList: songs,
            initialIndex: index,
          ),
        ),
      );
    } catch (e) {
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error playing song: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Group songs by artist
  Map<String, List<SongData>> getSongsByArtist(List<SongData> songs) {
    final Map<String, List<SongData>> songsByArtist = {};

    for (final song in songs) {
      if (!songsByArtist.containsKey(song.artist)) {
        songsByArtist[song.artist] = [];
      }
      songsByArtist[song.artist]!.add(song);
    }

    return songsByArtist;
  }

  // Group songs by album
  Map<String, List<SongData>> getSongsByAlbum(List<SongData> songs) {
    final Map<String, List<SongData>> songsByAlbum = {};

    for (final song in songs) {
      if (!songsByAlbum.containsKey(song.album)) {
        songsByAlbum[song.album] = [];
      }
      songsByAlbum[song.album]!.add(song);
    }

    return songsByAlbum;
  }

  // Group songs by genre
  Map<String, List<SongData>> getSongsByGenre(List<SongData> songs) {
    final Map<String, List<SongData>> songsByGenre = {};

    for (final song in songs) {
      if (!songsByGenre.containsKey(song.genre)) {
        songsByGenre[song.genre] = [];
      }
      songsByGenre[song.genre]!.add(song);
    }

    return songsByGenre;
  }

  // Get songs with advanced search matching
  List<SongData> searchSongs(List<SongData> songs, String query) {
    if (query.isEmpty) {
      return songs;
    }

    final normalizedQuery = query.toLowerCase().trim();
    final List<SongData> result = [];
    final Map<SongData, int> matchScores = {};

    for (final song in songs) {
      int score = 0;

      // Direct title match (highest weight)
      if (song.title.toLowerCase() == normalizedQuery) {
        score += 100;
      } else if (song.title.toLowerCase().contains(normalizedQuery)) {
        score += 50;
      }

      // Artist match
      if (song.artist.toLowerCase() == normalizedQuery) {
        score += 40;
      } else if (song.artist.toLowerCase().contains(normalizedQuery)) {
        score += 20;
      }

      // Album match
      if (song.album.toLowerCase() == normalizedQuery) {
        score += 30;
      } else if (song.album.toLowerCase().contains(normalizedQuery)) {
        score += 15;
      }

      // Genre match
      if (song.genre.toLowerCase() == normalizedQuery) {
        score += 20;
      } else if (song.genre.toLowerCase().contains(normalizedQuery)) {
        score += 10;
      }

      // Add to results if there's any match
      if (score > 0) {
        matchScores[song] = score;
        result.add(song);
      }
    }

    // Sort by match score
    result.sort((a, b) => (matchScores[b] ?? 0).compareTo(matchScores[a] ?? 0));

    return result;
  }
}