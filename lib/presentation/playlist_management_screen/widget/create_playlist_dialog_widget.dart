import 'package:flutter/material.dart';

import '../../../core/constants/theme_color.dart';

class CreatePlaylistDialogWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onCancel;
  final ValueChanged<String> onCreate;

  const CreatePlaylistDialogWidget({
    super.key,
    required this.controller,
    required this.onCancel,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ThemeColor.darGreyColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Create New Playlist',
        style: TextStyle(
          color: ThemeColor.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: TextField(
        controller: controller,
        style: const TextStyle(color: ThemeColor.white),
        decoration: InputDecoration(
          hintText: 'Enter playlist name',
          hintStyle: const TextStyle(color: ThemeColor.grey),
          filled: true,
          fillColor: ThemeColor.darkBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text(
            'Cancel',
            style: TextStyle(color: ThemeColor.grey),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final playlistName = controller.text.trim();
            if (playlistName.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Playlist name cannot be empty'),
                  backgroundColor: ThemeColor.darGreyColor,
                ),
              );
              return;
            }
            onCreate(playlistName);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeColor.greenAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text(
            'Create',
            style: TextStyle(color: ThemeColor.white),
          ),
        ),
      ],
    );
  }
}