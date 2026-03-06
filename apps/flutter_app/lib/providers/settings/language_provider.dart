import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/data/local/app_database.dart' as db;
import 'package:flutter_app/services/sync_service.dart';
import 'package:flutter_app/utils/debugger.dart';
import 'package:drift/drift.dart';

class LanguageNotifier extends AsyncNotifier<Locale> {
  static const _kLangKey = 'language_code';

  @override
  Future<Locale> build() async {
    // 1. Check SharedPreferences first (Fastest/Reliable for boot)
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_kLangKey);
    
    if (savedCode != null) {
      return Locale(savedCode);
    }

    // 2. If no SharedPreferences, try to peek at the SQLite User table
    final database = ref.read(db.databaseProvider);
    final localUser = await (database.select(database.users)..limit(1)).getSingleOrNull();
    
    if (localUser != null) {
      // Save it to prefs so next time it's even faster
      await prefs.setString(_kLangKey, localUser.language);
      return Locale(localUser.language);
    }

    // 3. Fallback to system default or English
    return const Locale('en');
  }

  Future<void> setLanguage(Locale newLanguage) async {
    // Update local state immediately for the UI
    state = AsyncData(newLanguage);

    try {
      // 1. Persist to SharedPreferences (for next app launch)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLangKey, newLanguage.languageCode);

      // 2. Persist to SQLite (for data integrity)
      final database = ref.read(db.databaseProvider);
      final localUser = await (database.select(database.users)..limit(1)).getSingleOrNull();

      if (localUser != null) {
        await (database.update(database.users)
          ..where((t) => t.id.equals(localUser.id)))
          .write(db.UsersCompanion(
            language: Value(newLanguage.languageCode),
          ));

        // 3. Trigger background sync to inform the NestJS server
        ref.read(syncServiceProvider.future).then((s) => s.runSync());
      }
    } catch (e) {
      Debugger.log('Failed to save language: $e');
    }
  }
}

final languageProvider = AsyncNotifierProvider<LanguageNotifier, Locale>(() {
  return LanguageNotifier();
});