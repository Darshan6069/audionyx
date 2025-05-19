import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/song_model/song_model.dart';

part 'fetch_song_state.freezed.dart';

@freezed
class FetchSongState with _$FetchSongState {
  const factory FetchSongState.initial() = FetchSongInitial;
  const factory FetchSongState.loading() = FetchSongLoading;
  const factory FetchSongState.success(List<SongData> songs) = FetchSongSuccess;
  const factory FetchSongState.failure(String error) = FetchSongFailure;
}
