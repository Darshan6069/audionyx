import 'package:just_audio/just_audio.dart';
import '../../../../domain/song_model/song_model.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  bool isPlaying = false;
  int currentIndex = 0;

  AudioPlayer get player => _player;

  // Initialize the player with the current song
  Future<void> initPlayer(SongData song) async {
    try {
      if (song.isUrl) {
        await _player.setUrl(song.path);
      } else {
        await _player.setFilePath(song.path);
      }
      duration = _player.duration ?? Duration.zero;
    } catch (e) {
      print("Error initializing audio: $e");
    }
  }

  // Toggle play/pause
  void togglePlayPause() {
    if (isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  // Seek to a specific position
  void seekTo(Duration position) {
    _player.seek(position);
  }

  // Play next song
  void playNext(List<SongData> songList) {
    if (currentIndex + 1 < songList.length) {
      currentIndex++;
      initPlayer(songList[currentIndex]);
    }
  }

  // Play previous song
  void playPrevious(List<SongData> songList) {
    if (currentIndex > 0) {
      currentIndex--;
      initPlayer(songList[currentIndex]);
    }
  }

  // Dispose the player when done
  void dispose() {
    _player.dispose();
  }

  // Listen to the position stream and update position
  Stream<Duration> get positionStream => _player.positionStream;

  // Listen to player state changes (playing/paused)
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
}
