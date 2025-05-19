import 'package:flutter/material.dart';

class ThemeColor {
  static const whiteColor = Color(0xffFFFFFF);
  static const blackColor = Color(0xff121212);
  static const darGreyColor = Color(0xff282828);
  static const lightGrey = Color(0xff777777);

  static const darkBackground = Color(0xFF121212);
  static const greenAccent = Color(0xFF1DB954);
  static const white = Colors.white;
  static const grey = Color(0xFFB3B3B3);

  static const Color black = Colors.black;
  static const Color greenColor = Color(0xFF1DB954); // Spotify-like green
  static const Color blueColor = Color(0xFF3B82F6); // Primary blue
  static const Color errorColor = Colors.red;

  // Get colors based on the current theme brightness
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? white
        : const Color(0xFF121212);
  }

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? black : white;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.black54
        : Colors.white70;
  }

  static Color getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.grey[100]!
        : Colors.white10;
  }

  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? blueColor
        : const Color(0xFF60A5FA);
  }
}
