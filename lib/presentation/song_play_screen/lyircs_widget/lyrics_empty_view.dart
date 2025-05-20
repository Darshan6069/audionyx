import 'package:flutter/material.dart';

class LyricsEmptyView extends StatelessWidget {
  const LyricsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.music_note_outlined, size: 48, color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text('No lyrics available', style: TextStyle(color: Colors.white70, fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            'Enjoy the music!',
            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
