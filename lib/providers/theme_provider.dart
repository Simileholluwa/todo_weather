import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier({required ThemeMode mode}) : super(mode);

  void toggle() async {
    final prefs = await SharedPreferences.getInstance();
    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
      await prefs.setString('theme_mode', 'light');
    } else {
      state = ThemeMode.dark;
      await prefs.setString('theme_mode', 'dark');
    }
  }
}
