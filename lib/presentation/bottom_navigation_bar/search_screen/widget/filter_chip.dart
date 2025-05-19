import 'package:flutter/material.dart';

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
    final ThemeData theme = Theme.of(context);
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color:
              theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
          fontSize: 12,
        ),
      ),
      backgroundColor:
          theme.brightness == Brightness.dark
              ? Colors.white10
              : Colors.grey[300],
      deleteIconColor:
          theme.brightness == Brightness.dark ? Colors.white : Colors.black87,
      onDeleted: onDelete,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> chips = [];

    if (selectedGenre != null) {
      chips.add(_buildChip(context, "Genre: $selectedGenre", onGenreDeleted));
    }

    if (selectedArtist != null) {
      chips.add(
        _buildChip(context, "Artist: $selectedArtist", onArtistDeleted),
      );
    }

    if (selectedAlbum != null) {
      chips.add(_buildChip(context, "Album: $selectedAlbum", onAlbumDeleted));
    }

    final ThemeData theme = Theme.of(context);

    return chips.isEmpty
        ? const SizedBox.shrink()
        : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              ...chips,
              if (chips.length > 1)
                TextButton.icon(
                  icon: Icon(
                    Icons.clear_all,
                    color: theme.colorScheme.secondary,
                  ),
                  label: Text(
                    'Clear All',
                    style: TextStyle(color: theme.colorScheme.secondary),
                  ),
                  onPressed: onClearAll,
                ),
            ],
          ),
        );
  }
}
