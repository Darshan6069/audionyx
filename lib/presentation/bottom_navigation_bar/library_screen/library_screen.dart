import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/library_screen/tabs/favourite_songs_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/library_screen/tabs/recenty_played_song.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/library_screen/tabs/download_song_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/home_screen/playlist_management_screen/playlist_management_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
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
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    // Responsive padding and sizes
    final appBarTitleFontSize =
        isDesktop
            ? 28.0
            : isTablet
            ? 24.0
            : 20.0;
    final tabLabelFontSize =
        isDesktop
            ? 16.0
            : isTablet
            ? 14.0
            : 12.0;
    final tabPadding =
        isDesktop
            ? const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0)
            : isTablet
            ? const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)
            : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Library',
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: appBarTitleFontSize,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurface.withOpacity(0.6),
          indicatorColor: colorScheme.primary,
          padding: EdgeInsets.symmetric(
            horizontal:
                isDesktop
                    ? 80.0
                    : isTablet
                    ? 40.0
                    : 20.0,
          ),
          tabs: [
            Tab(
              child: Text(
                'Liked',
                style: TextStyle(fontSize: tabLabelFontSize, fontWeight: FontWeight.w600),
              ),
            ),
            Tab(
              child: Text(
                'Downloads',
                style: TextStyle(fontSize: tabLabelFontSize, fontWeight: FontWeight.w600),
              ),
            ),
            Tab(
              child: Text(
                'Playlists',
                style: TextStyle(fontSize: tabLabelFontSize, fontWeight: FontWeight.w600),
              ),
            ),
            Tab(
              child: Text(
                'Recent',
                style: TextStyle(fontSize: tabLabelFontSize, fontWeight: FontWeight.w600),
              ),
            ),
          ],
          labelPadding: tabPadding,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const FavoriteSongScreen(),
          const DownloadedSongsScreen(showAppBar: false),
          const PlaylistManagementScreen(showAppBar: false),
          const RecentlyPlayedScreen(),
        ],
      ),
    );
  }
}
