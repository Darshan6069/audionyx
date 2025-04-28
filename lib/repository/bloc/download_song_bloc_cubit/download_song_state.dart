import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_song_state.freezed.dart';

@freezed
class DownloadSongState with _$DownloadSongState {
  const factory DownloadSongState.initial() = DownloadSongInitial;
  const factory DownloadSongState.downloading() = DownloadSongDownloading;
  const factory DownloadSongState.success() = DownloadSongSuccess;
  const factory DownloadSongState.failure(String error) = DownloadSongFailure;
}
