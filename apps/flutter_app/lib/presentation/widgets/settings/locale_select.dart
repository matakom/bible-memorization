// import 'package:flutter_app/l10n/app_localizations.dart';
// import 'package:flutter_app/providers/settings/language_provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter/material.dart';

// class LocaleSelect extends ConsumerWidget {
//   const LocaleSelect({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final Locale currentLocale = ref.watch(languageProvider);

//     return DropdownButton<Locale>(
//       value: currentLocale, 
      
//       onChanged: (Locale? newLocale) {
//         if (newLocale != null) {
//           ref.read(languageProvider.notifier).setLanguage(newLocale); 
//         }
//       },
      
//       items: AppLocalizations.supportedLocales.map((locale) { 
//         final String languageName = (locale.languageCode == 'en') 
//             ? 'English' 
//             : 'Čeština'; 
            
//         return DropdownMenuItem<Locale>(
//           value: locale,
//           child: Text(languageName),
//         );
//       }).toList(),
//     );
//   }
// }