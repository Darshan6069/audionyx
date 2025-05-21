import 'dart:io';
import 'package:audionyx/core/constants/extension.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../../domain/song_model/song_model.dart';
import '../../../song_play_screen/song_play_screen.dart';

class DownloadedSongsScreen extends StatefulWidget {
  final bool showAppBar;

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
    final dir = Directory('/storage/emulated/0/Android/data/com.example.audionyx/files/Downloads');
    final files =
        dir.existsSync() ? dir.listSync().where((file) => file.path.endsWith('.mp3')).toList() : [];

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
            subtitleUrl: '',
          );
        }).toList();

    context.push(context, target: SongPlayerScreen(songList: songDataList, initialIndex: index));
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

  Widget _loadThumbnail(int index, bool isDesktop, bool isTablet, ThemeData theme) {
    final file = downloadedFiles[index];
    final thumbnailPath = file.path.replaceAll('.mp3', '_thumbnail.jpg');
    final thumbnailSize =
        isDesktop
            ? 64.0
            : isTablet
            ? 60.0
            : 56.0;

    if (File(thumbnailPath).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(thumbnailPath),
          width: thumbnailSize,
          height: thumbnailSize,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        width: thumbnailSize,
        height: thumbnailSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: theme.colorScheme.surface,
        ),
        child: Icon(
          Icons.music_note,
          size:
              isDesktop
                  ? 32.0
                  : isTablet
                  ? 28.0
                  : 24.0,
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    // Responsive padding and sizes
    final horizontalPadding =
        isDesktop
            ? 80.0
            : isTablet
            ? 40.0
            : 20.0;
    final verticalPadding = isDesktop || isTablet ? 30.0 : 20.0;
    final titleFontSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 16.0
            : 14.0;
    final subtitleFontSize =
        isDesktop
            ? 14.0
            : isTablet
            ? 12.0
            : 10.0;
    final cardPadding =
        isDesktop
            ? const EdgeInsets.all(16.0)
            : isTablet
            ? const EdgeInsets.all(12.0)
            : const EdgeInsets.all(10.0);

    return Scaffold(
      appBar:
          widget.showAppBar
              ? AppBar(
                title: Text(
                  'Downloaded Songs',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    fontSize:
                        isDesktop
                            ? 24.0
                            : isTablet
                            ? 20.0
                            : 18.0,
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: colorScheme.primary,
                      size:
                          isDesktop
                              ? 28.0
                              : isTablet
                              ? 24.0
                              : 20.0,
                    ),
                    onPressed: _loadDownloadedSongs,
                  ),
                ],
              )
              : null,
      body:
          downloadedFiles.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.music_off,
                      size:
                          isDesktop
                              ? 100.0
                              : isTablet
                              ? 90.0
                              : 80.0,
                      color: colorScheme.secondary.withOpacity(0.5),
                    ),
                    SizedBox(height: verticalPadding / 2),
                    Text(
                      'No downloaded songs found.',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                        fontSize:
                            isDesktop
                                ? 20.0
                                : isTablet
                                ? 18.0
                                : 16.0,
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                itemCount: downloadedFiles.length,
                itemBuilder: (context, index) {
                  final file = downloadedFiles[index];
                  final fileName = file.path.split('/').last;
                  return Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: horizontalPadding / 2,
                      vertical: verticalPadding / 2,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: colorScheme.surface,
                    child: Padding(
                      padding: cardPadding,
                      child: Row(
                        children: [
                          _loadThumbnail(index, isDesktop, isTablet, theme),
                          SizedBox(
                            width:
                                isDesktop
                                    ? 16.0
                                    : isTablet
                                    ? 12.0
                                    : 10.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fileName,
                                  style: textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                    fontSize: titleFontSize,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height:
                                      isDesktop
                                          ? 8.0
                                          : isTablet
                                          ? 6.0
                                          : 5.0,
                                ),
                                Text(
                                  'Tap play to listen or delete to remove',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface.withOpacity(0.7),
                                    fontSize: subtitleFontSize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.play_arrow,
                              color: colorScheme.primary,
                              size:
                                  isDesktop
                                      ? 28.0
                                      : isTablet
                                      ? 24.0
                                      : 20.0,
                            ),
                            onPressed: () => _playSong(index),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: colorScheme.error,
                              size:
                                  isDesktop
                                      ? 28.0
                                      : isTablet
                                      ? 24.0
                                      : 20.0,
                            ),
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
