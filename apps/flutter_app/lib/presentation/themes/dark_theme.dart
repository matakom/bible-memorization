import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/design_system/app_dimens.dart';
import '../design_system/app_colors.dart';

ThemeData buildDarkTheme() {
  final base = ThemeData.dark(); // Start with standard Material dark

  return base.copyWith(
    useMaterial3: true,
    
    // 1. Colors
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppPalette.primary,
      brightness: Brightness.dark,
      surface: AppPalette.surfaceDark,
      onSurface: AppPalette.textPrimaryDark,
      error: AppPalette.error,
    ),
    scaffoldBackgroundColor: AppPalette.backgroundDark,

    // 2. AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.surfaceDark,
      foregroundColor: AppPalette.textPrimaryDark,
      elevation: 0,
      centerTitle: true,
    ),

    // 3. Cards
    cardTheme: base.cardTheme.copyWith(
      color: AppPalette.surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.m),
      ),
    ),

    // 4. Navigation
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppPalette.backgroundDark,
      indicatorColor: AppPalette.primary,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    ),
  );
}