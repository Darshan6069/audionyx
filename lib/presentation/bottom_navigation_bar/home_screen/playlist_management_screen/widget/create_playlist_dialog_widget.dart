import 'package:flutter/material.dart';

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

    return AlertDialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      title: Text(
        'Create New Playlist',
        style: textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: TextField(
        controller: controller,
        autofocus: true,
        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
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
        ),
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            onCreate(value.trim());
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text('Cancel', style: TextStyle(color: colorScheme.onSurface)),
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
          ),
          child: const Text('Create'),
        ),
      ],
    );
  }
}
