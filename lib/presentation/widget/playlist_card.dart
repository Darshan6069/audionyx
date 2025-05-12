import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/core/constants/theme_color.dart';
import 'package:flutter/material.dart';

import '../../playlist_screen.dart';

class PlaylistCard extends StatelessWidget {
  final Map<String, dynamic> playlist;

  const PlaylistCard({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    final name = playlist['name'] ?? 'Unnamed Playlist';
    final thumbnailUrl = playlist['thumbnailUrl'] ?? '';
    final id = playlist['_id'] ?? playlist['id'] ?? '';

    return GestureDetector(
      onTap: () {
        context.push(
          context,
          target: PlaylistSongsScreen(
            playlistId: id,
            playlistName: name,
          ),
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
              child: thumbnailUrl.isNotEmpty
                  ? Image.network(
                thumbnailUrl,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 150,
                  height: 150,
                  color: ThemeColor.grey,
                  child: const Icon(Icons.music_note, color: ThemeColor.white),
                ),
              )
                  : Container(
                width: 150,
                height: 150,
                color: ThemeColor.grey,
                child: const Icon(Icons.queue_music, color: ThemeColor.white),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(color: ThemeColor.white, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}