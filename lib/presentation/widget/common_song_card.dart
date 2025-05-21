import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
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

    // Responsive: Use ResponsiveBreakpoints if available, else fallback to MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = 150;
    double imageSize = 150;
    double titleFontSize = 14;
    double artistFontSize = 12;

    // Adjust for breakpoints
    if (ResponsiveBreakpoints.of(context).isTablet) {
      cardWidth = 180;
      imageSize = 180;
      titleFontSize = 16;
      artistFontSize = 14;
    }
    if (ResponsiveBreakpoints.of(context).isDesktop) {
      cardWidth = 220;
      imageSize = 220;
      titleFontSize = 18;
      artistFontSize = 16;
    }
    // Optionally, fallback for very small screens
    if (screenWidth < 350) {
      cardWidth = 120;
      imageSize = 120;
      titleFontSize = 13;
      artistFontSize = 11;
    }

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
        width: cardWidth,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: widget.song[widget.index].thumbnailUrl,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      width: imageSize,
                      height: imageSize,
                      child: Center(
                        child: CircularProgressIndicator(color: theme.colorScheme.primary),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      width: imageSize,
                      height: imageSize,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(Icons.music_note, color: theme.colorScheme.onSurfaceVariant),
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.song[widget.index].title,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: titleFontSize,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              widget.song[widget.index].artist,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: artistFontSize),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
