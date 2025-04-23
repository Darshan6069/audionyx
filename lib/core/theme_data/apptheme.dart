import 'package:audionyx/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import '../constants/theme_color.dart';
import 'app_text_theme.dart';
import 'breakpoint_enum.dart';

class AppTheme {
  static ThemeData getTheme(BreakpointEnum breakpoint, {bool isDark = false}) {
    final textTheme = AppTextTheme.getTextTheme(breakpoint);
    final colorScheme =
        isDark
            ? ColorScheme.fromSeed(
              seedColor: ThemeColor.greenColor,
              brightness: Brightness.dark,
            )
            : ColorScheme.fromSeed(seedColor: ThemeColor.lightGrey);

    return ThemeData(
      fontFamily: AppStrings.uberFont,
      textTheme: textTheme,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          isDark ? Colors.grey[900] : ThemeColor.whiteColor,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? Colors.grey[850] : ThemeColor.whiteColor,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
        toolbarHeight: kToolbarHeight,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(),
      useMaterial3: true,
    );
  }
}
