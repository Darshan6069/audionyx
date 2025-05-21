import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CreatePlaylistDialogWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onCreate;
  final VoidCallback onCancel;

  const CreatePlaylistDialogWidget({
    super.key,
    required this.controller,
    required this.onCreate,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    // Responsive padding and sizes similar to home_screen.dart
    final dialogPadding =
        isDesktop
            ? 40.0
            : isTablet
            ? 32.0
            : 20.0;
    final dialogWidth =
        isDesktop
            ? 500.0
            : isTablet
            ? 400.0
            : 280.0;
    final titleFontSize =
        isDesktop
            ? 24.0
            : isTablet
            ? 20.0
            : 18.0;
    final buttonPadding =
        isDesktop
            ? const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0)
            : isTablet
            ? const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)
            : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

    return AlertDialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      title: Text(
        'Create New Playlist',
        style: textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: titleFontSize,
        ),
      ),
      content: SizedBox(
        width: dialogWidth,
        child: TextField(
          controller: controller,
          autofocus: true,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
            fontSize: isDesktop ? 18.0 : 16.0,
          ),
          decoration: InputDecoration(
            hintText: 'Enter playlist name',
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
            filled: true,
            fillColor: colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            contentPadding: EdgeInsets.all(dialogPadding / 2),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              onCreate(value.trim());
            }
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          style: TextButton.styleFrom(padding: buttonPadding),
          child: Text(
            'Cancel',
            style: TextStyle(color: colorScheme.onSurface, fontSize: isDesktop ? 16.0 : 14.0),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final playlistName = controller.text.trim();
            if (playlistName.isNotEmpty) {
              onCreate(playlistName);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: buttonPadding,
          ),
          child: Text('Create', style: TextStyle(fontSize: isDesktop ? 16.0 : 14.0)),
        ),
      ],
      contentPadding: EdgeInsets.all(dialogPadding),
      insetPadding: EdgeInsets.symmetric(horizontal: dialogPadding, vertical: 24.0),
    );
  }
}
