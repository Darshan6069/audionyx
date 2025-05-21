import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/presentation/song_play_screen/song_play_screen.dart';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../../repository/service/song_service/recently_play_song/recently_played_manager.dart';

class RecentlyPlayedScreen extends StatelessWidget {
  const RecentlyPlayedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    // Responsive padding
    final padding =
        isDesktop
            ? 40.0
            : isTablet
            ? 32.0
            : 16.0;

    return FutureBuilder<List<SongData>>(
      future: RecentlyPlayedManager.loadRecentlyPlayed(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: theme.colorScheme.secondary));
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading recently played songs.',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.textTheme.bodyLarge?.color,
                fontSize:
                    isDesktop
                        ? 20.0
                        : isTablet
                        ? 18.0
                        : 16.0,
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No recently played songs.',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.textTheme.bodyLarge?.color,
                fontSize:
                    isDesktop
                        ? 20.0
                        : isTablet
                        ? 18.0
                        : 16.0,
              ),
            ),
          );
        }

        final recentlyPlayedSongs = snapshot.data!;

        return ListView.builder(
          padding: EdgeInsets.all(padding),
          itemCount: recentlyPlayedSongs.length,
          itemBuilder: (context, index) {
            final song = recentlyPlayedSongs[index];
            return _buildSongCard(context, song, isDesktop, isTablet, recentlyPlayedSongs, index);
          },
        );
      },
    );
  }

  Widget _buildSongCard(
    BuildContext context,
    SongData song,
    bool isDesktop,
    bool isTablet,
    List<SongData> songList,
    int index,
  ) {
    final theme = Theme.of(context);
    final thumbnailSize =
        isDesktop
            ? 64.0
            : isTablet
            ? 60.0
            : 50.0;
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
    final contentPadding =
        isDesktop
            ? const EdgeInsets.all(16.0)
            : isTablet
            ? const EdgeInsets.all(14.0)
            : const EdgeInsets.all(12.0);

    return Card(
      color: theme.brightness == Brightness.dark ? theme.colorScheme.surface : Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.brightness == Brightness.dark ? Colors.white10 : Colors.grey[200]!,
          width: 1,
        ),
      ),
      margin: EdgeInsets.symmetric(
        horizontal:
            isDesktop
                ? 20.0
                : isTablet
                ? 16.0
                : 4.0,
        vertical: 8.0,
      ),
      child: ListTile(
        contentPadding: contentPadding,
        leading: _buildSongThumbnail(song, isDesktop, isTablet, context),
        title: Text(
          song.title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.textTheme.bodyLarge?.color,
            fontSize: titleFontSize,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          song.artist,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color,
            fontSize: subtitleFontSize,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.play_circle_filled,
            color: theme.colorScheme.secondary,
            size:
                isDesktop
                    ? 32.0
                    : isTablet
                    ? 28.0
                    : 24.0,
          ),
          onPressed: () {
            context.push(
              context,
              target: SongPlayerScreen(songList: songList, initialIndex: index),
            );
          },
        ),
        onTap: () {
          context.push(context, target: SongPlayerScreen(songList: songList, initialIndex: index));
        },
      ),
    );
  }

  Widget _buildSongThumbnail(SongData song, bool isDesktop, bool isTablet, BuildContext context) {
    final theme = Theme.of(context);
    final thumbnailSize =
        isDesktop
            ? 64.0
            : isTablet
            ? 60.0
            : 50.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child:
          song.thumbnailUrl != null
              ? Image.network(
                song.thumbnailUrl,
                width: thumbnailSize,
                height: thumbnailSize,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        _buildPlaceholderThumbnail(isDesktop, isTablet, context),
              )
              : _buildPlaceholderThumbnail(isDesktop, isTablet, context),
    );
  }

  Widget _buildPlaceholderThumbnail(bool isDesktop, bool isTablet, BuildContext context) {
    final theme = Theme.of(context);
    final thumbnailSize =
        isDesktop
            ? 64.0
            : isTablet
            ? 60.0
            : 50.0;

    return Container(
      width: thumbnailSize,
      height: thumbnailSize,
      color: theme.colorScheme.surface,
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
    );
  }
}
