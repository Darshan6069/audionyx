import 'package:audionyx/core/constants/theme_color.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final double fontSize;

  const SectionTitle(this.title, {super.key, this.fontSize = 20});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: ThemeColor.white,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
