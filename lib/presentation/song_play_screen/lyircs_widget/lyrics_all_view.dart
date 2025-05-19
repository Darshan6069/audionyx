import 'package:flutter/material.dart';
import 'package:audionyx/domain/lyrics_model/lyrics_model.dart';

class LyricsAllView extends StatelessWidget {
  final List<Lyric> lyrics;
  final int currentIndex;
  final ScrollController scrollController;
  final void Function(Duration, int) onLyricTap;
  final VoidCallback backToFocusedView;

  const LyricsAllView({
    super.key,
    required this.lyrics,
    required this.currentIndex,
    required this.scrollController,
    required this.onLyricTap,
    required this.backToFocusedView,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (currentIndex != -1)
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: backToFocusedView,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white70,
                    size: 18,
                  ),
                  label: const Text(
                    'Back to Current',
                    style: TextStyle(color: Colors.white70),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    backgroundColor: Colors.white10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            itemCount: lyrics.length,
            itemBuilder: (context, index) {
              final lyric = lyrics[index];
              final isCurrent = index == currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(
                  vertical: isCurrent ? 16.0 : 12.0,
                  horizontal: 16.0,
                ),
                margin: const EdgeInsets.only(bottom: 8.0),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? Theme.of(context).primaryColor.withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () => onLyricTap(lyric.startTime, index),
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (isCurrent)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.play_arrow,
                            size: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      Expanded(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            color: isCurrent ? Colors.white : Colors.white70,
                            fontSize: isCurrent ? 18 : 16,
                            fontWeight:
                            isCurrent ? FontWeight.bold : FontWeight.normal,
                            letterSpacing: isCurrent ? 0.5 : 0.3,
                          ),
                          child: Text(lyric.text, textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}