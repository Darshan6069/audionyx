import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class FilterChipsWidget extends StatelessWidget {
  final String? selectedGenre;
  final String? selectedArtist;
  final String? selectedAlbum;
  final VoidCallback onGenreDeleted;
  final VoidCallback onArtistDeleted;
  final VoidCallback onAlbumDeleted;
  final VoidCallback onClearAll;

  const FilterChipsWidget({
    super.key,
    required this.selectedGenre,
    required this.selectedArtist,
    required this.selectedAlbum,
    required this.onGenreDeleted,
    required this.onArtistDeleted,
    required this.onAlbumDeleted,
    required this.onClearAll,
  });

  Widget _buildChip(BuildContext context, String label, VoidCallback onDelete) {
    final theme = Theme.of(context);
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final fontSize =
        isDesktop
            ? 14.0
            : isTablet
            ? 13.0
            : 12.0;
    final chipPadding =
        isDesktop
            ? const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0)
            : isTablet
            ? const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0)
            : const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);

    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: theme.brightness == Brightness.dark ? Colors.white : Colors.black87,
          fontSize: fontSize,
        ),
      ),
      backgroundColor: theme.brightness == Brightness.dark ? Colors.white10 : Colors.grey[300],
      deleteIconColor: theme.brightness == Brightness.dark ? Colors.white : Colors.black87,
      padding: chipPadding,
      labelPadding: EdgeInsets.symmetric(horizontal: chipPadding.horizontal / 2),
      onDeleted: onDelete,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final horizontalPadding =
        isDesktop
            ? 80.0
            : isTablet
            ? 40.0
            : 16.0;
    final verticalPadding = isDesktop || isTablet ? 12.0 : 8.0;
    final spacing =
        isDesktop
            ? 12.0
            : isTablet
            ? 10.0
            : 8.0;
    final fontSize =
        isDesktop
            ? 14.0
            : isTablet
            ? 12.0
            : 10.0;

    List<Widget> chips = [];

    if (selectedGenre != null) {
      chips.add(_buildChip(context, "Genre: $selectedGenre", onGenreDeleted));
    }

    if (selectedArtist != null) {
      chips.add(_buildChip(context, "Artist: $selectedArtist", onArtistDeleted));
    }

    if (selectedAlbum != null) {
      chips.add(_buildChip(context, "Album: $selectedAlbum", onAlbumDeleted));
    }

    final theme = Theme.of(context);

    return chips.isEmpty
        ? const SizedBox.shrink()
        : Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing / 2,
            children: [
              ...chips,
              if (chips.length > 1)
                TextButton.icon(
                  icon: Icon(
                    Icons.clear_all,
                    color: theme.colorScheme.secondary,
                    size:
                        isDesktop
                            ? 20.0
                            : isTablet
                            ? 18.0
                            : 16.0,
                  ),
                  label: Text(
                    'Clear All',
                    style: TextStyle(color: theme.colorScheme.secondary, fontSize: fontSize),
                  ),
                  onPressed: onClearAll,
                ),
            ],
          ),
        );
  }
}
