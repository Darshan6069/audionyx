import 'package:flutter/material.dart';
import 'package:audionyx/core/constants/theme_color.dart';

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

  Widget _buildChip(String label, VoidCallback onDelete) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          color: ThemeColor.white,
          fontSize: 12,
        ),
      ),
      backgroundColor: ThemeColor.darGreyColor,
      deleteIconColor: ThemeColor.white,
      onDeleted: onDelete,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> chips = [];

    if (selectedGenre != null) {
      chips.add(_buildChip(
        "Genre: $selectedGenre",
        onGenreDeleted,
      ));
    }

    if (selectedArtist != null) {
      chips.add(_buildChip(
        "Artist: $selectedArtist",
        onArtistDeleted,
      ));
    }

    if (selectedAlbum != null) {
      chips.add(_buildChip(
        "Album: $selectedAlbum",
        onAlbumDeleted,
      ));
    }

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
              icon: const Icon(Icons.clear_all, color: ThemeColor.greenAccent),
              label: const Text('Clear All', style: TextStyle(color: ThemeColor.greenAccent)),
              onPressed: onClearAll,
            ),
        ],
      ),
    );
  }
}