import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:responsive_framework/responsive_framework.dart';
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
    final theme = Theme.of(context);
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final thumbnailSize =
        isDesktop
            ? 64.0
            : isTablet
            ? 60.0
            : 56.0;
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
    final horizontalPadding =
        isDesktop
            ? 80.0
            : isTablet
            ? 40.0
            : 16.0;
    final verticalPadding = isDesktop || isTablet ? 12.0 : 8.0;

    return InkWell(
      onTap: () => service.playSong(context, song, index, songs),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: song.thumbnailUrl,
                width: thumbnailSize,
                height: thumbnailSize,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      width: thumbnailSize,
                      height: thumbnailSize,
                      color:
                          theme.brightness == Brightness.dark ? Colors.white10 : Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.secondary,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      width: thumbnailSize,
                      height: thumbnailSize,
                      color:
                          theme.brightness == Brightness.dark ? Colors.white10 : Colors.grey[200],
                      child: Icon(
                        Icons.music_note,
                        color: theme.iconTheme.color,
                        size:
                            isDesktop
                                ? 28.0
                                : isTablet
                                ? 24.0
                                : 20.0,
                      ),
                    ),
              ),
            ),
            SizedBox(
              width:
                  isDesktop
                      ? 20.0
                      : isTablet
                      ? 18.0
                      : 16.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.textTheme.bodyLarge?.color,
                      fontSize: titleFontSize,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isDesktop || isTablet ? 6.0 : 4.0),
                  Text(
                    '${song.artist} • ${song.album}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      fontSize: subtitleFontSize,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            _buildPopupMenu(context, isDesktop, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context, bool isDesktop, bool isTablet) {
    final theme = Theme.of(context);
    final iconSize =
        isDesktop
            ? 24.0
            : isTablet
            ? 22.0
            : 20.0;
    final fontSize =
        isDesktop
            ? 14.0
            : isTablet
            ? 12.0
            : 10.0;

    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: theme.iconTheme.color,
        size:
            isDesktop
                ? 28.0
                : isTablet
                ? 24.0
                : 20.0,
      ),
      color: theme.brightness == Brightness.dark ? Colors.white10 : Colors.white,
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
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'play',
              child: Row(
                children: [
                  Icon(Icons.play_arrow, color: theme.iconTheme.color, size: iconSize),
                  const SizedBox(width: 8),
                  Text(
                    'Play',
                    style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: fontSize),
                  ),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'add_to_playlist',
              child: Row(
                children: [
                  Icon(Icons.playlist_add, color: theme.iconTheme.color, size: iconSize),
                  const SizedBox(width: 8),
                  Text(
                    'Add to Playlist',
                    style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: fontSize),
                  ),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'download',
              child: Row(
                children: [
                  Icon(Icons.download, color: theme.iconTheme.color, size: iconSize),
                  const SizedBox(width: 8),
                  Text(
                    'Download',
                    style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: fontSize),
                  ),
                ],
              ),
            ),
          ],
    );
  }
}
