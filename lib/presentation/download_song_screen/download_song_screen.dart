import 'dart:io';
import 'package:audionyx/song_play_screen.dart';
import 'package:flutter/material.dart';

import '../../domain/song_model/song_model.dart';

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
    final dir = Directory('/storage/emulated/0/Android/data/com.example.audionyx/files/Downloads');
    final files = dir.existsSync()
        ? dir.listSync().where((file) => file.path.endsWith('.mp3')).toList()
        : [];

    if (mounted) {
      setState(() {
        downloadedFiles = files;
      });
    }
  }

  void _playSong(int index) {
    final songDataList = downloadedFiles.map<SongData>((file) {
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
        builder: (_) => SongPlayerScreen(
          songList: songDataList,
          initialIndex: index,
        ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete song')),
      );
    }
  }

  Widget _loadThumbnail(int index) {
    final file = downloadedFiles[index];
    final thumbnailPath = file.path.replaceAll('.mp3', '_thumbnail.jpg');

    if (File(thumbnailPath).existsSync()) {
      return Image.file(
        File(thumbnailPath),
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.music_note,
          size: 40,
        ),
      );
    } else {
      print('Thumbnail not found at: $thumbnailPath');
      return const Icon(Icons.music_note, size: 40);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Downloaded Songs')),
      body: downloadedFiles.isEmpty
          ? const Center(child: Text('No downloaded songs found.'))
          : ListView.builder(
        itemCount: downloadedFiles.length,
        itemBuilder: (context, index) {
          final file = downloadedFiles[index];
          final fileName = file.path.split('/').last;
          return ListTile(
            leading: _loadThumbnail(index),
            title: Text(fileName),
            trailing: SizedBox(
              width: 100, // Explicit width to constrain the Row
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () => _playSong(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
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