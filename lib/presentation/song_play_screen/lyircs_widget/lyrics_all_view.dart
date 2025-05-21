import 'package:flutter/material.dart';
import 'package:audionyx/domain/lyrics_model/lyrics_model.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final paddingH =
        isDesktop
            ? 40.0
            : isTablet
            ? 24.0
            : 16.0;
    final paddingV =
        isDesktop
            ? 40.0
            : isTablet
            ? 32.0
            : 24.0;
    final fontSize =
        isDesktop
            ? 20.0
            : isTablet
            ? 18.0
            : 16.0;
    final iconSize =
        isDesktop
            ? 22.0
            : isTablet
            ? 20.0
            : 18.0;
    final itemPaddingV =
        isDesktop
            ? 20.0
            : isTablet
            ? 16.0
            : 12.0;

    return Column(
      children: [
        if (currentIndex != -1)
          Padding(
            padding: EdgeInsets.only(top: paddingV, left: paddingH, right: paddingH),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: backToFocusedView,
                  icon: Icon(Icons.arrow_back, color: Colors.white70, size: iconSize),
                  label: Text(
                    'Back to Current',
                    style: TextStyle(color: Colors.white70, fontSize: fontSize * 0.8),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: paddingH * 0.75,
                      vertical: paddingV * 0.5,
                    ),
                    backgroundColor: Colors.white10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
            itemCount: lyrics.length,
            itemBuilder: (context, index) {
              final lyric = lyrics[index];
              final isCurrent = index == currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(
                  vertical: isCurrent ? itemPaddingV * 1.2 : itemPaddingV,
                  horizontal: paddingH,
                ),
                margin: EdgeInsets.only(bottom: paddingV * 0.5),
                decoration: BoxDecoration(
                  color:
                      isCurrent
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
                          padding: EdgeInsets.only(right: paddingH * 0.5),
                          child: Icon(
                            Icons.play_arrow,
                            size: iconSize * 0.8,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      Expanded(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            color: isCurrent ? Colors.white : Colors.white70,
                            fontSize: isCurrent ? fontSize * 1.1 : fontSize,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
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
