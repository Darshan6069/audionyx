import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/song_service/upload_song_service/upload_song_service.dart';
import 'upload_song_state.dart';

class UploadSongBlocCubit extends Cubit<UploadSongState> {
  final UploadSongService uploadSongService = UploadSongService();

  UploadSongBlocCubit(  )
      : super(const UploadSongState.initial());

  Future<void> pickSongFile() async {
    try {
      await uploadSongService.pickSongFile();
      emit(UploadSongState.initial(
        isSongPicked: uploadSongService.songFileName != null,
        isThumbnailPicked: uploadSongService.thumbnailFileName != null,
        songFileName: uploadSongService.songFileName ?? '',
        thumbnailFileName: uploadSongService.thumbnailFileName ?? '',
      ));
    } catch (e) {
      emit(UploadSongState.failure(e.toString()));
    }
  }

  Future<void> pickThumbnailFile() async {
    try {
      await uploadSongService.pickThumbnailFile();
      emit(UploadSongState.initial(
        isSongPicked: uploadSongService.songFileName != null,
        isThumbnailPicked: uploadSongService.thumbnailFileName != null,
        songFileName: uploadSongService.songFileName ?? '',
        thumbnailFileName: uploadSongService.thumbnailFileName ?? '',
      ));
    } catch (e) {
      emit(UploadSongState.failure(e.toString()));
    }
  }

  Future<void> uploadSong({
    required String title,
    required String artist,
    required String album,
  }) async {
    emit(const UploadSongState.loading());
    try {
      final message = await uploadSongService.uploadSong(
        title: title,
        artist: artist,
        album: album,
      );
      emit(UploadSongState.success(message));
    // Reset to initial state with cleared file names
    emit(const UploadSongState.initial());
    } catch (e) {
    emit(UploadSongState.failure(e.toString()));
    }
  }
}