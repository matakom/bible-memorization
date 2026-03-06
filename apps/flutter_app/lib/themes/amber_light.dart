import 'package:flutter/material.dart';
import 'package:flutter_app/themes/theme_constants.dart';

/// Defines the application's light theme using Material 3 and a yellow seed color.
final lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
);