import 'package:audionyx/repository/bloc/fetch_song_bloc_cubit/fetch_song_state.dart';
import 'package:audionyx/repository/service/song_service/fetch_song_service/fetch_song_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class FetchSongBlocCubit extends Cubit<FetchSongState> {
  final FetchSongService _fetchSongService = FetchSongService();

  FetchSongBlocCubit() : super(const FetchSongState.initial());

  Future<void> fetchSongs() async {
    emit(const FetchSongState.loading());
    try {
      final songs = await _fetchSongService .fetchSongs();
      emit(FetchSongState.success(songs));
    } catch (e) {
      emit(FetchSongState.failure(e.toString()));
    }
  }
}