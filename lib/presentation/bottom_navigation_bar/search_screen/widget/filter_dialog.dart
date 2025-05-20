import 'package:flutter/material.dart';

import '../../../../domain/song_model/song_model.dart';
import '../../../../repository/service/song_service/song_browser_service/song_browser_service.dart';

class FilterDialog extends StatefulWidget {
  final List<SongData> allSongs;
  final String? selectedGenre;
  final String? selectedArtist;
  final String? selectedAlbum;
  final SongBrowserService service;
  final Function(String?, String?, String?) onApply;

  const FilterDialog({
    super.key,
    required this.allSongs,
    required this.selectedGenre,
    required this.selectedArtist,
    required this.selectedAlbum,
    required this.service,
    required this.onApply,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late String? tempGenre;
  late String? tempArtist;
  late String? tempAlbum;

  @override
  void initState() {
    super.initState();
    tempGenre = widget.selectedGenre;
    tempArtist = widget.selectedArtist;
    tempAlbum = widget.selectedAlbum;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<String> genres = widget.service.getUniqueGenres(widget.allSongs);
    List<String> artists = widget.service.getUniqueArtists(widget.allSongs);
    List<String> albums = widget.service.getUniqueAlbums(widget.allSongs);

    return AlertDialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Filter Songs', style: theme.textTheme.titleLarge),
          IconButton(
            icon: Icon(Icons.close, color: theme.iconTheme.color),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown(
              'Genre',
              'Select Genre',
              'Any Genre',
              genres,
              tempGenre,
              (value) => setState(() => tempGenre = value),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              'Artist',
              'Select Artist',
              'Any Artist',
              artists,
              tempArtist,
              (value) => setState(() => tempArtist = value),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              'Album',
              'Select Album',
              'Any Album',
              albums,
              tempAlbum,
              (value) => setState(() => tempAlbum = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Reset', style: TextStyle(color: theme.colorScheme.primary)),
          onPressed: () {
            setState(() {
              tempGenre = null;
              tempArtist = null;
              tempAlbum = null;
            });
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary),
          child: Text('Apply', style: TextStyle(color: theme.colorScheme.onPrimary)),
          onPressed: () {
            widget.onApply(tempGenre, tempArtist, tempAlbum);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String hint,
    String anyLabel,
    List<String> items,
    String? value,
    Function(String?) onChanged,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: theme.colorScheme.primary)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: theme.inputDecorationTheme.fillColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            hint: Text(hint, style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
            value: value,
            isExpanded: true,
            dropdownColor: theme.inputDecorationTheme.prefixIconColor,
            underline: const SizedBox(),
            items: [
              DropdownMenuItem<String>(
                value: null,
                child: Text(anyLabel, style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
              ),
              ...items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item, style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
                );
              }),
            ],
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
