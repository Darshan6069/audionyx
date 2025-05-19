import 'package:flutter/material.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        child: Text(
          lyric.text,
          textAlign: centered ? TextAlign.center : TextAlign.center,
          style: TextStyle(color: textColor, fontSize: fontSize),
        ),
      ),
    );
  }
}