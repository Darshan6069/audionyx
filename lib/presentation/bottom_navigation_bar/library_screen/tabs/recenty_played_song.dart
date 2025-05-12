import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/core/constants/theme_color.dart';
import 'package:audionyx/presentation/song_play_screen/song_play_screen.dart';
import 'package:audionyx/repository/service/song_service/recently_play_song/recently_played_manager.dart';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:flutter/material.dart';

class RecentlyPlayedScreen extends StatelessWidget {
  const RecentlyPlayedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return FutureBuilder<List<SongData>>(
      future: RecentlyPlayedManager.loadRecentlyPlayed(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Error loading recently played songs.',
              style: TextStyle(color: ThemeColor.white),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No recently played songs.',
              style: TextStyle(color: ThemeColor.white),
            ),
          );
        }

        final recentlyPlayedSongs = snapshot.data!;

        return ListView.builder(
          padding: EdgeInsets.all(isLargeScreen ? 24 : 16),
          itemCount: recentlyPlayedSongs.length,
          itemBuilder: (context, index) {
            final song = recentlyPlayedSongs[index];

            return _buildSongCard(context, song, isLargeScreen, recentlyPlayedSongs, index);
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
    return Card(
      color: ThemeColor.darGreyColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: _buildSongThumbnail(song, isLargeScreen),
        title: Text(
          song.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: ThemeColor.white,
            fontSize: isLargeScreen ? 18 : 16,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          song.artist,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ThemeColor.white.withOpacity(0.7),
            fontSize: isLargeScreen ? 14 : 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.play_circle_filled,
            color: ThemeColor.greenAccent,
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

  Widget _buildSongThumbnail(SongData song, bool isLargeScreen) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: song.thumbnailUrl != null
          ? Image.network(
        song.thumbnailUrl!,
        width: isLargeScreen ? 60 : 50,
        height: isLargeScreen ? 60 : 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderThumbnail(isLargeScreen),
      )
          : _buildPlaceholderThumbnail(isLargeScreen),
    );
  }

  Widget _buildPlaceholderThumbnail(bool isLargeScreen) {
    return Container(
      width: isLargeScreen ? 60 : 50,
      height: isLargeScreen ? 60 : 50,
      color: ThemeColor.white.withOpacity(0.2),
      child: const Icon(
        Icons.music_note,
        color: ThemeColor.white,
        size: 24,
      ),
    );
  }
}