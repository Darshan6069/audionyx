import 'package:audionyx/repository/service/song_service/playlist_service/playlist_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'playlist_state.dart';

class PlaylistBlocCubit extends Cubit<PlaylistState> {
  final PlaylistService _playlistService;

  PlaylistBlocCubit(this._playlistService) : super(const PlaylistState.initial()) {
    print('PlaylistBlocCubit initialized: $hashCode');
  }

  Future<void> fetchPlaylists() async {
    print('Fetching playlists');
    emit(const PlaylistState.loading());
    try {
      final playlists = await _playlistService.fetchUserPlaylists();
      print('Playlists fetched: ${playlists.length}');
      emit(PlaylistState.success(playlists));
    } catch (e) {
      print('Fetch playlists error: $e');
      emit(PlaylistState.failure(e.toString()));
    }
  }

  Future<void> createPlaylist(String name) async {
    print('Creating playlist: $name');
    emit(const PlaylistState.loading());
    try {
      await _playlistService.createPlaylist(name);
      final playlists = await _playlistService.fetchUserPlaylists();
      print('Playlist created, fetched ${playlists.length} playlists');
      emit(PlaylistState.success(playlists, isNewPlaylistCreated: true));
    } catch (e) {
      print('Create playlist error: $e');
      emit(PlaylistState.failure(e.toString()));
    }
  }

  Future<void> deletePlaylist(String playlistId) async {
    print('Deleting playlist: $playlistId');
    emit(const PlaylistState.loading());
    try {
      await _playlistService.deletePlaylist(playlistId);
      final playlists = await _playlistService.fetchUserPlaylists();
      print('Playlist deleted, fetched ${playlists.length} playlists');
      emit(PlaylistState.success(playlists));
    } catch (e) {
      print('Delete playlist error: $e');
      emit(PlaylistState.failure(e.toString()));
    }
  }

  Future<void> addSongToPlaylist(String playlistId, List<String> songIds) async {
    print('Adding songs to playlist $playlistId: $songIds');
    emit(const PlaylistState.loading());
    try {
      await _playlistService.addSongToPlaylist(playlistId, songIds);
      final songs = await _playlistService.fetchSongsFromPlaylist(playlistId);
      final playlists = await _playlistService.fetchUserPlaylists();
      print('Songs added, fetched ${songs.length} songs and ${playlists.length} playlists');
      emit(PlaylistState.songsFetched(songs));
      emit(PlaylistState.success(playlists));
    } catch (e) {
      print('Add songs error: $e');
      emit(PlaylistState.failure('Failed to add songs: ${e.toString()}'));
    }
  }

  Future<void> fetchSongsFromPlaylist(String playlistId) async {
    print('Fetching songs for playlist: $playlistId');
    try {
      emit(const PlaylistState.loading());
      final songs = await _playlistService.fetchSongsFromPlaylist(playlistId);
      print('Songs fetched: ${songs.length}');
      emit(PlaylistState.songsFetched(songs));
    } catch (e) {
      print('Fetch songs error: $e');
      emit(PlaylistState.failure('Failed to fetch songs: $e'));
    }
  }

  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    print('Removing song $songId from playlist $playlistId');
    try {
      await _playlistService.removeSongFromPlaylist(playlistId, songId);
      final updatedSongs = await _playlistService.fetchSongsFromPlaylist(playlistId);
      final playlists = await _playlistService.fetchUserPlaylists();
      print('Song removed, fetched ${updatedSongs.length} songs and ${playlists.length} playlists');
      emit(PlaylistState.songsFetched(updatedSongs));
      emit(PlaylistState.success(playlists));
    } catch (e) {
      print('Remove song error: $e');
      emit(PlaylistState.failure('Failed to remove song: $e'));
    }
  }
}
