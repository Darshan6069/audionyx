// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
//
// import 'domain/song_model/song_model.dart';
//
// class SongPlayerScreen extends StatefulWidget {
//   final List<SongData> songList;
//   final int initialIndex;
//
//   const SongPlayerScreen({
//     super.key,
//     required this.songList,
//     required this.initialIndex,
//   });
//
//   @override
//   State<SongPlayerScreen> createState() => _SongPlayerScreenState();
// }
//
// class _SongPlayerScreenState extends State<SongPlayerScreen> {
//   late AudioPlayer _player;
//   late int currentIndex;
//   Duration position = Duration.zero;
//   Duration duration = Duration.zero;
//   bool isPlaying = false;
//
//   SongData get currentSong => widget.songList[currentIndex];
//
//   @override
//   void initState() {
//     super.initState();
//     _player = AudioPlayer();
//     currentIndex = widget.initialIndex;
//     _initPlayer();
//
//     _player.positionStream.listen((pos) => setState(() => position = pos));
//     _player.playerStateStream.listen((state) => setState(() => isPlaying = state.playing));
//   }
//
//   Future<void> _initPlayer() async {
//     try {
//       if (currentSong.isOnline) {
//         await _player.setUrl(currentSong.path);
//       } else {
//         await _player.setFilePath(currentSong.path);
//       }
//       duration = _player.duration ?? Duration.zero;
//     } catch (e) {
//       print("Error initializing audio: $e");
//     }
//   }
//
//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }
//
//   void _togglePlayPause() {
//     if (isPlaying) {
//       _player.pause();
//     } else {
//       _player.play();
//     }
//   }
//
//   void _playNext() {
//     if (currentIndex + 1 < widget.songList.length) {
//       setState(() {
//         currentIndex++;
//         _initPlayer();
//       });
//     }
//   }
//
//   void _playPrevious() {
//     if (currentIndex > 0) {
//       setState(() {
//         currentIndex--;
//         _initPlayer();
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final thumbnail = currentSong.thumbnailPath;
//
//     return Scaffold(
//       appBar: AppBar(title: Text(currentSong.title)),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             Container(
//               height: 200,
//               width: 200,
//               color: Colors.grey[300],
//               child: currentSong.isOnline
//                   ? Image.network(thumbnail, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.music_note, size: 50))
//                   : File(thumbnail).existsSync()
//                   ? Image.file(File(thumbnail), fit: BoxFit.cover)
//                   : const Icon(Icons.music_note, size: 50),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               currentSong.title,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Slider(
//               value: position.inSeconds.toDouble(),
//               max: duration.inSeconds.toDouble().clamp(1.0, double.infinity),
//               onChanged: (value) => _player.seek(Duration(seconds: value.toInt())),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(_formatDuration(position)),
//                 Text(_formatDuration(duration)),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(icon: const Icon(Icons.skip_previous, size: 40), onPressed: _playPrevious),
//                 IconButton(icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 48), onPressed: _togglePlayPause),
//                 IconButton(icon: const Icon(Icons.skip_next, size: 40), onPressed: _playNext),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _formatDuration(Duration d) => d.toString().split('.').first.padLeft(8, "0");
// }
import 'dart:io';
import 'package:audionyx/repository/service/song_service/audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'domain/song_model/song_model.dart';

class SongPlayerScreen extends StatefulWidget {
  final List<SongData> downloadedFiles;
  final int initialIndex;

  const SongPlayerScreen({
    super.key,
    required this.downloadedFiles,
    required this.initialIndex,
  });

  @override
  State<SongPlayerScreen> createState() => _SongPlayerScreenState();
}

class _SongPlayerScreenState extends State<SongPlayerScreen> {
  late AudioService _audioService;

  @override
  void initState() {
    super.initState();
    _audioService = AudioService(
      downloadedFiles: widget.downloadedFiles,
      initialIndex: widget.initialIndex,
    );
    _audioService.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _audioService.removeListener(() {});
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final song = widget.downloadedFiles[_audioService.currentIndex];
    final isUrl = song.isUrl;
    final fileName = isUrl ? (song.title ?? 'Unknown Title') : song.path.split('/').last;
    final thumbnailPath = isUrl ? song.thumbnailUrl : song.path.replaceAll('.mp3', '_thumbnail.jpg');

    return Scaffold(
      appBar: AppBar(title: Text(fileName)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 200,
                width: 200,
                color: Colors.grey[300],
                child: isUrl
                    ? CachedNetworkImage(
                  imageUrl: thumbnailPath ?? '',
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.music_note, size: 50),
                )
                    : File(thumbnailPath!).existsSync()
                    ? Image.file(
                  File(thumbnailPath),
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                )
                    : const Icon(Icons.music_note, size: 50),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              fileName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Slider(
              value: _audioService.position.inSeconds.toDouble(),
              max: _audioService.duration.inSeconds.toDouble(),
              onChanged: (value) {
                _audioService.seek(Duration(seconds: value.toInt()));
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_audioService.position)),
                Text(_formatDuration(_audioService.duration)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 40),
                  onPressed: _audioService.playPrevious,
                ),
                IconButton(
                  icon: Icon(
                    _audioService.isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 48,
                  ),
                  onPressed: _audioService.togglePlayPause,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 40),
                  onPressed: _audioService.playNext,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    return d.toString().split('.').first.padLeft(8, "0");
  }
}