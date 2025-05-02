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
    await _player.setUrl(song.mp3Url);
    duration = await _player.load() ?? Duration.zero;
    play();
  }

  void play() => _player.play();
  void pause() => _player.pause();
  void togglePlayPause() => _player.playing ? pause() : play();

  void seekTo(Duration position) => _player.seek(position);

  void playNext(List<SongData> songList) {
    if (currentIndex < songList.length - 1) {
      currentIndex++;
      initPlayer(songList[currentIndex]);
    }
  }

  void playPrevious(List<SongData> songList) {
    if (currentIndex > 0) {
      currentIndex--;
      initPlayer(songList[currentIndex]);
    }
  }

  void toggleShuffle() {
    isShuffling = !isShuffling;
    _player.setShuffleModeEnabled(isShuffling);
  }

  void toggleRepeatMode() {
    if (loopMode == LoopMode.off) {
      loopMode = LoopMode.one;
    } else {
      loopMode = LoopMode.off;
    }
    _player.setLoopMode(loopMode);
  }

  void dispose() => _player.dispose();
}
