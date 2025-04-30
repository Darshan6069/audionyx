// cubits/playlist_cubit.dart
import 'dart:convert';
import 'package:audionyx/domain/song_model/playlist_model.dart';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'playlist_state.dart';

class PlaylistBlocCubit extends Cubit<PlaylistState> {
  PlaylistBlocCubit() : super(const PlaylistState.initial()) {
    _loadPlaylists();
  }

  /// Load playlists from shared_preferences
  Future<void> _loadPlaylists() async {
    emit(const PlaylistState.loading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? playlistsJson = prefs.getString('playlists');
      if (playlistsJson != null) {
        final List<dynamic> decoded = jsonDecode(playlistsJson);
        final playlists = decoded.map((json) => PlaylistModel.fromJson(json)).toList();
        emit(PlaylistState.success(List.unmodifiable(playlists)));
      } else {
        emit(const PlaylistState.success([]));
      }
    } catch (e) {
      emit(PlaylistState.failure('Failed to load playlists: $e'));
    }
  }

  /// Save playlists to shared_preferences
  Future<void> _savePlaylists(List<PlaylistModel> playlists) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = jsonEncode(playlists.map((p) => p.toJson()).toList());
      await prefs.setString('playlists', encoded);
    } catch (e) {
      emit(PlaylistState.failure('Failed to save playlists: $e'));
      rethrow;
    }
  }

  /// Create a new playlist
  Future<void> createPlaylist(String name) async {
    if (state is! PlaylistSuccess) return;
    final currentPlaylists = (state as PlaylistSuccess).playlists;

    if (name.isEmpty || currentPlaylists.any((p) => p.name == name)) {
      emit(const PlaylistState.failure('Playlist name is empty or already exists'));
      return;
    }

    final newPlaylist = PlaylistModel(name: name, id: '');
    final updatedPlaylists = [...currentPlaylists, newPlaylist];

    try {
      await _savePlaylists(updatedPlaylists);
      emit(PlaylistState.success(List.unmodifiable(updatedPlaylists)));
    } catch (_) {}
  }

  /// Add a song to a playlist
  Future<void> addSongToPlaylist(String playlistName, SongData song) async {
    if (state is! PlaylistSuccess) return;
    final currentPlaylists = (state as PlaylistSuccess).playlists;

    final updatedPlaylists = currentPlaylists.map((p) {
      if (p.name == playlistName && !p.songs.any((s) => s.id == song.id)) {
        return PlaylistModel(name: p.name, songs: [...p.songs, song], id: '');
      }
      return p;
    }).toList();

    try {
      await _savePlaylists(updatedPlaylists);
      emit(PlaylistState.success(List.unmodifiable(updatedPlaylists)));
    } catch (_) {}
  }

  /// Remove a song from a playlist
  Future<void> removeSongFromPlaylist(String playlistName, SongData song) async {
    if (state is! PlaylistSuccess) return;
    final currentPlaylists = (state as PlaylistSuccess).playlists;

    final updatedPlaylists = currentPlaylists.map((p) {
      if (p.name == playlistName) {
        return PlaylistModel(
          name: p.name,
          songs: p.songs.where((s) => s.id != song.id).toList(), id: '',
        );
      }
      return p;
    }).toList();

    try {
      await _savePlaylists(updatedPlaylists);
      emit(PlaylistState.success(List.unmodifiable(updatedPlaylists)));
    } catch (_) {}
  }

  /// Delete an entire playlist
  Future<void> deletePlaylist(String playlistName) async {
    if (state is! PlaylistSuccess) return;
    final currentPlaylists = (state as PlaylistSuccess).playlists;

    final updatedPlaylists =
    currentPlaylists.where((p) => p.name != playlistName).toList();

    try {
      await _savePlaylists(updatedPlaylists);
      emit(PlaylistState.success(List.unmodifiable(updatedPlaylists)));
    } catch (_) {}
  }
}
