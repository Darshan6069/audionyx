import 'package:audionyx/core/constants/extension.dart';
import 'package:flutter/material.dart';

import '../bottom_navigation_bar/home_screen/playlist_management_screen/playlist_screen.dart';

class PlaylistCard extends StatelessWidget {
  final Map<String, dynamic> playlist;

  const PlaylistCard({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = playlist['name'] ?? 'Unnamed Playlist';
    final thumbnailUrl = playlist['thumbnailUrl'] ?? '';
    final id = playlist['_id'] ?? playlist['id'] ?? '';

    return GestureDetector(
      onTap: () {
        context.push(
          context,
          target: PlaylistSongsScreen(playlistId: id, playlistName: name),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  thumbnailUrl.isNotEmpty
                      ? Image.network(
                        thumbnailUrl,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              width: 150,
                              height: 150,
                              // Using theme surface variant instead of hardcoded grey
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.music_note,
                                // Using theme on surface variant color instead of hardcoded white
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                      )
                      : Container(
                        width: 150,
                        height: 150,
                        // Using theme surface variant color
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.queue_music,
                          // Using theme on surface variant color
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                // Using theme on background color instead of hardcoded white
                color: theme.colorScheme.onSurface,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
