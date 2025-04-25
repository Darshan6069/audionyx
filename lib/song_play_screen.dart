// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//
// class SongPlayerScreen extends StatefulWidget {
//   final List<dynamic> downloadedFiles; // The list of all downloaded songs
//   final int initialIndex; // The initial index of the song to play
//
//   const SongPlayerScreen({
//     super.key,
//     required this.downloadedFiles,
//     required this.initialIndex,
//   });
//
//   @override
//   State<SongPlayerScreen> createState() => _SongPlayerScreenState();
// }
//
// class _SongPlayerScreenState extends State<SongPlayerScreen> {
//   late AudioPlayer _player;
//   late Duration _position;
//   late Duration _duration;
//   late bool isPlaying;
//   late int currentIndex; // To keep track of the current song index
//
//   @override
//   void initState() {
//     super.initState();
//     _player = AudioPlayer();
//     _position = Duration.zero;
//     _duration = Duration.zero;
//     isPlaying = false;
//     currentIndex =
//         widget.initialIndex; // Set the initial index to the passed value
//     _init();
//   }
//
//   Future<void> _init() async {
//     try {
//       // Set the current song file path using the index
//       await _player.setFilePath(widget.downloadedFiles[currentIndex].path);
//       _duration = _player.duration ?? Duration.zero;
//
//       _player.positionStream.listen((pos) {
//         setState(() => _position = pos);
//       });
//
//       _player.playerStateStream.listen((state) {
//         setState(() => isPlaying = state.playing);
//       });
//     } catch (e) {
//       debugPrint('Error loading audio: $e');
//     }
//   }
//
//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }
//
//   // Play the next song
//   void _playNext() {
//     if (currentIndex + 1 < widget.downloadedFiles.length) {
//       setState(() {
//         currentIndex++;
//         _init(); // Load the next song
//       });
//     }
//   }
//
//   // Play the previous song
//   void _playPrevious() {
//     if (currentIndex - 1 >= 0) {
//       setState(() {
//         currentIndex--;
//         _init(); // Load the previous song
//       });
//     }
//   }
//
//   // Play/Pause logic
//   void _togglePlayPause() {
//     if (isPlaying) {
//       _player.pause();
//     } else {
//       _player.play();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final fileName = widget.downloadedFiles[currentIndex].path.split('/').last;
//     // Local thumbnail path, replace with your actual path
//     final thumbnailPath = widget.downloadedFiles[currentIndex].path.replaceAll('.mp3', '_thumbnail.jpg');
//
//     return Scaffold(
//       appBar: AppBar(title: Text(fileName)),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             // Album Art (Using FileImage for local files)
//             GestureDetector(
//               onTap: () {},
//               child: Container(
//                 height: 200,
//                 width: 200,
//                 color: Colors.grey[300],
//                 child:
//                     File(thumbnailPath).existsSync()
//                         ? Image.file(
//                           File(thumbnailPath),
//                           fit: BoxFit.cover,
//                           width: 50, // Added for consistency
//                           height: 50,
//                         )
//                         : const Icon(
//                           Icons.music_note,
//                           size: 50,
//                         ), // Changed to music note for better UX // Show error icon if thumbnail doesn't exist
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               fileName,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//
//             // Seekbar
//             Slider(
//               value: _position.inSeconds.toDouble(),
//               max: _duration.inSeconds.toDouble(),
//               onChanged: (value) {
//                 _player.seek(Duration(seconds: value.toInt()));
//               },
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(_formatDuration(_position)),
//                 Text(_formatDuration(_duration)),
//               ],
//             ),
//
//             // Audio Controls (Play/Pause, Skip, Seek)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Previous button
//                 IconButton(
//                   icon: const Icon(Icons.skip_previous, size: 40),
//                   onPressed: _playPrevious,
//                 ),
//
//                 // Play/Pause button
//                 IconButton(
//                   icon: Icon(
//                     isPlaying ? Icons.pause : Icons.play_arrow,
//                     size: 48,
//                   ),
//                   onPressed: _togglePlayPause,
//                 ),
//
//                 // Next button
//                 IconButton(
//                   icon: const Icon(Icons.skip_next, size: 40),
//                   onPressed: _playNext,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _formatDuration(Duration d) {
//     return d.toString().split('.').first.padLeft(8, "0");
//   }
// }
import 'dart:io';
import 'package:audionyx/repository/service/song_service/audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SongPlayerScreen extends StatefulWidget {
  final List<dynamic> downloadedFiles;
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
      setState(() {});
    });
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileName =
        widget.downloadedFiles[_audioService.currentIndex].path.split('/').last;
    final thumbnailPath = widget.downloadedFiles[_audioService.currentIndex]
        .path
        .replaceAll('.mp3', '_thumbnail.jpg');

    return Scaffold(
      appBar: AppBar(title: Text(fileName)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Album Art
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 200,
                width: 200,
                color: Colors.grey[300],
                child: File(thumbnailPath).existsSync()
                    ? Image.file(
                  File(thumbnailPath),
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                )
                    : const Icon(
                  Icons.music_note,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              fileName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Seekbar
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

            // Audio Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Previous button
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 40),
                  onPressed: _audioService.playPrevious,
                ),

                // Play/Pause button
                IconButton(
                  icon: Icon(
                    _audioService.isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 48,
                  ),
                  onPressed: _audioService.togglePlayPause,
                ),

                // Next button
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