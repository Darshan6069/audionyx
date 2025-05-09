import 'package:just_audio/just_audio.dart';
import 'package:audionyx/domain/song_model/song_model.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();
  int currentIndex = 0;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  bool isPlaying = false;
  bool isShuffling = false;
  LoopMode loopMode = LoopMode.off;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Future<void> initPlayer(SongData song) async {
    try {
      await _player.setUrl(song.mp3Url);
      duration = (await _player.load()) ?? Duration.zero;
      isPlaying = false; // Reset playing state
      play(); // Start playing after loading
    } catch (e) {
      // Handle errors (e.g., invalid URL, network issues)
      print('Error initializing player: $e');
      duration = Duration.zero;
      isPlaying = false;
    }
  }

  void play() {
    _player.play();
    isPlaying = true;
  }

  void pause() {
    _player.pause();
    isPlaying = false;
  }

  void togglePlayPause() {
    if (_player.playing) {
      pause();
    } else {
      play();
    }
  }

  void seekTo(Duration position) => _player.seek(position);

  void playNext(List<SongData> songList) {
    if (songList.isEmpty) {
      // Handle empty list
      pause();
      currentIndex = 0;
      duration = Duration.zero;
      isPlaying = false;
      return;
    }

    if (isShuffling) {
      // Implement shuffle logic if needed
      currentIndex = (currentIndex + 1) % songList.length;
    } else if (currentIndex < songList.length - 1) {
      currentIndex++;
    } else {
      // Loop to the first song or stop
      currentIndex = 0; // Loop to start
      if (loopMode != LoopMode.all) {
        pause();
        isPlaying = false;
        return;
      }
    }

    initPlayer(songList[currentIndex]);
  }

  void playPrevious(List<SongData> songList) {
    if (songList.isEmpty) {
      // Handle empty list
      pause();
      currentIndex = 0;
      duration = Duration.zero;
      isPlaying = false;
      return;
    }

    if (currentIndex > 0) {
      currentIndex--;
    } else {
      // Loop to the last song or stop
      currentIndex = songList.length - 1; // Loop to end
      if (loopMode != LoopMode.all) {
        pause();
        isPlaying = false;
        return;
      }
    }

    initPlayer(songList[currentIndex]);
  }

  void toggleShuffle() {
    isShuffling = !isShuffling;
    _player.setShuffleModeEnabled(isShuffling);
  }

  void toggleRepeatMode() {
    if (loopMode == LoopMode.off) {
      loopMode = LoopMode.one;
    } else if (loopMode == LoopMode.one) {
      loopMode = LoopMode.all;
    } else {
      loopMode = LoopMode.off;
    }
    _player.setLoopMode(loopMode);
  }

  void dispose() => _player.dispose();
}