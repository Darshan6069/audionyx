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
        color: Theme.of(context).textTheme.bodyLarge!.color,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}