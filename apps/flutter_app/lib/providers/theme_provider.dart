import 'package:flutter/material.dart';
import 'package:flutter_app/data/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.system; 
  }

  void initialize(ThemeMode initialTheme) {
    state = initialTheme;
  }

  Future<void> setTheme(ThemeMode newTheme) async {
    state = newTheme;
    final userRepository = await ref.read(userRepositoryProvider.future);
    await userRepository.setTheme(newTheme.name);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});