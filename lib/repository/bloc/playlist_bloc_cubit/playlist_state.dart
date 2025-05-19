import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/song_model/song_model.dart';

part 'playlist_state.freezed.dart';

@freezed
class PlaylistState with _$PlaylistState {
  const factory PlaylistState.initial() = PlaylistInitial;
  const factory PlaylistState.loading() = PlaylistLoading;
  const factory PlaylistState.success(
    List<dynamic> playlists, {
    @Default(false) bool isNewPlaylistCreated,
  }) = PlaylistSuccess;
  const factory PlaylistState.songsFetched(List<SongData> songs) =
      PlaylistSongsFetched;
  const factory PlaylistState.failure(String error) = PlaylistFailure;
}
