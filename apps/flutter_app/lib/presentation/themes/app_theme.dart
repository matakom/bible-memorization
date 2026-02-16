import 'package:flutter/material.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

class AppTheme {
  // Static getters prevent recompiling the theme on every rebuild
  static final ThemeData light = buildLightTheme();
  static final ThemeData dark = buildDarkTheme();
}