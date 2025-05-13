import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:audionyx/repository/service/song_service/song_browser_service/song_browser_service.dart';

class SongTile extends StatelessWidget {
  final SongData song;
  final int index;
  final List<SongData> songs;
  final SongBrowserService service;

  const SongTile({
    super.key,
    required this.song,
    required this.index,
    required this.songs,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: () => service.playSong(context, song, index, songs),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: song.thumbnailUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 60,
                  height: 60,
                  color: theme.brightness == Brightness.dark
                      ? Colors.white10
                      : Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.secondary,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 60,
                  height: 60,
                  color: theme.brightness == Brightness.dark
                      ? Colors.white10
                      : Colors.grey[200],
                  child: Icon(
                    Icons.music_note,
                    color: theme.iconTheme.color,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${song.artist} • ${song.album}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            _buildPopupMenu(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
      color: theme.brightness == Brightness.dark
          ? Colors.white10
          : Colors.white,
      onSelected: (value) {
        switch (value) {
          case 'play':
            service.playSong(context, song, index, songs);
            break;
          case 'add_to_playlist':
          // TODO: Implement add to playlist
            break;
          case 'download':
          // TODO: Implement download
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'play',
          child: Row(
            children: [
              Icon(
                  Icons.play_arrow,
                  color: theme.iconTheme.color,
                  size: 20
              ),
              const SizedBox(width: 8),
              Text(
                  'Play',
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color)
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'add_to_playlist',
          child: Row(
            children: [
              Icon(
                  Icons.playlist_add,
                  color: theme.iconTheme.color,
                  size: 20
              ),
              const SizedBox(width: 8),
              Text(
                  'Add to Playlist',
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color)
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'download',
          child: Row(
            children: [
              Icon(
                  Icons.download,
                  color: theme.iconTheme.color,
                  size: 20
              ),
              const SizedBox(width: 8),
              Text(
                  'Download',
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color)
              ),
            ],
          ),
        ),
      ],
    );
  }
}