import 'package:flutter/material.dart';

// 1. Spacing & Margins ("The Box Model")
class AppSpacings {
  static const double xs = 4.0;   // Tight grouping
  static const double s = 8.0;    // Standard padding inside cards
  static const double m = 16.0;   // Standard page margin
  static const double l = 24.0;   // Section separation
  static const double xl = 32.0;  // Large headers
  static const double xxl = 48.0; // Bottom sheet spacers
}

// 2. Borders & Radius
class AppRadius {
  static const double s = 8.0;    // Small buttons
  static const double m = 12.0;   // Standard Cards
  static const double l = 16.0;   // Bottom Sheets / Dialogs
  static const double full = 999.0; // Capsule buttons / Avatars
}

// 3. Typography Styles
// Use these in your Text() widgets or Theme definition
class AppTypography {
  static const TextStyle header = TextStyle(
    fontSize: 24, 
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );
  
  static const TextStyle subHeader = TextStyle(
    fontSize: 18, 
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16, 
    height: 1.5, // Better readability for Bible text
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12, 
    color: Colors.grey,
  );
}

// 4. Reusable Spacers (To avoid typing SizedBox repeatedly)
class Spacing {
  static const SizedBox verticalS = SizedBox(height: AppSpacings.s);
  static const SizedBox verticalM = SizedBox(height: AppSpacings.m);
  static const SizedBox verticalL = SizedBox(height: AppSpacings.l);
  
  static const SizedBox horizontalS = SizedBox(width: AppSpacings.s);
  static const SizedBox horizontalM = SizedBox(width: AppSpacings.m);
}