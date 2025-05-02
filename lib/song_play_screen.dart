import 'dart:io';
import 'package:audionyx/repository/service/song_service/audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audionyx/domain/song_model/song_model.dart';

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
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _audioPlayerService = AudioPlayerService();
    _audioPlayerService.currentIndex = widget.initialIndex;
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      await _audioPlayerService.initPlayer(widget.songList[_audioPlayerService.currentIndex]);
      _audioPlayerService.positionStream.listen((pos) {
        setState(() {
          _audioPlayerService.position = pos;
        });
      });
      _audioPlayerService.playerStateStream.listen((state) {
        setState(() {
          _audioPlayerService.isPlaying = state.playing;
        });
      });
    } catch (e) {
      setState(() {
        isError = true;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayerService.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  @override
  Widget build(BuildContext context) {
    if (isError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error'), backgroundColor: Colors.black),
        body: const Center(child: Text('Failed to load audio', style: TextStyle(color: Colors.white))),
      );
    }

    final currentSong = widget.songList[_audioPlayerService.currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.download), onPressed: () => Navigator.pushNamed(context, '/downloadScreen')),
          IconButton(icon: const Icon(Icons.home), onPressed: () => Navigator.pushNamed(context, '/homeScreen')),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A2A44), Color(0xFF2E4066)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Thumbnail
              Expanded(
                child: Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: currentSong.thumbnailUrl.startsWith('http')
                            ? NetworkImage(currentSong.thumbnailUrl)
                            : FileImage(File(currentSong.thumbnailUrl)) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              // Song Info
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Text(currentSong.title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(currentSong.artist, style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              // Slider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(_formatDuration(_audioPlayerService.position), style: const TextStyle(color: Colors.white70)),
                    Expanded(
                      child: Slider(
                        value: _audioPlayerService.position.inSeconds.toDouble(),
                        max: _audioPlayerService.duration.inSeconds.clamp(1, 100000).toDouble(),
                        activeColor: Colors.green,
                        inactiveColor: Colors.white24,
                        onChanged: (value) {
                          _audioPlayerService.seekTo(Duration(seconds: value.toInt()));
                        },
                      ),
                    ),
                    Text(_formatDuration(_audioPlayerService.duration), style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              // Controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(_audioPlayerService.isShuffling ? Icons.shuffle_on : Icons.shuffle, color: Colors.white),
                      onPressed: () {
                        setState(() => _audioPlayerService.toggleShuffle());
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_previous, color: Colors.white),
                      onPressed: () => _audioPlayerService.playPrevious(widget.songList),
                    ),
                    IconButton(
                      icon: Icon(
                        _audioPlayerService.isPlaying ? Icons.pause_circle : Icons.play_circle,
                        color: Colors.green,
                        size: 60,
                      ),
                      onPressed: _audioPlayerService.togglePlayPause,
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white),
                      onPressed: () => _audioPlayerService.playNext(widget.songList),
                    ),
                    IconButton(
                      icon: Icon(
                        _audioPlayerService.loopMode == LoopMode.one ? Icons.repeat_one : Icons.repeat,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() => _audioPlayerService.toggleRepeatMode());
                      },
                    ),
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
