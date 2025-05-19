import 'package:audionyx/repository/bloc/download_song_bloc_cubit/download_song_state.dart';
import 'package:audionyx/repository/service/song_service/download_song/download_song.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/song_model/song_model.dart';
import 'package:flutter/material.dart';

class DownloadSongBlocCubit extends Cubit<DownloadSongState> {
  final DownloadSong _downloadSongService = DownloadSong();

  DownloadSongBlocCubit() : super(const DownloadSongState.initial());

  Future<void> downloadSong({
    required String url,
    required String fileName,
    required String thumbnailUrl,
    required SongData songData,
    required BuildContext context,
  }) async {
    emit(const DownloadSongState.downloading());
    try {
      await _downloadSongService.downloadSong(
        url,
        fileName,
        thumbnailUrl,
        songData,
        context,
      );
      emit(const DownloadSongState.success());
    } catch (e) {
      emit(DownloadSongState.failure(e.toString()));
    }
  }
}
