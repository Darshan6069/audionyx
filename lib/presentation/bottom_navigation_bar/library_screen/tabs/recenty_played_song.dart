import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/presentation/song_play_screen/song_play_screen.dart';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:flutter/material.dart';

import '../../../../repository/service/song_service/recently_play_song/recently_played_manager.dart';

class RecentlyPlayedScreen extends StatelessWidget {
  const RecentlyPlayedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return FutureBuilder<List<SongData>>(
      future: RecentlyPlayedManager.loadRecentlyPlayed(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.secondary,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading recently played songs.',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.textTheme.bodyLarge?.color,
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
              ),
            ),
          );
        }

        final recentlyPlayedSongs = snapshot.data!;

        return ListView.builder(
          padding: EdgeInsets.all(isLargeScreen ? 24 : 16),
          itemCount: recentlyPlayedSongs.length,
          itemBuilder: (context, index) {
            final song = recentlyPlayedSongs[index];

            return _buildSongCard(
                context,
                song,
                isLargeScreen,
                recentlyPlayedSongs,
                index
            );
          },
        );
      },
    );
  }

  Widget _buildSongCard(
      BuildContext context,
      SongData song,
      bool isLargeScreen,
      List<SongData> songList,
      int index,
      ) {
    final ThemeData theme = Theme.of(context);
    return Card(
      color: theme.brightness == Brightness.dark
          ? theme.colorScheme.surface
          : Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.brightness == Brightness.dark
              ? Colors.white10
              : Colors.grey[200]!,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: _buildSongThumbnail(song, isLargeScreen,context),
        title: Text(
          song.title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.textTheme.bodyLarge?.color,
            fontSize: isLargeScreen ? 18 : 16,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          song.artist,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color,
            fontSize: isLargeScreen ? 14 : 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.play_circle_filled,
            color: theme.colorScheme.secondary,
            size: isLargeScreen ? 32 : 28,
          ),
          onPressed: () {
            // Navigate to SongPlayerScreen when play button is pressed
            context.push(
              context,
              target: SongPlayerScreen(
                songList: songList,
                initialIndex: index,
              ),
            );
          },
        ),
        onTap: () {
          // Navigate to SongPlayerScreen when card is tapped
          context.push(
            context,
            target: SongPlayerScreen(
              songList: songList,
              initialIndex: index,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSongThumbnail(SongData song, bool isLargeScreen,BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: song.thumbnailUrl != null
          ? Image.network(
        song.thumbnailUrl,
        width: isLargeScreen ? 60 : 50,
        height: isLargeScreen ? 60 : 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildPlaceholderThumbnail(isLargeScreen,context),
      )
          : _buildPlaceholderThumbnail(isLargeScreen,context),
    );
  }

  Widget _buildPlaceholderThumbnail(bool isLargeScreen,BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: isLargeScreen ? 60 : 50,
      height: isLargeScreen ? 60 : 50,
      color: theme.colorScheme.surface,
      child: Icon(
        Icons.music_note,
        color: theme.iconTheme.color,
        size: 24,
      ),
    );
  }
}