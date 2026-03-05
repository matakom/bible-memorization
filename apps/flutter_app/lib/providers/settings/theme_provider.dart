import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends AsyncNotifier<ThemeMode> {
  static const _kThemePrefKey = 'selected_theme_mode';

  @override
  Future<ThemeMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_kThemePrefKey);

    // Map the string back to the Enum, defaulting to system
    switch (savedTheme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setTheme(ThemeMode newTheme) async {
    // 1. Update UI immediately (Optimistic)
    state = AsyncData(newTheme);

    // 2. Save to disk
    final prefs = await SharedPreferences.getInstance();
    String themeString;
    switch (newTheme) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      case ThemeMode.system:
        themeString = 'system';
        break;
    }
    await prefs.setString(_kThemePrefKey, themeString);
  }
}

final themeProvider = AsyncNotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});