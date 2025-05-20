import 'package:flutter/material.dart';
import 'package:audionyx/domain/lyrics_model/lyrics_model.dart';

import 'lyrics_item.dart';

class LyricsFocusedView extends StatelessWidget {
  final List<Lyric> lyrics;
  final int currentIndex;
  final Duration position;
  final Animation<double> pulseAnimation;
  final AnimationController animationController;
  final String Function(Duration) formatDuration;
  final Function(Duration) onLyricTap;
  final VoidCallback showAllLyricsCallback;

  const LyricsFocusedView({
    super.key,
    required this.lyrics,
    required this.currentIndex,
    required this.position,
    required this.pulseAnimation,
    required this.animationController,
    required this.formatDuration,
    required this.onLyricTap,
    required this.showAllLyricsCallback,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prevLyric = currentIndex > 0 ? lyrics[currentIndex - 1] : null;
    final currentLyric = lyrics[currentIndex];
    final nextLyric = currentIndex < lyrics.length - 1 ? lyrics[currentIndex + 1] : null;

    double progress = 0.0;
    if (currentIndex < lyrics.length - 1) {
      final totalDuration = lyrics[currentIndex + 1].startTime - currentLyric.startTime;
      final elapsed = position - currentLyric.startTime;
      progress = (elapsed.inMilliseconds / totalDuration.inMilliseconds).clamp(0.0, 1.0);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: showAllLyricsCallback,
                icon: const Icon(Icons.format_list_bulleted, color: Colors.white70, size: 18),
                label: const Text('All Lyrics', style: TextStyle(color: Colors.white70)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  backgroundColor: Colors.white10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
              Text(
                formatDuration(position),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (prevLyric != null)
          LyricItem(
            lyric: prevLyric,
            textColor: Colors.white38,
            fontSize: 16,
            centered: false,
            onTap: () => onLyricTap(prevLyric.startTime),
          ),
        const SizedBox(height: 12),
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () => onLyricTap(currentLyric.startTime),
            child: Center(
              child: AnimatedBuilder(
                animation: pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: pulseAnimation.value,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.primaryColor.withOpacity(0.3), width: 1),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentLyric.text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          if (nextLyric != null)
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              width: 200,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: progress,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (nextLyric != null)
          LyricItem(
            lyric: nextLyric,
            textColor: Colors.white38,
            fontSize: 16,
            centered: false,
            onTap: () => onLyricTap(nextLyric.startTime),
          ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: prevLyric != null ? () => onLyricTap(prevLyric.startTime) : null,
                icon: Icon(
                  Icons.skip_previous,
                  color: prevLyric != null ? Colors.white : Colors.white24,
                  size: 28,
                ),
                splashRadius: 24,
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${currentIndex + 1} / ${lyrics.length}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: nextLyric != null ? () => onLyricTap(nextLyric.startTime) : null,
                icon: Icon(
                  Icons.skip_next,
                  color: nextLyric != null ? Colors.white : Colors.white24,
                  size: 28,
                ),
                splashRadius: 24,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
