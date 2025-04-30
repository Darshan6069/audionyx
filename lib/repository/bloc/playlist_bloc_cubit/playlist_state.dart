import 'package:freezed_annotation/freezed_annotation.dart';

part 'playlist_state.freezed.dart';

@freezed
class PlaylistState with _$PlaylistState {
  const factory PlaylistState.initial() = PlaylistInitial;
  const factory PlaylistState.loading() = PlaylistLoading;
  const factory PlaylistState.success(List<dynamic> playlists) = PlaylistSuccess;
  const factory PlaylistState.failure(String error) = PlaylistFailure;
}