import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ThemeCubit manages the theme state of the application
/// It emits a boolean value: true for dark mode, false for light mode
class ThemeCubit extends Cubit<bool> {
  static const String _themePrefKey = 'is_dark_mode';

  ThemeCubit() : super(false) {
    // Load the saved theme preference when the cubit is created
    _loadThemePreference();
  }

  /// Loads the saved theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDarkMode = prefs.getBool(_themePrefKey) ?? false;
      emit(isDarkMode);
    } catch (e) {
      // If there's an error, default to light mode
      emit(false);
    }
  }

  /// Toggles between light and dark themes
  Future<void> toggleTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final newThemeValue = !state;

      // Save the new theme preference
      await prefs.setBool(_themePrefKey, newThemeValue);

      // Emit the new state
      emit(newThemeValue);
    } catch (e) {
      // If there's an error, don't change the state
    }
  }

  /// Sets the theme explicitly to light or dark mode
  Future<void> setTheme(bool isDarkMode) async {
    try {
      if (state == isDarkMode) return; // No change needed

      final prefs = await SharedPreferences.getInstance();

      // Save the new theme preference
      await prefs.setBool(_themePrefKey, isDarkMode);

      // Emit the new state
      emit(isDarkMode);
    } catch (e) {
      // If there's an error, don't change the state
    }
  }
}
