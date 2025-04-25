import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_song_state.freezed.dart';

@freezed
class UploadSongState with _$UploadSongState {
  const factory UploadSongState.initial({
    @Default(false) bool isSongPicked,
    @Default(false) bool isThumbnailPicked,
    @Default('') String songFileName,
    @Default('') String thumbnailFileName,
  }) = UploadSongInitial;

  const factory UploadSongState.loading() = UploadSongLoading;

  const factory UploadSongState.success(String message) = UploadSongSuccess;

  const factory UploadSongState.failure(String error) = UploadSongFailure;
}