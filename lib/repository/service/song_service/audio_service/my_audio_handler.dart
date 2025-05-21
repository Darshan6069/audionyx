import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  MyAudioHandler() {
    // Listen for changes and broadcast state/position updates
    _player.playerStateStream.listen(_broadcastState);
    _player.positionStream.listen((pos) {
      playbackState.add(playbackState.value.copyWith(updatePosition: pos));
    });
  }

  // Play a song and update lock screen metadata
  Future<void> playSong({
    required String id,
    required String title,
    String? artist,
    String? album,
    String? artUri,
    required String url,
  }) async {
    mediaItem.add(
      MediaItem(
        id: id,
        title: title,
        artist: artist,
        album: album,
        artUri: artUri != null ? Uri.parse(artUri) : null,
        extras: {'url': url},
      ),
    );
    await _player.setUrl(url);
    await _player.play();
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  void _broadcastState(PlayerState state) {
    final playing = state.playing;
    final processingState = state.processingState;

    PlaybackState audioState;
    switch (processingState) {
      case ProcessingState.loading:
      case ProcessingState.buffering:
        audioState = PlaybackState(
          controls: [MediaControl.pause],
          playing: playing,
          processingState: AudioProcessingState.buffering,
          updatePosition: _player.position,
        );
        break;
      case ProcessingState.ready:
        audioState = PlaybackState(
          controls:
              playing
                  ? [MediaControl.pause, MediaControl.stop]
                  : [MediaControl.play, MediaControl.stop],
          playing: playing,
          processingState: AudioProcessingState.ready,
          updatePosition: _player.position,
        );
        break;
      case ProcessingState.completed:
        audioState = PlaybackState(
          controls: [MediaControl.stop],
          playing: false,
          processingState: AudioProcessingState.completed,
          updatePosition: _player.position,
        );
        break;
      default:
        audioState = PlaybackState(
          controls: [MediaControl.play],
          playing: false,
          processingState: AudioProcessingState.idle,
          updatePosition: _player.position,
        );
    }
    playbackState.add(audioState);
  }

  @override
  Future<void> skipToNext() async {
    // Implement if using a queue
  }

  @override
  Future<void> skipToPrevious() async {
    // Implement if using a queue
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    await _player.setShuffleModeEnabled(shuffleMode == AudioServiceShuffleMode.all);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.one:
        await _player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.all:
        await _player.setLoopMode(LoopMode.all);
        break;
      default:
        await _player.setLoopMode(LoopMode.off);
    }
  }

  @override
  Future<void> onTaskRemoved() async {
    await stop();
  }

  @override
  Future<void> onClose() async {
    await _player.dispose();
  }
}
