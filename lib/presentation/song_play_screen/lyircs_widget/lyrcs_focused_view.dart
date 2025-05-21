import 'package:flutter/material.dart';
import 'package:audionyx/domain/lyrics_model/lyrics_model.dart';
import 'package:responsive_framework/responsive_framework.dart';
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
            ? 24.0
            : isTablet
            ? 20.0
            : 16.0;
    final fontSize =
        isDesktop
            ? 24.0
            : isTablet
            ? 22.0
            : 20.0;
    final smallFontSize =
        isDesktop
            ? 14.0
            : isTablet
            ? 13.0
            : 12.0;
    final iconSize =
        isDesktop
            ? 32.0
            : isTablet
            ? 30.0
            : 28.0;
    final progressBarWidth =
        isDesktop
            ? 240.0
            : isTablet
            ? 220.0
            : 200.0;

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
          padding: EdgeInsets.only(top: paddingV, left: paddingH, right: paddingH),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: showAllLyricsCallback,
                icon: Icon(Icons.format_list_bulleted, color: Colors.white70, size: iconSize * 0.6),
                label: Text(
                  'All Lyrics',
                  style: TextStyle(color: Colors.white70, fontSize: smallFontSize),
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
              Text(
                formatDuration(position),
                style: TextStyle(color: Colors.white70, fontSize: smallFontSize),
              ),
            ],
          ),
        ),
        SizedBox(height: paddingV),
        if (prevLyric != null)
          LyricItem(
            lyric: prevLyric,
            textColor: Colors.white38,
            fontSize:
                isDesktop
                    ? 18.0
                    : isTablet
                    ? 17.0
                    : 16.0,
            centered: false,
            onTap: () => onLyricTap(prevLyric.startTime),
          ),
        SizedBox(height: paddingV * 0.75),
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
                      padding: EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
                      margin: EdgeInsets.symmetric(horizontal: paddingH),
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
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          if (nextLyric != null)
                            Container(
                              margin: EdgeInsets.only(top: paddingV),
                              width: progressBarWidth,
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
        SizedBox(height: paddingV * 0.75),
        if (nextLyric != null)
          LyricItem(
            lyric: nextLyric,
            textColor: Colors.white38,
            fontSize:
                isDesktop
                    ? 18.0
                    : isTablet
                    ? 17.0
                    : 16.0,
            centered: false,
            onTap: () => onLyricTap(nextLyric.startTime),
          ),
        Padding(
          padding: EdgeInsets.all(paddingV),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: prevLyric != null ? () => onLyricTap(prevLyric.startTime) : null,
                icon: Icon(
                  Icons.skip_previous,
                  color: prevLyric != null ? Colors.white : Colors.white24,
                  size: iconSize,
                ),
                splashRadius: iconSize * 0.8,
              ),
              SizedBox(width: paddingH * 0.5),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: paddingH * 0.75,
                  vertical: paddingV * 0.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${currentIndex + 1} / ${lyrics.length}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: smallFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: paddingH * 0.5),
              IconButton(
                onPressed: nextLyric != null ? () => onLyricTap(nextLyric.startTime) : null,
                icon: Icon(
                  Icons.skip_next,
                  color: nextLyric != null ? Colors.white : Colors.white24,
                  size: iconSize,
                ),
                splashRadius: iconSize * 0.8,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
