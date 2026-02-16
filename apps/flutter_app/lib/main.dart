import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/presentation/themes/app_theme.dart';
import 'package:flutter_app/providers/app_settings_provider.dart';
import 'package:flutter_app/providers/core/router_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

const String environment = String.fromEnvironment('ENV', defaultValue: 'dev');

Future<void> main() async {
  // 1. Basic Flutter/Firebase setup (Fast)
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env.$environment");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // 2. Run App immediately. 
  // We do NOT initialize the DB here. The providers will handle it lazily.
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch providers for theme/locale/routing
    final router = ref.watch(goRouterProvider);
    final Locale currentLocale = ref.watch(languageProvider);
    final ThemeMode currentThemeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      routerConfig: router,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: currentThemeMode,
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