import 'package:audionyx/presentation/bottom_navigation_bar/search_screen/widget/song_tile.dart';
import 'package:flutter/material.dart';
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
    final ThemeData theme = Theme.of(context);

    if (filteredSongs.isEmpty) {
      return _buildEmptyView(context);
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: filteredSongs.length,
      separatorBuilder:
          (context, index) => Divider(
            height: 1,
            color: theme.brightness == Brightness.dark ? Colors.white10 : Colors.grey[300],
            indent: 76,
            endIndent: 16,
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

  Widget _buildEmptyView(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_off,
            color: theme.brightness == Brightness.dark ? Colors.white38 : Colors.black45,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            searchQuery.isNotEmpty
                ? 'No songs matched "$searchQuery"'
                : 'No songs found with selected filters',
            style: TextStyle(
              color: theme.brightness == Brightness.dark ? Colors.white38 : Colors.black45,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (searchQuery.isNotEmpty || hasFilters)
            ElevatedButton(
              onPressed: onClearFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Clear Filters',
                style: TextStyle(
                  color: theme.brightness == Brightness.dark ? Colors.black : Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
