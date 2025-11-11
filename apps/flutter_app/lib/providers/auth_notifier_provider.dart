import 'package:flutter/material.dart';
import 'package:flutter_app/data/repositories/user_repository.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/providers/locale_provider.dart';
import 'package:flutter_app/providers/settings_loading_provider.dart';
import 'package:flutter_app/providers/theme_provider.dart';
import 'package:flutter_app/providers/user_code_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/utils/debugger.dart';

class AuthNotifier extends Notifier<void> {
  @override
  void build() {
    // This provider is only for actions, so build() is empty.
    // It doesn't need to watch the auth stream because
    // your main.dart handles the initial load.
    return;
  }

  Future<void> _loadUserSettings() async {
    try {
      final userRepository = await ref.read(userRepositoryProvider.future);
      
      final [settings, code] = await Future.wait([
        userRepository.getUserSettings(),
        userRepository.getCode(),
      ]);

      Locale initLocale = _getLocaleFromSettings(settings as Map<String, dynamic>);
      ThemeMode initTheme = _getThemeModeFromSettings(settings);

      ref.read(localeProvider.notifier).initialize(initLocale);
      ref.read(themeProvider.notifier).initialize(initTheme);
      ref.read(userCodeProvider.notifier).initialize(code as String?);

    } catch (e) {
      Debugger.log('Failed to load user settings: $e');
    }
  }


  Future<void> signInWithGoogle() async {
    ref.read(settingsLoadingProvider.notifier).state = true;
    await ref.read(authRepositoryProvider).signInWithGoogle();
    await _loadUserSettings();
    ref.read(settingsLoadingProvider.notifier).state = false;
  }

  Future<void> signOut() async {
    _invalidateUserData();
    await ref.read(authRepositoryProvider).signOut();
  }

  void _invalidateUserData() {
    ref.invalidate(userRepositoryProvider);
    ref.invalidate(userCodeProvider);
  }

  ThemeMode _getThemeModeFromSettings(Map<String, dynamic> settings) {
    switch (settings['theme']) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        Debugger.log('Unknown theme setting: ${settings['theme']}');
        return ThemeMode.light; // default
    }
  }

  Locale _getLocaleFromSettings(Map<String, dynamic> settings) {
    final languageCode = settings['language'] ?? 'en';
    if (settings['language'] == null) {
      Debugger.log('Loaded default language setting: $languageCode');
    }
    return Locale(languageCode);
  }
}

/// Provider to expose the [AuthNotifier]
final authNotifierProvider = NotifierProvider<AuthNotifier, void>(() {
  return AuthNotifier();
});

