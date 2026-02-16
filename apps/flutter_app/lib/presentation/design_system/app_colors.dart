import 'package:flutter/material.dart';

class AppPalette {
  // 1. Primary Brand (Amber)
  static const Color primary = Color(0xFFFFC107);
  static const Color primaryVariant = Color(0xFFFFA000);
  static const Color secondary = Color(0xFF2196F3); // Blue accent for links/info

  // 2. Semantic Colors (Status Indicators)
  static const Color error = Color(0xFFD32F2F);   // Red for deletions/errors
  static const Color success = Color(0xFF388E3C); // Green for "Mastered"
  static const Color warning = Color(0xFFF57C00); // Orange for "Due Soon"

  // 3. Neutrals (Light Mode)
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color backgroundLight = Color(0xFFF9F9F9); // Slightly off-white
  static const Color surfaceLight = Color(0xFFFFFFFF);    // Pure white cards

  // 4. Neutrals (Dark Mode)
  static const Color textPrimaryDark = Color(0xFFEEEEEE);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color backgroundDark = Color(0xFF121212);  // Deep dark gray
  static const Color surfaceDark = Color(0xFF1E1E1E);     // Slightly lighter for cards
}