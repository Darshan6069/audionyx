// import 'package:flutter/material.dart';
// import 'package:audionyx/core/constants/theme_color.dart';
// import 'package:audionyx/repository/service/song_service/playlist_service/playlist_service.dart';
//
// class PlaylistSongsScreen extends StatefulWidget {
//   final String playlistId;
//   final String playlistName;
//
//   const PlaylistSongsScreen({
//     super.key,
//     required this.playlistId,
//     required this.playlistName,
//   });
//
//   @override
//   State<PlaylistSongsScreen> createState() => _PlaylistSongsScreenState();
// }
//
// class _PlaylistSongsScreenState extends State<PlaylistSongsScreen> {
//   final PlaylistService _playlistService = PlaylistService();
//   late Future<List<Map<String, dynamic>>> _songsFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _songsFuture = _playlistService.getSongsInPlaylist(widget.playlistId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ThemeColor.darkBackground,
//       appBar: AppBar(
//         title: Text(
//           widget.playlistName,
//           style: const TextStyle(color: ThemeColor.white),
//         ),
//         backgroundColor: ThemeColor.darkBackground,
//         elevation: 0,
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _songsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator(color: ThemeColor.white));
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'Error: ${snapshot.error}',
//                 style: const TextStyle(color: ThemeColor.white),
//               ),
//             );
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(
//               child: Text(
//                 'No songs in this playlist',
//                 style: TextStyle(color: ThemeColor.white),
//               ),
//             );
//           }
//
//           final songs = snapshot.data!;
//           return ListView.builder(
//             itemCount: songs.length,
//             itemBuilder: (context, index) {
//               final song = songs[index];
//               final songTitle = song['title']?.toString() ?? 'Unknown Song';
//               return ListTile(
//                 leading: const Icon(Icons.music_note, color: ThemeColor.white),
//                 title: Text(
//                   songTitle,
//                   style: const TextStyle(color: ThemeColor.white),
//                 ),
//                 // Optionally add actions like play or remove song
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }