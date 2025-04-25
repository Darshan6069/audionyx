// import 'dart:convert';
// import 'dart:io';
// import 'package:audionyx/core/constants/extension.dart';
// import 'package:audionyx/download_song_screen.dart';
// import 'package:audionyx/song_browser_screen.dart';
// import 'package:audionyx/song_play_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:path_provider/path_provider.dart';
//
// import '../../../playlist_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   List<dynamic> featuredPlaylists = [];
//   List<dynamic> recentlyPlayed = [];
//   List<dynamic> trendingTracks = [];
//   bool isLoading = false;
//   String? errorMessage;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//     loadRecentlyPlayed();
//   }
//
//   Future<void> fetchData() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });
//
//     try {
//       final playlistResponse = await http
//           .get(Uri.parse('http://192.168.0.3:4000/api/playlists'))
//           .timeout(const Duration(seconds: 10));
//
//       final trendingResponse = await http
//           .get(Uri.parse('http://192.168.0.3:4000/api/trending'))
//           .timeout(const Duration(seconds: 10));
//
//       if (playlistResponse.statusCode == 200 && trendingResponse.statusCode == 200) {
//         if (mounted) {
//           setState(() {
//             featuredPlaylists = jsonDecode(playlistResponse.body);
//             trendingTracks = jsonDecode(trendingResponse.body);
//             isLoading = false;
//           });
//         }
//       } else {
//         if (mounted) {
//           setState(() {
//             isLoading = false;
//             errorMessage = 'Failed to load data';
//           });
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//           errorMessage = 'Error fetching data: $e';
//         });
//       }
//     }
//   }
//
//   Future<void> loadRecentlyPlayed() async {
//     final recentlyPlayedSongs = await RecentlyPlayedManager.loadRecentlyPlayed();
//     if (mounted) {
//       setState(() {
//         recentlyPlayed = recentlyPlayedSongs;
//       });
//     }
//   }
//
//   Future<void> downloadSong(
//       String url,
//       String fileName,
//       String thumbnailUrl,
//       Map<String, dynamic> songMetadata,
//       ) async {
//     PermissionStatus status;
//
//     if (Platform.isAndroid) {
//       if (await Permission.audio.isGranted || await Permission.storage.isGranted) {
//         status = PermissionStatus.granted;
//       } else {
//         if (await Permission.audio.request().isGranted ||
//             await Permission.storage.request().isGranted) {
//           status = PermissionStatus.granted;
//         } else {
//           status = PermissionStatus.denied;
//         }
//       }
//     } else {
//       status = await Permission.storage.request();
//     }
//
//     if (!status.isGranted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Permission not granted')));
//       return;
//     }
//
//     try {
//       final directory = Directory('/storage/emulated/0/Download');
//       if (!directory.existsSync()) {
//         directory.createSync(recursive: true);
//       }
//
//       await FlutterDownloader.enqueue(
//         url: url,
//         savedDir: directory.path,
//         fileName: fileName,
//         showNotification: true,
//         openFileFromNotification: true,
//       );
//
//       if (songMetadata['thumbnailUrl'] != null) {
//         final thumbnailResponse = await http.get(Uri.parse(thumbnailUrl));
//         if (thumbnailResponse.statusCode == 200) {
//           final thumbnailFileName = '${fileName.replaceAll('.mp3', '')}_thumbnail.jpg';
//           final thumbnailFile = File('${directory.path}/$thumbnailFileName');
//           await thumbnailFile.writeAsBytes(thumbnailResponse.bodyBytes);
//         }
//       }
//
//       final metadataFile = File('${directory.path}/${fileName.replaceAll('.mp3', '.json')}');
//       final metadata = {
//         'title': songMetadata['title'],
//         'artist': songMetadata['artist'],
//         'album': songMetadata['album'],
//         'thumbnail': '${fileName.replaceAll('.mp3', '')}_thumbnail.jpg',
//       };
//
//       await metadataFile.writeAsString(jsonEncode(metadata));
//
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Download started: $fileName')));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Download failed: $e')));
//     }
//   }
//
//   void _playSong(Map<String, dynamic> song) async {
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
//             songList: songData,
//           initialIndex: 0,
//         ),
//       ),
//     );
//   }
//
//   void _openPlaylist(Map<String, dynamic> playlist) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PlaylistScreen(playlist: playlist),
//       ),
//     );
//   }
//
//   Widget _buildSongCard(Map<String, dynamic> song) {
//     return Container(
//       width: 150,
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: CachedNetworkImage(
//               imageUrl: song['thumbnailUrl'] ?? '',
//               width: 150,
//               height: 150,
//               fit: BoxFit.cover,
//               placeholder: (context, url) => Container(
//                 color: Colors.grey.shade800,
//                 width: 150,
//                 height: 150,
//                 child: const Center(child: CircularProgressIndicator()),
//               ),
//               errorWidget: (context, url, error) => Container(
//                 width: 150,
//                 height: 150,
//                 color: Colors.grey.shade800,
//                 child: const Icon(Icons.music_note, color: Colors.white),
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             song['title'] ?? 'Unknown Title',
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           Text(
//             song['artist'] ?? 'Unknown Artist',
//             style: const TextStyle(color: Colors.white70, fontSize: 12),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           Row(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.play_arrow, color: Colors.white),
//                 onPressed: () => _playSong(song),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.download, color: Colors.white),
//                 onPressed: () {
//                   final mp3Url = song['mp3Url'].toString();
//                   final title = song['title']?.toString() ?? 'song';
//                   final thumbnailUrl = song['thumbnailUrl'].toString();
//                   final safeFileName = title.replaceAll(RegExp(r'[^\w\s-]'), '_') + '.mp3';
//                   downloadSong(mp3Url, safeFileName, thumbnailUrl, {
//                     'title': song['title'],
//                     'artist': song['artist'],
//                     'album': song['album'],
//                     'thumbnailUrl': song['thumbnailUrl'],
//                   });
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPlaylistCard(Map<String, dynamic> playlist) {
//     return GestureDetector(
//       onTap: () => _openPlaylist(playlist),
//       child: Container(
//         width: 150,
//         margin: const EdgeInsets.symmetric(horizontal: 8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: CachedNetworkImage(
//                 imageUrl: playlist['thumbnailUrl'] ?? '',
//                 width: 150,
//                 height: 150,
//                 fit: BoxFit.cover,
//                 placeholder: (context, url) => Container(
//                   color: Colors.grey.shade800,
//                   width: 150,
//                   height: 150,
//                   child: const Center(child: CircularProgressIndicator()),
//                 ),
//                 errorWidget: (context, url, error) => Container(
//                   width: 150,
//                   height: 150,
//                   color: Colors.grey.shade800,
//                   child: const Icon(Icons.playlist_play, color: Colors.white),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               playlist['title'] ?? 'Unknown Playlist',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text('Audionyx', style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         actions: [
//           IconButton(icon: const Icon(Icons.refresh), onPressed: fetchData),
//           IconButton(
//             icon: const Icon(Icons.library_music_rounded),
//             onPressed: () => context.push(context, target: const DownloadedSongsScreen()),
//           ),
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () => context.push(context, target: const SongBrowserScreen()),
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator(color: Colors.white))
//           : errorMessage != null
//           ? Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.white)))
//           : SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Text(
//                 'Featured Playlists',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 200,
//               child: featuredPlaylists.isEmpty
//                   ? const Center(child: Text('No playlists found', style: TextStyle(color: Colors.white)))
//                   : ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: featuredPlaylists.length,
//                 itemBuilder: (context, index) => _buildPlaylistCard(featuredPlaylists[index]),
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Text(
//                 'Recently Played',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 250,
//               child: recentlyPlayed.isEmpty
//                   ? const Center(child: Text('No recently played songs', style: TextStyle(color: Colors.white)))
//                   : ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: recentlyPlayed.length,
//                 itemBuilder: (context, index) => _buildSongCard(recentlyPlayed[index]),
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Text(
//                 'Trending Tracks',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 250,
//               child: trendingTracks.isEmpty
//                   ? const Center(child: Text('No trending tracks found', style: TextStyle(color: Colors.white)))
//                   : ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: trendingTracks.length,
//                 itemBuilder: (context, index) => _buildSongCard(trendingTracks[index]),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/download_song_screen.dart';
import 'package:audionyx/song_browser_screen.dart';
import 'package:audionyx/song_play_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

import '../../../domain/song_model/song_model.dart';
import '../../../playlist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> featuredPlaylists = [];
  List<SongData> recentlyPlayed = [];
  List<SongData> trendingTracks = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchData();
    loadRecentlyPlayed();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final playlistResponse = await http
          .get(Uri.parse('http://192.168.0.3:4000/api/playlists'))
          .timeout(const Duration(seconds: 10));

      final trendingResponse = await http
          .get(Uri.parse('http://192.168.0.3:4000/api/trending'))
          .timeout(const Duration(seconds: 10));

      if (playlistResponse.statusCode == 200 && trendingResponse.statusCode == 200) {
        if (mounted) {
          setState(() {
            featuredPlaylists = jsonDecode(playlistResponse.body);
            trendingTracks = (jsonDecode(trendingResponse.body) as List)
                .map((song) => SongData.fromMap(song))
                .toList();
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
            errorMessage = 'Failed to load data';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Error fetching data: $e';
        });
      }
    }
  }

  Future<void> loadRecentlyPlayed() async {
    final recentlyPlayedSongs = await RecentlyPlayedManager.loadRecentlyPlayed();
    if (mounted) {
      setState(() {
        recentlyPlayed = recentlyPlayedSongs;
      });
    }
  }

  Future<void> downloadSong(
      String url,
      String fileName,
      String thumbnailUrl,
      Map<String, dynamic> songMetadata,
      ) async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      if (await Permission.audio.isGranted || await Permission.storage.isGranted) {
        status = PermissionStatus.granted;
      } else {
        if (await Permission.audio.request().isGranted ||
            await Permission.storage.request().isGranted) {
          status = PermissionStatus.granted;
        } else {
          status = PermissionStatus.denied;
        }
      }
    } else {
      status = await Permission.storage.request();
    }

    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission not granted')));
      return;
    }

    try {
      final directory = Directory('/storage/emulated/0/Download');
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      await FlutterDownloader.enqueue(
        url: url,
        savedDir: directory.path,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
      );

      if (songMetadata['thumbnailUrl'] != null) {
        final thumbnailResponse = await http.get(Uri.parse(thumbnailUrl));
        if (thumbnailResponse.statusCode == 200) {
          final thumbnailFileName = '${fileName.replaceAll('.mp3', '')}_thumbnail.jpg';
          final thumbnailFile = File('${directory.path}/$thumbnailFileName');
          await thumbnailFile.writeAsBytes(thumbnailResponse.bodyBytes);
        }
      }

      final metadataFile = File('${directory.path}/${fileName.replaceAll('.mp3', '.json')}');
      final metadata = {
        'title': songMetadata['title'],
        'artist': songMetadata['artist'],
        'album': songMetadata['album'],
        'thumbnail': '${fileName.replaceAll('.mp3', '')}_thumbnail.jpg',
      };

      await metadataFile.writeAsString(jsonEncode(metadata));

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download started: $fileName')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')));
    }
  }

  void _playSong(SongData song) async {
    await RecentlyPlayedManager.addRecentlyPlayed(song);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongPlayerScreen(
          downloadedFiles: [song],
          initialIndex: 0,
        ),
      ),
    );
  }

  void _openPlaylist(Map<String, dynamic> playlist) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaylistScreen(playlist: playlist),
      ),
    );
  }

  Widget _buildSongCard(SongData song) {
    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: song.thumbnailUrl ?? '',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade800,
                width: 150,
                height: 150,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                width: 150,
                height: 150,
                color: Colors.grey.shade800,
                child: const Icon(Icons.music_note, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            song.title ?? 'Unknown Title',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            song.artist ?? 'Unknown Artist',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                onPressed: () => _playSong(song),
              ),
              IconButton(
                icon: const Icon(Icons.download, color: Colors.white),
                onPressed: () {
                  final mp3Url = song.path;
                  final title = song.title ?? 'song';
                  final thumbnailUrl = song.thumbnailUrl ?? '';
                  final safeFileName = title.replaceAll(RegExp(r'[^\w\s-]'), '_') + '.mp3';
                  downloadSong(mp3Url, safeFileName, thumbnailUrl, {
                    'title': song.title,
                    'artist': song.artist,
                    'album': song.album,
                    'thumbnailUrl': song.thumbnailUrl,
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistCard(Map<String, dynamic> playlist) {
    return GestureDetector(
      onTap: () => _openPlaylist(playlist),
      child: Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: playlist['thumbnailUrl'] ?? '',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade800,
                  width: 150,
                  height: 150,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 150,
                  height: 150,
                  color: Colors.grey.shade800,
                  child: const Icon(Icons.playlist_play, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              playlist['title'] ?? 'Unknown Playlist',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Audionyx', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: fetchData),
          IconButton(
            icon: const Icon(Icons.library_music_rounded),
            onPressed: () => context.push(context, target: const DownloadedSongsScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push(context, target: const SongBrowserScreen()),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : errorMessage != null
          ? Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.white)))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Featured Playlists',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: featuredPlaylists.isEmpty
                  ? const Center(child: Text('No playlists found', style: TextStyle(color: Colors.white)))
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: featuredPlaylists.length,
                itemBuilder: (context, index) => _buildPlaylistCard(featuredPlaylists[index]),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Recently Played',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 250,
              child: recentlyPlayed.isEmpty
                  ? const Center(child: Text('No recently played songs', style: TextStyle(color: Colors.white)))
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recentlyPlayed.length,
                itemBuilder: (context, index) => _buildSongCard(recentlyPlayed[index]),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Trending Tracks',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 250,
              child: trendingTracks.isEmpty
                  ? const Center(child: Text('No trending tracks found', style: TextStyle(color: Colors.white)))
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: trendingTracks.length,
                itemBuilder: (context, index) => _buildSongCard(trendingTracks[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}