// import 'package:audionyx/repository/service/song_service/playlist_service/playlist_service.dart';
// import 'package:audionyx/song_play_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:audionyx/domain/song_model/song_model.dart';
//
// import 'domain/song_model/playlist_model.dart';
//
//
// class PlaylistsScreen extends StatefulWidget {
//   const PlaylistsScreen({super.key});
//
//   @override
//   State<PlaylistsScreen> createState() => _PlaylistsScreenState();
// }
//
// class _PlaylistsScreenState extends State<PlaylistsScreen> {
//   List<PlaylistModel> playlists = [];
//   List<SongData> songs = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }
//
//   Future<void> _loadData() async {
//     final fetchedPlaylists = await PlaylistService().fetchUserPlaylists();
//     final fetchedSongs = await PlaylistService().fetchUserPlaylists();
//     setState(() {
//       playlists = fetchedPlaylists;
//       songs = fetchedSongs;
//     });
//   }
//
//   void _playPlaylist(List<PlaylistModel> playlistSongs, int initialIndex) {
//     final songDataList = playlistSongs
//         .map((song) => SongData(
//       id: song.songs[initialIndex].id,
//       title: song.songs[initialIndex].title,
//       artist: song.songs[initialIndex].artist,
//       path: song.songs[initialIndex].path,
//       album: song.songs[initialIndex].album,
//       genre: song.songs[initialIndex].genre,
//       thumbnailUrl: song.songs[initialIndex].thumbnailUrl,
//     ))
//         .toList();
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => SongPlayerScreen(
//           songList: songDataList,
//           initialIndex: initialIndex,
//         ),
//       ),
//     );
//   }
//
//   void _showCreatePlaylistDialog() {
//     final nameController = TextEditingController();
//     final descriptionController = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Create Playlist'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: 'Name'),
//             ),
//             TextField(
//               controller: descriptionController,
//               decoration: const InputDecoration(labelText: 'Description'),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () async {
//               final success = await PlaylistService.createPlaylist(
//                 nameController.text,
//                 descriptionController.text,
//               );
//               if (success) {
//                 await _loadData();
//                 Navigator.pop(context);
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Failed to create playlist')),
//                 );
//               }
//             },
//             child: const Text('Create'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showAddSongDialog(String playlistId) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add Song'),
//         content: songs.isEmpty
//             ? const Text('No songs available')
//             : SizedBox(
//           width: double.maxFinite,
//           child: ListView.builder(
//             shrinkWrap: true,
//             itemCount: songs.length,
//             itemBuilder: (context, index) {
//               final song = songs[index];
//               return ListTile(
//                 title: Text(song.title),
//                 subtitle: Text(song.artist),
//                 onTap: () async {
//                   final success = await PlaylistService.addSongToPlaylist(
//                     playlistId,
//                     song.id,
//                   );
//                   if (success) {
//                     await _loadData();
//                     Navigator.pop(context);
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Failed to add song')),
//                     );
//                   }
//                 },
//               );
//             },
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Playlists'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: _showCreatePlaylistDialog,
//           ),
//         ],
//       ),
//       body: playlists.isEmpty
//           ? const Center(child: Text('No playlists found.'))
//           : ListView.builder(
//         itemCount: playlists.length,
//         itemBuilder: (context, index) {
//           final playlist = playlists[index];
//           return ExpansionTile(
//             title: Text(playlist.name),
//             subtitle: Text(playlist.songs[index].artist),
//             children: playlist.songs.isEmpty
//                 ? [
//               const ListTile(
//                   title: Text('No songs in this playlist'))
//             ]
//                 : playlist.songs.asMap().entries.map((entry) {
//               final songIndex = entry.key;
//               final song = entry.value;
//               return ListTile(
//                 leading: const Icon(Icons.music_note),
//                 title: Text(song.title),
//                 subtitle: Text(song.artist),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.play_arrow),
//                       onPressed: () =>
//                           _playPlaylist(playlist.songs.cast<PlaylistModel>(), songIndex),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete),
//                       onPressed: () async {
//                         final success =
//                         await PlaylistService.removeSongFromPlaylist(
//                           playlist as String,
//                           "song",
//                         );
//                         if (success) {
//                           await _loadData();
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text('Failed to remove song')),
//                           );
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             }).toList()
//               ..add(
//                 ListTile(
//                   title: const Text('Add Song'),
//                   leading: const Icon(Icons.add),
//                   onTap: () => _showAddSongDialog(playlist.songs[index].id),
//                 ),
//               ),
//           );
//         },
//       ),
//     );
//   }
// }