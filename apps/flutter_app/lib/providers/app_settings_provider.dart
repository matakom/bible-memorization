import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart' as drift;

import '../data/local/app_database.dart'; // Your DB import

// -----------------------------------------------------------------------------
// 1. THEME PROVIDER (Local - Shared Preferences)
// -----------------------------------------------------------------------------

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

class ThemeNotifier extends Notifier<ThemeMode> {
  static const _prefsKey = 'theme_mode';

  @override
  ThemeMode build() {
    // 1. Load the saved theme asynchronously
    _loadTheme();
    // 2. Return a default immediately (prevents UI flicker/loading state)
    return ThemeMode.system;
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    
    if (saved != null) {
      state = _parseThemeMode(saved);
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode; // Update UI immediately
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, mode.name); // Saves 'light', 'dark', or 'system'
  }

  ThemeMode _parseThemeMode(String value) {
    return ThemeMode.values.firstWhere(
      (e) => e.name == value, 
      orElse: () => ThemeMode.system
    );
  }
}

// -----------------------------------------------------------------------------
// 2. LANGUAGE PROVIDER (Database Backed)
// -----------------------------------------------------------------------------

final languageProvider = NotifierProvider<LanguageNotifier, Locale>(LanguageNotifier.new);

class LanguageNotifier extends Notifier<Locale> {
  
  @override
  Locale build() {
    // Default to English initially
    return const Locale('en');
  }

  /// Called after Login to sync the app with the User's DB preference
  Future<void> loadUserLanguage(String userId) async {
    final db = ref.read(databaseProvider);
    
    // Fetch user from DB
    final user = await (db.select(db.users)..where((u) => u.id.equals(userId))).getSingleOrNull();
    
    if (user != null) {
      // Assuming your DB column is 'language' (varchar) like 'en', 'cs'
      state = Locale(user.language); 
    }
  }

  /// Updates the language in State AND Database
  Future<void> setLanguage(Locale locale, {String? userId}) async {
    // 1. Update UI state immediately
    state = locale;

    // 2. Update DB if we have a logged-in user
    if (userId != null) {
      final db = ref.read(databaseProvider);
      
      await (db.update(db.users)..where((u) => u.id.equals(userId))).write(
        UsersCompanion(
          language: drift.Value(locale.languageCode),
        ),
      );
    }
  }
}