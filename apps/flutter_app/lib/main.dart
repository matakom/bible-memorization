import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/providers/settings/language_provider.dart';
import 'package:flutter_app/providers/core/router_provider.dart';
import 'package:flutter_app/providers/settings/theme_provider.dart';
import 'package:flutter_app/themes/amber_dark.dart';
import 'package:flutter_app/themes/amber_light.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

const String environment = String.fromEnvironment('ENV', defaultValue: 'dev');
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env.$environment");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final Locale currentLocale = ref.watch(languageProvider);
    final ThemeMode currentThemeMode = ref.watch(themeProvider);
    
    return MaterialApp.router(
      routerConfig: router,

      // Theme
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: currentThemeMode,

      // Localization
      locale: currentLocale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}