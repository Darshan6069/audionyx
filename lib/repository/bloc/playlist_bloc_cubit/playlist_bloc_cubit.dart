import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audionyx/repository/service/song_service/playlist_service/playlist_service.dart';
import 'playlist_state.dart';

class PlaylistBlocCubit extends Cubit<PlaylistState> {
  final PlaylistService _playlistService;

  PlaylistBlocCubit(this._playlistService) : super(const PlaylistState.initial());

  Future<void> fetchPlaylists() async {
    emit(const PlaylistState.loading());
    try {
      final playlists = await _playlistService.fetchUserPlaylists();
      emit(PlaylistState.success(playlists));
    } catch (e) {
      emit(PlaylistState.failure(e.toString()));
    }
  }

  Future<void> createPlaylist(String name) async {
    emit(const PlaylistState.loading());
    try {
      await _playlistService.createPlaylist(name);
      final playlists = await _playlistService.fetchUserPlaylists();
      emit(PlaylistState.success(playlists, isNewPlaylistCreated: true));
    } catch (e) {
      emit(PlaylistState.failure(e.toString()));
    }
  }

  Future<void> deletePlaylist(String playlistId) async {
    emit(const PlaylistState.loading());
    try {
      await _playlistService.deletePlaylist(playlistId);
      final playlists = await _playlistService.fetchUserPlaylists();
      emit(PlaylistState.success(playlists));
    } catch (e) {
      emit(PlaylistState.failure(e.toString()));
    }
  }

  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    emit(const PlaylistState.loading());
    try {
      await _playlistService.addSongToPlaylist(playlistId, songId);
      final playlists = await _playlistService.fetchUserPlaylists();
      emit(PlaylistState.success(playlists));
    } catch (e) {
      emit(PlaylistState.failure('Failed to add song: ${e.toString()}'));
    }
  }

  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    emit(const PlaylistState.loading());
    try {
      final success = await _playlistService.removeSongFromPlaylist(playlistId, songId);
      if (!success) throw Exception('Failed to remove song');
      final playlists = await _playlistService.fetchUserPlaylists();
      emit(PlaylistState.success(playlists));
    } catch (e) {
      emit(PlaylistState.failure('Failed to remove song: ${e.toString()}'));
    }
  }

  Future<void> fetchSongsFromPlaylist(String playlistId) async {
    emit(const PlaylistState.loading());
    try {
      final List<SongData> songs = await _playlistService.fetchSongsFromPlaylist(playlistId);
      emit(PlaylistState.songsFetched(songs));
    } catch (e) {
      emit(PlaylistState.failure('Failed to fetch songs: ${e.toString()}'));
    }
  }
}