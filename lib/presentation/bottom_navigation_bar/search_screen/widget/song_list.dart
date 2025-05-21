import 'package:audionyx/presentation/bottom_navigation_bar/search_screen/widget/song_tile.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:audionyx/repository/service/song_service/song_browser_service/song_browser_service.dart';

class SongListWidget extends StatelessWidget {
  final List<SongData> filteredSongs;
  final String searchQuery;
  final bool hasFilters;
  final SongBrowserService service;
  final VoidCallback onClearFilters;

  const SongListWidget({
    super.key,
    required this.filteredSongs,
    required this.searchQuery,
    required this.hasFilters,
    required this.service,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final bottomPadding =
        isDesktop
            ? 24.0
            : isTablet
            ? 20.0
            : 16.0;
    final separatorIndent =
        isDesktop
            ? 84.0
            : isTablet
            ? 80.0
            : 76.0;

    if (filteredSongs.isEmpty) {
      return _buildEmptyView(context, isDesktop, isTablet);
    }

    return ListView.separated(
      padding: EdgeInsets.only(bottom: bottomPadding),
      itemCount: filteredSongs.length,
      separatorBuilder:
          (context, index) => Divider(
            height: 1,
            color: theme.brightness == Brightness.dark ? Colors.white10 : Colors.grey[300],
            indent: separatorIndent,
            endIndent:
                isDesktop
                    ? 80.0
                    : isTablet
                    ? 40.0
                    : 16.0,
          ),
      itemBuilder:
          (context, index) => SongTile(
            song: filteredSongs[index],
            index: index,
            songs: filteredSongs,
            service: service,
          ),
    );
  }

  Widget _buildEmptyView(BuildContext context, bool isDesktop, bool isTablet) {
    final theme = Theme.of(context);
    final iconSize =
        isDesktop
            ? 80.0
            : isTablet
            ? 72.0
            : 64.0;
    final fontSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 16.0
            : 14.0;
    final verticalSpacing = isDesktop || isTablet ? 20.0 : 16.0;
    final buttonPadding =
        isDesktop
            ? const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0)
            : isTablet
            ? const EdgeInsets.symmetric(horizontal: 28.0, vertical: 14.0)
            : const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_off,
            color: theme.brightness == Brightness.dark ? Colors.white38 : Colors.black45,
            size: iconSize,
          ),
          SizedBox(height: verticalSpacing),
          Text(
            searchQuery.isNotEmpty
                ? 'No songs matched "$searchQuery"'
                : 'No songs found with selected filters',
            style: TextStyle(
              color: theme.brightness == Brightness.dark ? Colors.white38 : Colors.black45,
              fontSize: fontSize,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: verticalSpacing),
          if (searchQuery.isNotEmpty || hasFilters)
            ElevatedButton(
              onPressed: onClearFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
                padding: buttonPadding,
              ),
              child: Text(
                'Clear Filters',
                style: TextStyle(
                  color: theme.brightness == Brightness.dark ? Colors.black : Colors.white,
                  fontSize: fontSize,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
