import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
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
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final dialogWidth =
        isDesktop
            ? 500.0
            : isTablet
            ? 400.0
            : 300.0;
    final titleFontSize =
        isDesktop
            ? 24.0
            : isTablet
            ? 20.0
            : 18.0;
    final labelFontSize =
        isDesktop
            ? 16.0
            : isTablet
            ? 14.0
            : 12.0;
    final dropdownFontSize =
        isDesktop
            ? 16.0
            : isTablet
            ? 14.0
            : 12.0;
    final dialogPadding =
        isDesktop
            ? 24.0
            : isTablet
            ? 20.0
            : 16.0;
    final buttonPadding =
        isDesktop
            ? const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0)
            : isTablet
            ? const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)
            : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

    List<String> genres = widget.service.getUniqueGenres(widget.allSongs);
    List<String> artists = widget.service.getUniqueArtists(widget.allSongs);
    List<String> albums = widget.service.getUniqueAlbums(widget.allSongs);

    return AlertDialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filter Songs',
            style: theme.textTheme.titleLarge?.copyWith(fontSize: titleFontSize),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: theme.iconTheme.color,
              size:
                  isDesktop
                      ? 28.0
                      : isTablet
                      ? 24.0
                      : 20.0,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Container(
          width: dialogWidth,
          padding: EdgeInsets.all(dialogPadding),
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
                theme,
                labelFontSize,
                dropdownFontSize,
                dialogPadding,
              ),
              SizedBox(height: dialogPadding),
              _buildDropdown(
                'Artist',
                'Select Artist',
                'Any Artist',
                artists,
                tempArtist,
                (value) => setState(() => tempArtist = value),
                theme,
                labelFontSize,
                dropdownFontSize,
                dialogPadding,
              ),
              SizedBox(height: dialogPadding),
              _buildDropdown(
                'Album',
                'Select Album',
                'Any Album',
                albums,
                tempAlbum,
                (value) => setState(() => tempAlbum = value),
                theme,
                labelFontSize,
                dropdownFontSize,
                dialogPadding,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            'Reset',
            style: TextStyle(color: theme.colorScheme.primary, fontSize: dropdownFontSize),
          ),
          style: TextButton.styleFrom(padding: buttonPadding),
          onPressed: () {
            setState(() {
              tempGenre = null;
              tempArtist = null;
              tempAlbum = null;
            });
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            padding: buttonPadding,
          ),
          child: Text(
            'Apply',
            style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: dropdownFontSize),
          ),
          onPressed: () {
            widget.onApply(tempGenre, tempArtist, tempAlbum);
            Navigator.pop(context);
          },
        ),
      ],
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: dialogPadding, vertical: 24.0),
    );
  }

  Widget _buildDropdown(
    String label,
    String hint,
    String anyLabel,
    List<String> items,
    String? value,
    Function(String?) onChanged,
    ThemeData theme,
    double labelFontSize,
    double dropdownFontSize,
    double dialogPadding,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: theme.colorScheme.primary, fontSize: labelFontSize)),
        SizedBox(height: dialogPadding / 2),
        Container(
          padding: EdgeInsets.symmetric(horizontal: dialogPadding / 2),
          decoration: BoxDecoration(
            color: theme.inputDecorationTheme.fillColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            hint: Text(
              hint,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color,
                fontSize: dropdownFontSize,
              ),
            ),
            value: value,
            isExpanded: true,
            dropdownColor: theme.inputDecorationTheme.prefixIconColor,
            underline: const SizedBox(),
            items: [
              DropdownMenuItem<String>(
                value: null,
                child: Text(
                  anyLabel,
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color,
                    fontSize: dropdownFontSize,
                  ),
                ),
              ),
              ...items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      color: theme.textTheme.bodyLarge?.color,
                      fontSize: dropdownFontSize,
                    ),
                  ),
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
