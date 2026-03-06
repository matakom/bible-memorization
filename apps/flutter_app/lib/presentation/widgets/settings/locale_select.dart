import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/providers/settings/language_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class LocaleSelect extends ConsumerWidget {
  const LocaleSelect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the AsyncValue
    final asyncLocale = ref.watch(languageProvider);

    // 2. Unwrap the AsyncValue to get the current Locale
    return asyncLocale.maybeWhen(
      data: (currentLocale) => DropdownButton<Locale>(
        value: currentLocale,
        isExpanded: true,
        onChanged: (Locale? newLocale) {
          if (newLocale != null) {
            ref.read(languageProvider.notifier).setLanguage(newLocale);
          }
        },
        items: AppLocalizations.supportedLocales.map((locale) {
          final String languageName =
              (locale.languageCode == 'en') ? 'English' : 'Čeština';

          return DropdownMenuItem<Locale>(
            value: locale,
            child: Center(child: Text(languageName)),
          );
        }).toList(),
      ),
      // Fallback while loading from SharedPreferences
      orElse: () => const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}