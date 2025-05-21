import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:audionyx/domain/lyrics_model/lyrics_model.dart';

class LyricItem extends StatelessWidget {
  final Lyric lyric;
  final Color textColor;
  final double fontSize;
  final bool centered;
  final VoidCallback onTap;

  const LyricItem({
    super.key,
    required this.lyric,
    required this.textColor,
    required this.fontSize,
    this.centered = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final paddingH =
        isDesktop
            ? 40.0
            : isTablet
            ? 32.0
            : 24.0;
    final paddingV =
        isDesktop
            ? 12.0
            : isTablet
            ? 10.0
            : 8.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
        child: Text(
          lyric.text,
          textAlign: centered ? TextAlign.center : TextAlign.center,
          style: TextStyle(color: textColor, fontSize: fontSize),
        ),
      ),
    );
  }
}
