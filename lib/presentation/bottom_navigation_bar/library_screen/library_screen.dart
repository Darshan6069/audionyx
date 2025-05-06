import 'package:audionyx/core/constants/theme_color.dart';
import 'package:audionyx/presentation/download_song_screen/download_song_screen.dart';
import 'package:audionyx/presentation/playlist_management_screen/playlist_management_screen.dart';
import 'package:audionyx/repository/service/song_service/recently_play_song/recently_played_manager.dart';
import 'package:flutter/material.dart';

import '../../../domain/song_model/song_model.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        centerTitle: true,
        foregroundColor: ThemeColor.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: ThemeColor.white,
          unselectedLabelColor: ThemeColor.white.withOpacity(0.6),
          indicatorColor: ThemeColor.white,
          tabs: const [
            Tab(text: 'Liked'),
            Tab(text: 'Downloads'),
            Tab(text: 'Playlists'),
            Tab(text: 'Recent'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Liked Songs Tab
          _buildLikedSongsTab(isLargeScreen),
          // Downloaded Songs Tab
          DownloadedSongsScreen(), // Playlists Tab
          PlaylistManagementScreen(), // Recently Played Tab
          _buildRecentlyPlayedTab(isLargeScreen),
        ],
      ),
    );
  }

  Widget _buildLikedSongsTab(bool isLargeScreen) {
    return GridView.builder(
      padding: EdgeInsets.all(isLargeScreen ? 24 : 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isLargeScreen ? 2 : 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isLargeScreen ? 3 : 4,
      ),
      itemCount: 10, // Mock data
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white30,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Liked Song ${index + 1}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: isLargeScreen ? 18 : 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'Artist ${index + 1}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: isLargeScreen ? 16 : 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentlyPlayedTab(bool isLargeScreen) {
    bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return FutureBuilder<List<SongData>>(
      future: RecentlyPlayedManager.loadRecentlyPlayed(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading recently played songs.'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No recently played songs.'));
        }

        final recentlyPlayedSongs = snapshot.data!;

        return ListView.builder(
          padding: EdgeInsets.all(isLargeScreen ? 24 : 16),
          itemCount: recentlyPlayedSongs.length,
          itemBuilder: (context, index) {
            final song = recentlyPlayedSongs[index];

            return Card(
              color: Colors.white30,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                title: Text(
                  song.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: isLargeScreen ? 18 : 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  song.artist,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: isLargeScreen ? 16 : 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(
                  Icons.play_circle,
                  size: isLargeScreen ? 32 : 24,
                  color: Colors.blue,
                ),
                onTap: () {
                  // Handle song play action here
                },
              ),
            );
          },
        );
      },
    );
  }
}
