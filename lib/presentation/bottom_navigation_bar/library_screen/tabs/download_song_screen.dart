import 'dart:io';
import 'package:flutter/material.dart';

import '../../../../domain/song_model/song_model.dart';
import '../../../song_play_screen/song_play_screen.dart';

class DownloadedSongsScreen extends StatefulWidget {
  const DownloadedSongsScreen({super.key});

  @override
  State<DownloadedSongsScreen> createState() => _DownloadedSongsScreenState();
}

class _DownloadedSongsScreenState extends State<DownloadedSongsScreen> {
  List<dynamic> downloadedFiles = [];

  @override
  void initState() {
    super.initState();
    _loadDownloadedSongs();
  }

  Future<void> _loadDownloadedSongs() async {
    final dir = Directory(
      '/storage/emulated/0/Android/data/com.example.audionyx/files/Downloads',
    );
    final files =
        dir.existsSync()
            ? dir
                .listSync()
                .where((file) => file.path.endsWith('.mp3'))
                .toList()
            : [];

    if (mounted) {
      setState(() {
        downloadedFiles = files;
      });
    }
  }

  void _playSong(int index) {
    final songDataList =
        downloadedFiles.map<SongData>((file) {
          final name = file.path.split('/').last;
          return SongData(
            mp3Url: file.path,
            title: name,
            thumbnailUrl: file.path.replaceAll('.mp3', '_thumbnail.jpg'),
            genre: '',
            artist: '',
            album: '',
            id: '',
          );
        }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) =>
                SongPlayerScreen(songList: songDataList, initialIndex: index),
      ),
    );
  }

  void _deleteSong(int index) async {
    final file = downloadedFiles[index];
    try {
      await file.delete();
      if (mounted) {
        setState(() {
          downloadedFiles.removeAt(index);
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Song deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to delete song')));
    }
  }

  Widget _loadThumbnail(int index) {
    final file = downloadedFiles[index];
    final thumbnailPath = file.path.replaceAll('.mp3', '_thumbnail.jpg');

    if (File(thumbnailPath).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(thumbnailPath),
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[300],
        ),
        child: const Icon(Icons.music_note, size: 30, color: Colors.grey),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Downloaded Songs',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDownloadedSongs,
          ),
        ],
      ),
      body:
          downloadedFiles.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.music_off, size: 80, color: Colors.grey),
                    const SizedBox(height: 20),
                    const Text(
                      'No downloaded songs found.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: downloadedFiles.length,
                itemBuilder: (context, index) {
                  final file = downloadedFiles[index];
                  final fileName = file.path.split('/').last;
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          _loadThumbnail(index),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fileName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Tap play to listen or delete to remove',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.play_arrow,
                              color: Colors.green,
                            ),
                            onPressed: () => _playSong(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteSong(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}