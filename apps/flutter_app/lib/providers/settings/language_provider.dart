import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/data/local/app_database.dart' as db;
import 'package:flutter_app/services/sync_service.dart';
import 'package:drift/drift.dart';

/// Manages application locale, persisting choices to both SharedPreferences and the local database.
class LanguageNotifier extends AsyncNotifier<Locale> {
  static const _kLangKey = 'language_code';

  @override
  Future<Locale> build() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_kLangKey);
    if (savedCode != null) return Locale(savedCode);

    final database = ref.read(db.databaseProvider);
    final localUser = await (database.select(database.users)..limit(1)).getSingleOrNull();
    
    if (localUser != null) {
      await prefs.setString(_kLangKey, localUser.language);
      return Locale(localUser.language);
    }
    return const Locale('cs');
  }

  Future<void> setLanguage(Locale newLanguage) async {
    state = AsyncData(newLanguage);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLangKey, newLanguage.languageCode);

      final database = ref.read(db.databaseProvider);
      final localUser = await (database.select(database.users)..limit(1)).getSingleOrNull();

      if (localUser != null) {
        await (database.update(database.users)..where((t) => t.id.equals(localUser.id)))
          .write(db.UsersCompanion(language: Value(newLanguage.languageCode)));
        ref.read(syncServiceProvider.future).then((s) => s.runSync());
      }
    } catch (_) {}
  }
}

final languageProvider = AsyncNotifierProvider<LanguageNotifier, Locale>(LanguageNotifier.new);