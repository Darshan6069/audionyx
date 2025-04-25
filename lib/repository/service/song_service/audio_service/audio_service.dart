import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioService extends ChangeNotifier {
  final List<dynamic> downloadedFiles;
  late AudioPlayer _player;
  late Duration _position;
  late Duration _duration;
  late bool _isPlaying;
  late int _currentIndex;

  AudioService({
    required this.downloadedFiles,
    required int initialIndex,
  }) {
    _player = AudioPlayer();
    _position = Duration.zero;
    _duration = Duration.zero;
    _isPlaying = false;
    _currentIndex = initialIndex;
    _init();
  }

  Duration get position => _position;
  Duration get duration => _duration;
  bool get isPlaying => _isPlaying;
  int get currentIndex => _currentIndex;

  Future<void> _init() async {
    try {
      await _player.setFilePath(downloadedFiles[_currentIndex].path);
      _duration = _player.duration ?? Duration.zero;

      _player.positionStream.listen((pos) {
        _position = pos;
        notifyListeners();
      });

      _player.playerStateStream.listen((state) {
        _isPlaying = state.playing;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Error loading audio: $e');
    }
  }

  void playNext() {
    if (_currentIndex + 1 < downloadedFiles.length) {
      _currentIndex++;
      _init();
      notifyListeners();
    }
  }

  void playPrevious() {
    if (_currentIndex - 1 >= 0) {
      _currentIndex--;
      _init();
      notifyListeners();
    }
  }

  void togglePlayPause() {
    if (_isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
    notifyListeners();
  }

  void seek(Duration position) {
    _player.seek(position);
    notifyListeners();
  }

  void dispose() {
    _player.dispose();
    super.dispose();
  }
}