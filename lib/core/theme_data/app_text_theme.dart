import 'package:flutter/material.dart';
import 'breakpoint_enum.dart';

class AppTextTheme {
  static const _fontFamily = 'UberFont';
  static const _baseHeadlineStyle = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );
  static const _baseBodyStyle = TextStyle(
    fontFamily: _fontFamily,
    letterSpacing: 0,
  );

  static double _scaleFactor(BreakpointEnum breakpoint) {
    switch (breakpoint) {
      case BreakpointEnum.mobile:
        return 0.9;
      case BreakpointEnum.tablet:
        return 1.0;
      case BreakpointEnum.desktop:
        return 1.2;
    }
  }

  static TextTheme getTextTheme(BreakpointEnum breakpoint) {
    final scale = _scaleFactor(breakpoint);

    return TextTheme(
      headlineLarge: _baseHeadlineStyle.copyWith(
        fontSize: 36 * scale,
        height: 1.2,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: _baseHeadlineStyle.copyWith(
        fontSize: 32 * scale,
        height: 1.2,
      ),
      headlineSmall: _baseHeadlineStyle.copyWith(
        fontSize: 24 * scale,
        height: 1.2,
      ),
      bodyLarge: _baseBodyStyle.copyWith(
        fontSize: 16 * scale,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: _baseBodyStyle.copyWith(
        fontSize: 14 * scale,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: _baseBodyStyle.copyWith(
        fontSize: 12 * scale,
        fontWeight: FontWeight.w400,
      ),
      titleLarge: _baseBodyStyle.copyWith(
        fontSize: 16 * scale,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: _baseBodyStyle.copyWith(
        fontSize: 14 * scale,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: _baseBodyStyle.copyWith(
        fontSize: 12 * scale,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}