import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/design_system/app_dimens.dart';
import '../design_system/app_colors.dart';

ThemeData buildLightTheme() {
  final base = ThemeData.light(); // Start with standard Material light

  return base.copyWith(
    useMaterial3: true,
    
    // 1. Colors
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppPalette.primary,
      brightness: Brightness.light,
      surface: AppPalette.surfaceLight,
      onSurface: AppPalette.textPrimaryLight,
      error: AppPalette.error,
    ),
    scaffoldBackgroundColor: AppPalette.backgroundLight,

    // 2. AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.surfaceLight,
      foregroundColor: AppPalette.textPrimaryLight,
      elevation: 0,
      centerTitle: true,
    ),

    // 3. Cards
    // Using copyWith ensures we don't miss default properties
    cardTheme: base.cardTheme.copyWith(
      color: AppPalette.surfaceLight,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.m),
      ),
    ),

    // 4. Navigation
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppPalette.surfaceLight,
      indicatorColor: AppPalette.primary.withOpacity(0.5),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    ),
  );
}