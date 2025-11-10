import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/providers/locale_provider.dart';
import 'package:flutter_app/providers/router_provider.dart';
import 'package:flutter_app/providers/theme_provider.dart';
import 'package:flutter_app/themes/amber_dark.dart';
import 'package:flutter_app/themes/amber_light.dart';
import 'package:flutter_app/utils/debugger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/repositories/user_repository.dart';
import 'firebase_options.dart';

const String environment = String.fromEnvironment('ENV', defaultValue: 'dev');
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env.$environment");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Create a ProviderContainer to manage state before initializing the app
  final container = ProviderContainer();
  final user = container.read(firebaseAuthProvider).currentUser;

  if (user != null) {
    await loadUserSettings(container);
  }

  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final Locale currentLocale = ref.watch(localeProvider);
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

Future<void> loadUserSettings(ProviderContainer container) async {
  try {
    final userRepository = await container.read(userRepositoryProvider.future);

    final settings = await userRepository.getUserSettings();

    Locale initLocale = getLocaleFromSettings(settings);
    ThemeMode initTheme = getThemeModeFromSettings(settings);

    container.read(localeProvider.notifier).initialize(initLocale);
    container.read(themeProvider.notifier).initialize(initTheme);
  } catch (e) {
    Debugger.log('Failed to load user settings: $e');
  }
}

// Helper to get ThemeMode from settings
ThemeMode getThemeModeFromSettings(Map<String, dynamic> settings) {
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

// Helper to get Locale from settings
Locale getLocaleFromSettings(Map<String, dynamic> settings) {
  final languageCode = settings['language'] ?? 'en';
  if (settings['language'] == null) {
    Debugger.log('Loaded default language setting: $languageCode');
  }
  return Locale(languageCode);
}
