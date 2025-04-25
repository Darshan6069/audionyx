import 'package:flutter/material.dart';

class LyricsScreen extends StatelessWidget {
  final String songPath;

  const LyricsScreen({super.key, required this.songPath});

  @override
  Widget build(BuildContext context) {
    final fileName = songPath.split('/').last;
    final dummyLyrics = '''
    [Verse 1]
    This is a demo lyric,
    Showing how the words stick,
    With a simple trick.

    [Chorus]
    Music in your soul,
    Let the rhythm take control.
    ''';

    return Scaffold(
      appBar: AppBar(title: const Text("Lyrics")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Text(dummyLyrics, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
