import 'package:flutter/material.dart';
import 'package:flutter_app/data/repositories/user_repository.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/debugger.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final asyncUser = ref.watch(userDataProvider);

    return asyncUser.when(
      data: (user) => _getThemeModeFromSettings(user.theme),
      loading: () => ThemeMode.light, // Default while loading
      error: (e, st) => ThemeMode.light, // Default on error
    );
  }

  /// This method updates the state and persists it to the backend.
  Future<void> setTheme(ThemeMode newTheme) async {
    if (state == newTheme) return;

    state = newTheme;

    try {
      final userRepository = await ref.read(userRepositoryProvider.future);
      await userRepository.setTheme(newTheme.name);
    } catch (e) {
      // TODO: Handle the error
      Debugger.log('Failed to save theme: $e');
    }
  }
  
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});

ThemeMode _getThemeModeFromSettings(String theme) {
  switch (theme) {
    case 'dark':
      return ThemeMode.dark;
    case 'light':
      return ThemeMode.light;
    default:
      return ThemeMode.system;
  }
}