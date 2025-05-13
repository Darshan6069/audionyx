import 'package:flutter/material.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/library_screen/tabs/favourite_songs_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/library_screen/tabs/recenty_played_song.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/library_screen/tabs/download_song_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/home_screen/playlist_management_screen/playlist_management_screen.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Library',
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurface.withOpacity(0.6),
          indicatorColor: colorScheme.primary,
          tabs: const [
            Tab(text: 'Liked'),
            Tab(text: 'Downloads'),
            Tab(text: 'Playlists'),
            Tab(text: 'Recent'),
          ],
          labelStyle: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Liked Songs Tab
          const FavoriteSongScreen(),
          // Downloaded Songs Tab
          const DownloadedSongsScreen(showAppBar: false),
          // Playlists Tab
          const PlaylistManagementScreen(showAppBar: false),
          // Recently Played Tab
          const RecentlyPlayedScreen(),
        ],
      ),
    );
  }
}