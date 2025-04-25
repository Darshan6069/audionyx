// import 'package:audionyx/presentation/bottom_navigation_bar/home_screen/home_screen.dart';
// import 'package:audionyx/song_play_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:audionyx/repository/service/song_service/audio_service/audio_service.dart';
//
// class PlaylistScreen extends StatelessWidget {
//   final Map<String, dynamic> playlist;
//
//   const PlaylistScreen({super.key, required this.playlist});
//
//   void _playSong(BuildContext context, Map<String, dynamic> song, int index) async {
//     final songData = {
//       'path': song['mp3Url'],
//       'thumbnailUrl': song['thumbnailUrl'],
//       'title': song['title'],
//       'artist': song['artist'],
//       'album': song['album'],
//       'isUrl': true,
//     };
//
//     await RecentlyPlayedManager.addRecentlyPlayed(songData);
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SongPlayerScreen(
//           songList: playlist['songs'].asMap().entries.map((entry) {
//             return {
//               'path': entry.value['mp3Url'],
//               'thumbnailUrl': entry.value['thumbnailUrl'],
//               'title': entry.value['title'],
//               'artist': entry.value['artist'],
//               'album': entry.value['album'],
//               'isUrl': true,
//             };
//           }).toList(),
//           initialIndex: index,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSongTile(BuildContext context, Map<String, dynamic> song, int index) {
//     return ListTile(
//       leading: ClipRRect(
//         borderRadius: BorderRadius.circular(8),
//         child: CachedNetworkImage(
//           imageUrl: song['thumbnailUrl'] ?? '',
//           width: 50,
//           height: 50,
//           fit: BoxFit.cover,
//           placeholder: (context, url) => const CircularProgressIndicator(),
//           errorWidget: (context, url, error) => const Icon(Icons.music_note),
//         ),
//       ),
//       title: Text(
//         song['title'] ?? 'Unknown Title',
//         style: const TextStyle(color: Colors.white),
//       ),
//       subtitle: Text(
//         song['artist'] ?? 'Unknown Artist',
//         style: const TextStyle(color: Colors.white70),
//       ),
//       trailing: IconButton(
//         icon: const Icon(Icons.play_arrow, color: Colors.white),
//         onPressed: () => _playSong(context, song, index),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: Text(playlist['title'] ?? 'Playlist'),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           // Playlist Thumbnail
//           CachedNetworkImage(
//             imageUrl: playlist['thumbnailUrl'] ?? '',
//             height: 200,
//             width: double.infinity,
//             fit: BoxFit.cover,
//             placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
//             errorWidget: (context, url, error) => Container(
//               height: 200,
//               color: Colors.grey.shade800,
//               child: const Icon(Icons.playlist_play, color: Colors.white, size: 50),
//             ),
//           ),
//           const SizedBox(height: 16),
//           // Song List
//           Expanded(
//             child: ListView.builder(
//               itemCount: playlist['songs']?.length ?? 0,
//               itemBuilder: (context, index) => _buildSongTile(context, playlist['songs'][index], index),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:audionyx/song_browser_screen.dart';
import 'package:audionyx/song_play_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'domain/song_model/song_model.dart';

class PlaylistScreen extends StatelessWidget {
  final Map<String, dynamic> playlist;

  const PlaylistScreen({super.key, required this.playlist});

  void _playSong(BuildContext context, Map<String, dynamic> song, int index) async {
    final songData = SongData.fromMap({
      'path': song['mp3Url'],
      'thumbnailUrl': song['thumbnailUrl'],
      'title': song['title'],
      'artist': song['artist'],
      'album': song['album'],
      'isUrl': true,
    });

    await RecentlyPlayedManager.addRecentlyPlayed(songData);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongPlayerScreen(
          downloadedFiles: (playlist['songs'] as List)
              .asMap()
              .entries
              .map((entry) => SongData.fromMap({
            'path': entry.value['mp3Url'],
            'thumbnailUrl': entry.value['thumbnailUrl'],
            'title': entry.value['title'],
            'artist': entry.value['artist'],
            'album': entry.value['album'],
            'isUrl': true,
          }))
              .toList(),
          initialIndex: index,
        ),
      ),
    );
  }

  Widget _buildSongTile(BuildContext context, Map<String, dynamic> song, int index) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: song['thumbnailUrl'] ?? '',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.music_note),
        ),
      ),
      title: Text(
        song['title'] ?? 'Unknown Title',
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        song['artist'] ?? 'Unknown Artist',
        style: const TextStyle(color: Colors.white70),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.play_arrow, color: Colors.white),
        onPressed: () => _playSong(context, song, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(playlist['title'] ?? 'Playlist'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          CachedNetworkImage(
            imageUrl: playlist['thumbnailUrl'] ?? '',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Container(
              height: 200,
              color: Colors.grey.shade800,
              child: const Icon(Icons.playlist_play, color: Colors.white, size: 50),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: playlist['songs']?.length ?? 0,
              itemBuilder: (context, index) => _buildSongTile(context, playlist['songs'][index], index),
            ),
          ),
        ],
      ),
    );
  }
}