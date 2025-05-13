import 'dart:io';
import 'package:audionyx/core/constants/extension.dart';
import 'package:flutter/material.dart';

import '../../../../domain/song_model/song_model.dart';
import '../../../song_play_screen/song_play_screen.dart';

class DownloadedSongsScreen extends StatefulWidget {
  final bool showAppBar; // New parameter to control AppBar visibility

  const DownloadedSongsScreen({super.key, this.showAppBar = true});

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

    context.push(
      context,
      target: SongPlayerScreen(songList: songDataList, initialIndex: index),
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
        SnackBar(
          content: const Text('Song deleted successfully'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to delete song'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Widget _loadThumbnail(int index) {
    final file = downloadedFiles[index];
    final thumbnailPath = file.path.replaceAll('.mp3', '_thumbnail.jpg');
    final theme = Theme.of(context);

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
          color: theme.colorScheme.surface,
        ),
        child: Icon(
            Icons.music_note,
            size: 30,
            color: theme.colorScheme.onSurface.withOpacity(0.5)
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
        title: Text(
          'Downloaded Songs',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: colorScheme.primary),
            onPressed: _loadDownloadedSongs,
          ),
        ],
      )
          : null,
      body: downloadedFiles.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                Icons.music_off,
                size: 80,
                color: colorScheme.secondary.withOpacity(0.5)
            ),
            const SizedBox(height: 20),
            Text(
              'No downloaded songs found.',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
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
            color: colorScheme.surface,
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
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Tap play to listen or delete to remove',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.play_arrow,
                      color: colorScheme.primary,
                    ),
                    onPressed: () => _playSong(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: colorScheme.error),
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