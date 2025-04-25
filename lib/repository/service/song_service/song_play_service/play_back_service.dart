// import 'package:flutter/foundation.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_background/just_audio_background.dart';
//
// class AudioService extends ChangeNotifier {
//   final List<dynamic> downloadedFiles;
//   late AudioPlayer _player;
//   late Duration _position;
//   late Duration _duration;
//   late bool _isPlaying;
//   late int _currentIndex;
//   static bool _isBackgroundInitialized = false;
//
//   AudioService({
//     required this.downloadedFiles,
//     required int initialIndex,
//   }) {
//     _player = AudioPlayer();
//     _position = Duration.zero;
//     _duration = Duration.zero;
//     _isPlaying = false;
//     _currentIndex = initialIndex;
//     _init();
//   }
//
//   Duration get position => _position;
//   Duration get duration => _duration;
//   bool get isPlaying => _isPlaying;
//   int get currentIndex => _currentIndex;
//
//   Future<void> _init() async {
//     try {
//       if (!_isBackgroundInitialized) {
//         await JustAudioBackground.init(
//           androidNotificationChannelId: 'com.yourcompany.yourapp.channel',
//           androidNotificationChannelName: 'Audio playback',
//           androidNotificationOngoing: true,
//           androidShowNotificationBadge: true,
//         );
//         _isBackgroundInitialized = true;
//       }
//
//       final song = downloadedFiles[_currentIndex];
//       final isUrl = song['isUrl'] == true;
//       final path = song['path'];
//       final fileName = isUrl ? (song['title'] ?? 'Unknown Title') : path.split('/').last;
//
//       final mediaItem = MediaItem(
//         id: path,
//         title: song['title'] ?? fileName,
//         artist: song['artist'] ?? 'Unknown Artist',
//         album: song['album'] ?? 'Unknown Album',
//         artUri: isUrl
//             ? Uri.parse(song['thumbnailUrl'] ?? '')
//             : Uri.file(path.replaceAll('.mp3', '_thumbnail.jpg')),
//       );
//
//       await _player.setAudioSource(
//         AudioSource.uri(
//           isUrl ? Uri.parse(path) : Uri.file(path),
//           tag: mediaItem,
//         ),
//       );
//       _duration = _player.duration ?? Duration.zero;
//
//       _player.positionStream.listen((pos) {
//         _position = pos;
//         notifyListeners();
//       });
//
//       _player.playerStateStream.listen((state) {
//         _isPlaying = state.playing;
//         notifyListeners();
//       });
//     } catch (e) {
//       debugPrint('Error loading audio: $e');
//     }
//   }
//
//   void playNext() {
//     if (_currentIndex + 1 < downloadedFiles.length) {
//       _currentIndex++;
//       _init();
//       notifyListeners();
//     }
//   }
//
//   void playPrevious() {
//     if (_currentIndex - 1 >= 0) {
//       _currentIndex--;
//       _init();
//       notifyListeners();
//     }
//   }
//
//   void togglePlayPause() {
//     if (_isPlaying) {
//       _player.pause();
//     } else {
//       _player.play();
//     }
//     notifyListeners();
//   }
//
//   void seek(Duration position) {
//     _player.seek(position);
//     notifyListeners();
//   }
//
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }
// }