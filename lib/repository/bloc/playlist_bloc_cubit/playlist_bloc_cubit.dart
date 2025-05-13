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

  Future<void> fetchSongsFromPlaylist(String playlistId) async {
    try {
      emit(PlaylistLoading());
      final songs = await _playlistService.fetchSongsFromPlaylist(playlistId);
      emit(PlaylistSongsFetched(songs));
    } catch (e) {
      emit(PlaylistFailure('Failed to fetch songs: $e'));
    }
  }

  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    try {
      // Call the service to remove the song
      await _playlistService.removeSongFromPlaylist(playlistId, songId);

      // Fetch the updated song list
      final updatedSongs = await _playlistService.fetchSongsFromPlaylist(playlistId);
      emit(PlaylistSongsFetched(updatedSongs));
    } catch (e) {
      emit(PlaylistFailure('Failed to remove song: $e'));
    }
  }
}