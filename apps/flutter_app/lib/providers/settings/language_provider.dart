import 'package:flutter/material.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/data/local/app_database.dart' as db;
import 'package:flutter_app/services/sync_service.dart';
import 'package:flutter_app/utils/debugger.dart';

class LanguageNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final asyncUser = ref.watch(userDataProvider);

    // Set the initial language based on the user data,
    // or return 'en' as a default if the user is loading or has an error.
    return asyncUser.when(
      data: (user) => Locale(user?.language ?? 'en'),
      loading: () => const Locale('en'),
      error: (e, st) => const Locale('en'),
    );
  }

  /// This method updates the state and persists it to the backend.
  Future<void> setLanguage(Locale newLanguage) async {
    if (state == newLanguage) return;

    state = newLanguage;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', newLanguage.languageCode);
      final database = ref.read(db.databaseProvider);
      
      final localUser = await (database.select(database.users)).getSingleOrNull();

      if (localUser != null) {
        await database.updateUserLanguage(localUser.id, newLanguage.languageCode);

        ref.read(syncServiceProvider.future).then((s) => s.runSync());
      } else {
        Debugger.log("No local user found. Data will sync on next login.");
      }
    } catch (e) {
      Debugger.log('Failed to save language: $e');
    }
  }
}

/// NotifierProvider for language.
final languageProvider = NotifierProvider<LanguageNotifier, Locale>(() {
  return LanguageNotifier();
});