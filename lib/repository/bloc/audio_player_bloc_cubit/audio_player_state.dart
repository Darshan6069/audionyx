import 'package:just_audio/just_audio.dart';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'dart:typed_data';

import '../../../lyrics_model.dart';

class AudioPlayerState {
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final bool isShuffling;
  final LoopMode loopMode;
  final Uint8List? albumArt;
  final String? trackTitle;
  final SongData? currentSong;
  final List<SongData>? songList;
  final int currentIndex;
  final bool isLoading;
  final bool hasError;
  final List<Lyric> lyrics;
  final bool showLyrics;

  AudioPlayerState({
    required this.position,
    required this.duration,
    required this.isPlaying,
    required this.isShuffling,
    required this.loopMode,
    this.albumArt,
    this.trackTitle,
    this.currentSong,
    this.songList,
    required this.currentIndex,
    required this.isLoading,
    required this.hasError,
    this.lyrics = const [],
    this.showLyrics = false,
  });

  factory AudioPlayerState.initial() => AudioPlayerState(
    position: Duration.zero,
    duration: Duration.zero,
    isPlaying: false,
    isShuffling: false,
    loopMode: LoopMode.off,
    albumArt: null,
    trackTitle: null,
    currentSong: null,
    songList: null,
    currentIndex: 0,
    isLoading: false,
    hasError: false,
    lyrics: const [],
    showLyrics: false,
  );

  AudioPlayerState copyWith({
    Duration? position,
    Duration? duration,
    bool? isPlaying,
    bool? isShuffling,
    LoopMode? loopMode,
    Uint8List? albumArt,
    String? trackTitle,
    SongData? currentSong,
    List<SongData>? songList,
    int? currentIndex,
    bool? isLoading,
    bool? hasError,
    List<Lyric>? lyrics,
    bool? showLyrics,
  }) {
    return AudioPlayerState(
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
      isShuffling: isShuffling ?? this.isShuffling,
      loopMode: loopMode ?? this.loopMode,
      albumArt: albumArt ?? this.albumArt,
      trackTitle: trackTitle ?? this.trackTitle,
      currentSong: currentSong ?? this.currentSong,
      songList: songList ?? this.songList,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      lyrics: lyrics ?? this.lyrics,
      showLyrics: showLyrics ?? this.showLyrics,
    );
  }
}