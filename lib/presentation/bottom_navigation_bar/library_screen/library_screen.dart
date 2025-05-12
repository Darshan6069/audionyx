import 'package:audionyx/core/constants/theme_color.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/library_screen/tabs/favourite_songs_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/library_screen/tabs/recenty_played_song.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/library_screen/tabs/download_song_screen.dart';
import 'package:audionyx/repository/service/song_service/recently_play_song/recently_played_manager.dart';
import 'package:flutter/material.dart';

import '../../../domain/song_model/song_model.dart';
import '../home_screen/playlist_management_screen/playlist_management_screen.dart';

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
          FavoriteSongScreen(), // Downloaded Songs Tab
          DownloadedSongsScreen(), // Playlists Tab
          PlaylistManagementScreen(), // Recently Played Tab
          RecentlyPlayedScreen(),        ],
      ),
    );
  }
}
