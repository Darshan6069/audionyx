import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'core/constants/theme_color.dart';

class SongPlayerScreen extends StatefulWidget {
  final List<SongData> songList;
  final int initialIndex;

  const SongPlayerScreen({
    super.key,
    required this.songList,
    required this.initialIndex,
  });

  @override
  State<SongPlayerScreen> createState() => _SongPlayerScreenState();
}

class _SongPlayerScreenState extends State<SongPlayerScreen> {
  late AudioPlayer _audioPlayer;
  late int currentIndex;
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    currentIndex = widget.initialIndex;
    _initAudio();
    _listenToAudioStreams();
  }

  Future<void> _initAudio() async {
    try {
      await _audioPlayer.setUrl(widget.songList[currentIndex].mp3Url);
      totalDuration = _audioPlayer.duration ?? Duration.zero;
      _audioPlayer.play();
      setState(() => isPlaying = true);
    } catch (e) {
      debugPrint('Audio init error: $e');
    }
  }

  void _listenToAudioStreams() {
    _audioPlayer.positionStream.listen((position) {
      setState(() => currentPosition = position);
    });

    _audioPlayer.durationStream.listen((duration) {
      setState(() => totalDuration = duration ?? Duration.zero);
    });

    _audioPlayer.playerStateStream.listen((state) {
      setState(() => isPlaying = state.playing);
    });
  }

  void _playPause() {
    isPlaying ? _audioPlayer.pause() : _audioPlayer.play();
  }

  Future<void> _playNext() async {
    if (currentIndex < widget.songList.length - 1) {
      currentIndex++;
      await _audioPlayer.setUrl(widget.songList[currentIndex].mp3Url);
      _audioPlayer.play();
    }
  }

  Future<void> _playPrevious() async {
    if (currentIndex > 0) {
      currentIndex--;
      await _audioPlayer.setUrl(widget.songList[currentIndex].mp3Url);
      _audioPlayer.play();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final song = widget.songList[currentIndex];

    return Scaffold(
      backgroundColor: ThemeColor.blackColor,
      appBar: AppBar(
        backgroundColor: ThemeColor.blackColor,
        title: const Text("Now Playing", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: song.thumbnailUrl,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
                placeholder:
                    (_, __) => Container(
                      color: Colors.grey.shade800,
                      height: 300,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
              ),
            ),
            const SizedBox(height: 24),

            /// Title and Artist
            Text(
              song.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              song.artist,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 24),

            /// Seekbar
            Slider(
              value: currentPosition.inSeconds.toDouble(),
              max: totalDuration.inSeconds.toDouble().clamp(1, double.infinity),
              onChanged:
                  (value) =>
                      _audioPlayer.seek(Duration(seconds: value.toInt())),
              activeColor: ThemeColor.lightGrey,
              inactiveColor: Colors.white24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTime(currentPosition),
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  _formatTime(totalDuration),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),

            const Spacer(),

            /// Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                    size: 36,
                  ),
                  onPressed: _playPrevious,
                ),
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_circle : Icons.play_circle,
                    color: ThemeColor.lightGrey,
                    size: 64,
                  ),
                  onPressed: _playPause,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.skip_next,
                    color: Colors.white,
                    size: 36,
                  ),
                  onPressed: _playNext,
                ),
              ],
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
