import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false) {
    _loadTheme();
  }

  void toggleTheme() async {
    final newTheme = !state;
    emit(newTheme);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newTheme);
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    emit(prefs.getBool('isDarkMode') ?? false);
  }
}