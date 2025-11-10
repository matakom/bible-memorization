import 'package:flutter/material.dart';
import 'package:flutter_app/data/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    return const Locale('en');
  }

  void initialize(Locale initialLocale) {
    state = initialLocale;
  }

  Future<void> setLocale(Locale newLocale) async {
    state = newLocale;
    final userRepository = await ref.read(userRepositoryProvider.future);
    await userRepository.setLocale(newLocale.toString());
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});

