import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audionyx/domain/song_model/song_model.dart';
import '../../service/song_service/audio_service/audio_service.dart';
import 'audio_player_state.dart';

class AudioPlayerBlocCubit extends Cubit<AudioPlayerState> {
  final AudioPlayerService service = AudioPlayerService();

  AudioPlayerBlocCubit() : super(AudioPlayerState.initial()) {
    service.positionStream.listen((position) {
      emit(state.copyWith(position: position));
    });

    service.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      emit(state.copyWith(isPlaying: isPlaying));

      // Handle song completion
      if (playerState.processingState == ProcessingState.completed &&
          state.songList != null &&
          state.currentIndex < state.songList!.length - 1) {
        playNext(state.songList!);
      }
    });
  }

  Future<void> loadAndPlay(SongData song, List<SongData> songList, int index) async {
    emit(state.copyWith(isLoading: true, hasError: false)); // Set loading state
    try {
      await service.initPlayer(song);
      emit(state.copyWith(
        duration: service.duration,
        position: service.position,
        isPlaying: true,
        currentSong: song,
        songList: songList,
        currentIndex: index,
        trackTitle: song.title,
        isLoading: false,
        hasError: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        currentSong: null,
      ));
    }
  }

  void togglePlayPause() {
    service.togglePlayPause();
    emit(state.copyWith(isPlaying: service.isPlaying));
  }

  void seekTo(Duration position) {
    service.seekTo(position);
    emit(state.copyWith(position: position));
  }

  void playNext(List<SongData> songList) {
    service.playNext(songList);
    final newIndex = service.currentIndex;
    emit(state.copyWith(
      currentSong: songList[newIndex],
      currentIndex: newIndex,
      trackTitle: songList[newIndex].title,
      duration: service.duration,
      position: Duration.zero,
      isPlaying: service.isPlaying,
    ));
  }

  void playPrevious(List<SongData> songList) {
    service.playPrevious(songList);
    final newIndex = service.currentIndex;
    emit(state.copyWith(
      currentSong: songList[newIndex],
      currentIndex: newIndex,
      trackTitle: songList[newIndex].title,
      duration: service.duration,
      position: Duration.zero,
      isPlaying: service.isPlaying,
    ));
  }

  void toggleShuffle() {
    service.toggleShuffle();
    emit(state.copyWith(isShuffling: service.isShuffling));
  }

  void toggleRepeat() {
    service.toggleRepeatMode();
    emit(state.copyWith(loopMode: service.loopMode));
  }

  void dispose() {
    service.dispose();
  }

}