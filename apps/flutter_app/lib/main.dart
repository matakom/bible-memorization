import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/local/app_database.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/providers/settings/language_provider.dart';
import 'package:flutter_app/providers/core/router_provider.dart';
import 'package:flutter_app/providers/settings/theme_provider.dart';
import 'package:flutter_app/services/notification_service.dart';
import 'package:flutter_app/services/sync_service.dart';
import 'package:flutter_app/themes/amber_dark.dart';
import 'package:flutter_app/themes/amber_light.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

const String environment = String.fromEnvironment('ENV', defaultValue: 'dev');

/// Initializes core services, Firebase, notifications, and runs the Flutter application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env.$environment");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.init();
  await NotificationService.requestPermissions();
  
  final database = AppDatabase();
  final startOfDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final todayPractices = await (database.select(database.exercises)
            ..where((e) => e.performedAt.isBiggerOrEqualValue(startOfDay))
            ..limit(1)).get();
            
  await NotificationService.scheduleDailyReminder(todayPractices.isNotEmpty);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    _initialSync();
  }

  Future<void> _initialSync() async {
    await Future.delayed(Duration.zero);
    try {
      final syncService = await ref.read(syncServiceProvider.future);
      syncService.runSync();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: ref.watch(goRouterProvider),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ref.watch(themeProvider).maybeWhen(data: (mode) => mode, orElse: () => ThemeMode.light),
      locale: ref.watch(languageProvider).maybeWhen(data: (locale) => locale, orElse: () => const Locale('cs')),
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