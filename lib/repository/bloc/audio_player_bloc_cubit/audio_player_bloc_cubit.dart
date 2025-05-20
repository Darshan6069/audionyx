import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:dio/dio.dart';
import '../../../domain/lyrics_model/lyrics_model.dart';
import '../../service/song_service/audio_service/audio_service.dart';
import 'audio_player_state.dart';

class AudioPlayerBlocCubit extends Cubit<AudioPlayerState> {
  final AudioPlayerService service = AudioPlayerService();
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  AudioPlayerBlocCubit() : super(AudioPlayerState.initial()) {
    service.positionStream.listen((position) {
      emit(state.copyWith(position: position));
    });

    service.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      emit(state.copyWith(isPlaying: isPlaying));

      if (playerState.processingState == ProcessingState.completed &&
          state.songList != null &&
          state.currentIndex < state.songList!.length - 1) {
        playNext(state.songList!);
      }
    });
  }

  Future<void> loadAndPlay(SongData song, List<SongData> songList, int index) async {
    emit(state.copyWith(isLoading: true, hasError: false));
    try {
      // Fetch and parse lyrics from subtitleUrl
      List<Lyric> lyrics = [];
      if (song.subtitleUrl.isNotEmpty) {
        try {
          final response = await _dio.get(song.subtitleUrl);
          if (response.statusCode == 200) {
            lyrics = LyricParser.parseLyrics(response.data);
          } else {
            print('Failed to fetch lyrics for ${song.title}: ${response.statusCode}');
          }
        } catch (e) {
          print('Error fetching lyrics for ${song.title}: $e');
        }
      }

      await service.initPlayer(song);
      emit(
        state.copyWith(
          duration: service.duration,
          position: service.position,
          isPlaying: true,
          currentSong: song,
          songList: songList,
          currentIndex: index,
          trackTitle: song.title,
          isLoading: false,
          hasError: false,
          lyrics: lyrics,
          showLyrics: false,
        ),
      );
    } catch (e) {
      print('Error loading song ${song.title}: $e');
      emit(state.copyWith(isLoading: false, hasError: true, currentSong: null, lyrics: const []));
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

  Future<void> playNext(List<SongData> songList) async {
    service.playNext(songList);
    final newIndex = service.currentIndex;
    List<Lyric> newLyrics = [];
    if (songList[newIndex].subtitleUrl.isNotEmpty) {
      try {
        final response = await _dio.get(songList[newIndex].subtitleUrl);
        if (response.statusCode == 200) {
          newLyrics = LyricParser.parseLyrics(response.data);
        } else {
          print('Failed to fetch lyrics for next song: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching lyrics for next song: $e');
      }
    }
    emit(
      state.copyWith(
        currentSong: songList[newIndex],
        currentIndex: newIndex,
        trackTitle: songList[newIndex].title,
        duration: service.duration,
        position: Duration.zero,
        isPlaying: service.isPlaying,
        lyrics: newLyrics,
        showLyrics: false,
      ),
    );
  }

  Future<void> playPrevious(List<SongData> songList) async {
    service.playPrevious(songList);
    final newIndex = service.currentIndex;
    List<Lyric> newLyrics = [];
    if (songList[newIndex].subtitleUrl.isNotEmpty) {
      try {
        final response = await _dio.get(songList[newIndex].subtitleUrl);
        if (response.statusCode == 200) {
          newLyrics = LyricParser.parseLyrics(response.data);
        } else {
          print('Failed to fetch lyrics for previous song: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching lyrics for previous song: $e');
      }
    }
    emit(
      state.copyWith(
        currentSong: songList[newIndex],
        currentIndex: newIndex,
        trackTitle: songList[newIndex].title,
        duration: service.duration,
        position: Duration.zero,
        isPlaying: service.isPlaying,
        lyrics: newLyrics,
        showLyrics: false,
      ),
    );
  }

  void toggleShuffle() {
    service.toggleShuffle();
    emit(state.copyWith(isShuffling: service.isShuffling));
  }

  void toggleRepeat() {
    service.toggleRepeatMode();
    emit(state.copyWith(loopMode: service.loopMode));
  }

  void toggleLyrics() {
    emit(state.copyWith(showLyrics: !state.showLyrics));
  }

  void dispose() {
    service.dispose();
    _dio.close();
  }
}
