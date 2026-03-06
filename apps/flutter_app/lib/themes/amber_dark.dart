import 'package:flutter/material.dart';
import 'package:flutter_app/themes/theme_constants.dart';

/// Defines the application's dark theme using Material 3 and a yellow seed color.
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
);