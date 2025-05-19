class Lyric {
  final Duration startTime;
  final Duration endTime;
  final String text;

  Lyric({
    required this.startTime,
    required this.endTime,
    required this.text,
  });
}

class LyricParser {
  static List<Lyric> parseLyrics(String lyricsContent) {
    final List<Lyric> lyrics = [];
    final lines = lyricsContent.split('\n');
    int index = 0;

    while (index < lines.length) {
      if (lines[index].trim().isEmpty) {
        index++;
        continue;
      }

      if (!RegExp(r'^\d+$').hasMatch(lines[index].trim())) {
        index++;
        continue;
      }

      index++;
      if (index >= lines.length) break;
      final timeMatch = RegExp(r'(\d{2}:\d{2}:\d{2},\d{3})\s*-->\s*(\d{2}:\d{2}:\d{2},\d{3})').firstMatch(lines[index]);
      if (timeMatch == null) {
        index++;
        continue;
      }

      final startTime = _parseDuration(timeMatch.group(1)!);
      final endTime = _parseDuration(timeMatch.group(2)!);

      index++;
      final textLines = <String>[];
      while (index < lines.length && lines[index].trim().isNotEmpty && !RegExp(r'^\d+$').hasMatch(lines[index].trim())) {
        textLines.add(lines[index].trim());
        index++;
      }

      final text = textLines.join(' ');
      if (text.isNotEmpty) {
        lyrics.add(Lyric(
          startTime: startTime,
          endTime: endTime,
          text: text,
        ));
      }
    }

    return lyrics;
  }

  static Duration _parseDuration(String time) {
    final parts = time.split(':');
    final secondsParts = parts[2].split(',');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = int.parse(secondsParts[0]);
    final milliseconds = int.parse(secondsParts[1]);
    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
    );
  }
}