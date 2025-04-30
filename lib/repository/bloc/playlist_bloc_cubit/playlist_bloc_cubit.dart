import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_state.dart';
import 'package:audionyx/repository/service/song_service/playlist_service/playlist_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class PlaylistBlocCubit extends Cubit<PlaylistState> {
  final PlaylistService _playlistService ;

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
      emit(PlaylistState.success(playlists));
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
}