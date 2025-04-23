import 'package:flutter/material.dart';
import '../../core/constants/theme_color.dart';

class CommonHeading extends StatelessWidget {
  final String title;

  const CommonHeading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w500),
          children: <TextSpan>[
            TextSpan(text: title),
            TextSpan(
              text: '.',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: ThemeColor.greenColor),
            ),
          ],
        ),
      ),
    );
  }
}
