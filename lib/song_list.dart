import 'dart:convert';
import 'dart:io';
import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/download_song_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class SongListScreen extends StatefulWidget {
  const SongListScreen({super.key});

  @override
  State<SongListScreen> createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  List<dynamic> songs = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  @override
  void dispose() {
    print('Disposing AudioPlayer');
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> downloadSong(
    String url,
    String fileName,
    String thumbnailUrl,
    Map<String, dynamic> songMetadata,
  ) async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      if (await Permission.audio.isGranted ||
          await Permission.storage.isGranted) {
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Permission not granted')));
      return;
    }

    try {
      final directory = Directory(
        '/storage/emulated/0/Download',
      ); // Download folder
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      // Download the MP3 file
      await FlutterDownloader.enqueue(
        url: url,
        savedDir: directory.path,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
      );

      // Download the thumbnail (if exists)
      if (songMetadata['thumbnailUrl'] != null) {
        final thumbnailUrl = songMetadata['thumbnailUrl'];
        final thumbnailFileName =
            '${fileName.replaceAll('.mp3', '')}_thumbnail.jpg';
        final thumbnailResponse = await http.get(Uri.parse(thumbnailUrl));

        if (thumbnailResponse.statusCode == 200) {
          final thumbnailFile = File('${directory.path}/$thumbnailFileName');
          await thumbnailFile.writeAsBytes(thumbnailResponse.bodyBytes);
          print('Thumbnail saved as $thumbnailFileName');
        } else {
          print('Failed to download thumbnail');
        }
      }

      // Save song metadata (title, artist, album, etc.)
      final metadataFile = File(
        '${directory.path}/${fileName.replaceAll('.mp3', '.json')}',
      );
      final metadata = {
        'title': songMetadata['title'],
        'artist': songMetadata['artist'],
        'album': songMetadata['album'],
        'thumbnail': '${fileName.replaceAll('.mp3', '')}_thumbnail.jpg',
      };

      await metadataFile.writeAsString(jsonEncode(metadata));
      print('Metadata saved for $fileName');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Download started: $fileName')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Download failed: $e')));
    }
  }

  Future<void> fetchSongs() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http
          .get(Uri.parse('http://192.168.0.3:4000/api/songs'))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timed out'),
          );

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        setState(() {
          songs = jsonDecode(response.body);
          isLoading = false;
        });
        print('Songs loaded: ${songs.length}');
      } else {
        setState(() {
          isLoading = false;
          errorMessage =
              'Failed to load songs: HTTP ${response.statusCode} - ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching songs: $e';
      });
      print('Fetch error: $e');
    }
  }

  Future<void> playSong(String mp3Url) async {
    try {
      print('Attempting to play MP3: $mp3Url');
      await _audioPlayer.setUrl(mp3Url);
      print('AudioPlayer URL set successfully');
      await _audioPlayer.play();
      print('Playback started');
    } catch (e) {
      print('Error playing song: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error playing song: $e')));
    }
  }

  Widget _buildSongCard(Map song) {
    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: song['thumbnailUrl'] ?? '',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Container(
                    color: Colors.grey.shade800,
                    width: 150,
                    height: 150,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    width: 150,
                    height: 150,
                    color: Colors.grey.shade800,
                    child: const Icon(Icons.music_note, color: Colors.white),
                  ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            song['title'] ?? 'Unknown Title',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            song['artist'] ?? 'Unknown Artist',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                onPressed: () => playSong(song['mp3Url']),
              ),
              IconButton(
                icon: const Icon(Icons.download, color: Colors.white),
                onPressed: () {
                  final mp3Url = song['mp3Url'].toString();
                  final title = song['title']?.toString() ?? 'song';
                  final thumbnailUrl = song['thumbnailUrl'].toString();
                  final safeFileName =
                      title.replaceAll(RegExp(r'[^\w\s-]'), '_') + '.mp3';
                  downloadSong(mp3Url, safeFileName, thumbnailUrl, {
                    'title': song['title'],
                    'artist': song['artist'],
                    'album': song['album'],
                    'thumbnailUrl': song['thumbnailUrl'],
                  });
                },
              ),
            ],
          ),
        ],
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
          IconButton(icon: const Icon(Icons.refresh), onPressed: fetchSongs),
          IconButton(
            icon: const Icon(Icons.library_music_rounded),
            onPressed:
                () => context.push(context, target: DownloadedSongsScreen()),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : songs.isEmpty
              ? const Center(
                child: Text(
                  'No songs found',
                  style: TextStyle(color: Colors.white),
                ),
              )
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Recommended for You',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: songs.length,
                        itemBuilder:
                            (context, index) => GestureDetector(
                              onTap: () {},
                              child: _buildSongCard(songs[index]),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
