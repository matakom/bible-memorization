import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/providers/settings/language_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

/// Dropdown selector for switching the application language, managed by the languageProvider.
class LocaleSelect extends ConsumerWidget {
  const LocaleSelect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLocale = ref.watch(languageProvider);

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
          final String languageName = (locale.languageCode == 'en') ? 'English' : 'Čeština';
          return DropdownMenuItem<Locale>(
            value: locale,
            child: Center(child: Text(languageName)),
          );
        }).toList(),
      ),
      orElse: () => const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}