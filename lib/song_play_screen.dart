import 'dart:io';
import 'package:audionyx/repository/service/song_service/song_play_service/play_back_service.dart';
import 'package:flutter/material.dart';
import 'domain/song_model/song_model.dart';

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
  late AudioPlayerService _audioPlayerService;

  @override
  void initState() {
    super.initState();
    _audioPlayerService = AudioPlayerService();
    _audioPlayerService.currentIndex = widget.initialIndex;
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    await _audioPlayerService.initPlayer(widget.songList[widget.initialIndex]);
    _audioPlayerService.positionStream.listen((position) {
      setState(() {
        _audioPlayerService.position = position;
      });
    });

    _audioPlayerService.playerStateStream.listen((state) {
      setState(() {
        _audioPlayerService.isPlaying = state.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayerService.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) =>
      d.toString().split('.').first.padLeft(8, "0");

  @override
  Widget build(BuildContext context) {
    final currentSong = widget.songList[_audioPlayerService.currentIndex];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A2A44), Color(0xFF2E4066)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top App Bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.arrow_back_ios, color: Colors.white),
                    Text(
                      'Now Playing - Personal Room',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Icon(Icons.more_vert, color: Colors.white),
                  ],
                ),
              ),
              // Album Artwork with Overlay
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image:
                                currentSong.isUrl
                                    ? NetworkImage(currentSong.thumbnailUrl)
                                    : FileImage(File(currentSong.thumbnailUrl))
                                        as ImageProvider,
                            fit: BoxFit.cover,
                            onError:
                                (_, __) =>
                                    const Icon(Icons.music_note, size: 50),
                          ),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        color: Colors.teal.withOpacity(0.7),
                        child: Center(
                          child: Text(
                            _formatDuration(
                              _audioPlayerService.position,
                            ).split(':').sublist(1).join(':'),
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Song Info
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Text(
                      currentSong.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      currentSong.artist ?? 'Unknown Artist',
                      // Assuming SongData has an artist field
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              // Progress Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      _formatDuration(_audioPlayerService.position),
                      style: TextStyle(color: Colors.white70),
                    ),
                    Expanded(
                      child: Slider(
                        value:
                            _audioPlayerService.position.inSeconds.toDouble(),
                        max: _audioPlayerService.duration.inSeconds
                            .toDouble()
                            .clamp(1.0, double.infinity),
                        activeColor: Colors.green,
                        inactiveColor: Colors.white24,
                        onChanged:
                            (value) => _audioPlayerService.seekTo(
                              Duration(seconds: value.toInt()),
                            ),
                      ),
                    ),
                    Text(
                      _formatDuration(_audioPlayerService.duration),
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              // Playback Controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.shuffle, color: Colors.white70),
                    IconButton(
                      icon: Icon(Icons.skip_previous, color: Colors.white),
                      onPressed:
                          () =>
                              _audioPlayerService.playPrevious(widget.songList),
                    ),
                    IconButton(
                      icon: Icon(
                        _audioPlayerService.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.green,
                        size: 60,
                      ),
                      onPressed: _audioPlayerService.togglePlayPause,
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_next, color: Colors.white),
                      onPressed:
                          () => _audioPlayerService.playNext(widget.songList),
                    ),
                    Icon(Icons.repeat, color: Colors.white70),
                  ],
                ),
              ),
              // Bottom Buttons
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.queue_music, color: Colors.white70),
                    Icon(Icons.favorite_border, color: Colors.white70),
                    Icon(Icons.share, color: Colors.white70),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
