import 'package:flutter/material.dart';
import 'package:flutter_app/themes/theme_constants.dart';


final lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
);