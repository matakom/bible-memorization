import 'package:flutter/material.dart'; // For Locale
import 'package:flutter_app/data/repositories/user_repository.dart';
import 'package:flutter_app/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/debugger.dart';

class LanguageNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final asyncUser = ref.watch(userDataProvider);

    // Set the initial language based on the user data,
    // or return 'en' as a default if the user is loading or has an error.
    return asyncUser.when(
      data: (user) => Locale(user.language),
      loading: () => const Locale('en'),
      error: (e, st) => const Locale('en'),
    );
  }

  /// This method updates the state and persists it to the backend.
  Future<void> setLanguage(Locale newLanguage) async {
    if (state == newLanguage) return;

    state = newLanguage;

    try {
      final userRepository = await ref.read(userRepositoryProvider.future);
      // The repository expects a string code like 'en' or 'cs'
      await userRepository.setLocale(newLanguage.languageCode);
    } catch (e) {
      // TODO: Handle the error
      Debugger.log('Failed to save language: $e');
    }
  }
}

/// NotifierProvider for language.
final languageProvider = NotifierProvider<LanguageNotifier, Locale>(() {
  return LanguageNotifier();
});