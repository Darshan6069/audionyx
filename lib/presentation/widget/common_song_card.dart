import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../domain/song_model/song_model.dart';
import '../../repository/service/song_service/recently_play_song/recently_played_manager.dart';
import '../song_play_screen/song_play_screen.dart';

class CommonSongCard extends StatefulWidget {
  final List<SongData> song;
  final int index;

  const CommonSongCard({required this.song, super.key, required this.index});

  @override
  State<CommonSongCard> createState() => _CommonSongCardState();
}

class _CommonSongCardState extends State<CommonSongCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () async {
        await RecentlyPlayedManager.addSongToRecentlyPlayed(widget.song[widget.index]);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => SongPlayerScreen(songList: widget.song, initialIndex: widget.index),
          ),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: widget.song[widget.index].thumbnailUrl,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      // Using surface variant color for the placeholder
                      color: theme.colorScheme.surfaceContainerHighest,
                      width: 150,
                      height: 150,
                      child: Center(
                        child: CircularProgressIndicator(
                          // Using primary color for the loader
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      width: 150,
                      height: 150,
                      // Using surface variant for error background
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.music_note,
                        // Using on surface variant for the icon
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.song[widget.index].title,
              style: TextStyle(
                // Using primary text color from theme
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              widget.song[widget.index].artist,
              style: TextStyle(
                // Using secondary text color from theme
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
