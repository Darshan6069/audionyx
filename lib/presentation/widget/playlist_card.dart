import 'package:audionyx/core/constants/extension.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../bottom_navigation_bar/home_screen/playlist_management_screen/playlist_screen.dart';

class PlaylistCard extends StatelessWidget {
  final Map<String, dynamic> playlist;

  const PlaylistCard({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final cardWidth =
        isDesktop
            ? 200.0
            : isTablet
            ? 180.0
            : 150.0;
    final thumbnailSize =
        isDesktop
            ? 200.0
            : isTablet
            ? 180.0
            : 150.0;
    final fontSize =
        isDesktop
            ? 16.0
            : isTablet
            ? 15.0
            : 14.0;
    final marginRight =
        isDesktop
            ? 16.0
            : isTablet
            ? 12.0
            : 10.0;
    final spacing =
        isDesktop
            ? 12.0
            : isTablet
            ? 10.0
            : 8.0;

    final name = playlist['name'] ?? 'Unnamed Playlist';
    final thumbnailUrl = playlist['thumbnailUrl'] ?? '';
    final id = playlist['_id'] ?? playlist['id'] ?? '';

    return GestureDetector(
      onTap: () {
        context.push(context, target: PlaylistSongsScreen(playlistId: id, playlistName: name));
      },
      child: Container(
        width: cardWidth,
        margin: EdgeInsets.only(right: marginRight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  thumbnailUrl.isNotEmpty
                      ? Image.network(
                        thumbnailUrl,
                        width: thumbnailSize,
                        height: thumbnailSize,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              width: thumbnailSize,
                              height: thumbnailSize,
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.music_note,
                                color: theme.colorScheme.onSurfaceVariant,
                                size: thumbnailSize * 0.4,
                              ),
                            ),
                      )
                      : Container(
                        width: thumbnailSize,
                        height: thumbnailSize,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.queue_music,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: thumbnailSize * 0.4,
                        ),
                      ),
            ),
            SizedBox(height: spacing),
            Text(
              name,
              style: TextStyle(color: theme.colorScheme.onSurface, fontSize: fontSize),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
