import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LyricsEmptyView extends StatelessWidget {
  const LyricsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final iconSize =
        isDesktop
            ? 60.0
            : isTablet
            ? 54.0
            : 48.0;
    final titleFontSize =
        isDesktop
            ? 22.0
            : isTablet
            ? 20.0
            : 18.0;
    final subtitleFontSize =
        isDesktop
            ? 16.0
            : isTablet
            ? 15.0
            : 14.0;
    final spacing =
        isDesktop
            ? 20.0
            : isTablet
            ? 18.0
            : 16.0;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.music_note_outlined, size: iconSize, color: Colors.white.withOpacity(0.3)),
          SizedBox(height: spacing),
          Text(
            'No lyrics available',
            style: TextStyle(color: Colors.white70, fontSize: titleFontSize),
          ),
          SizedBox(height: spacing * 0.5),
          Text(
            'Enjoy the music!',
            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: subtitleFontSize),
          ),
        ],
      ),
    );
  }
}
