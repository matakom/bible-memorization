import 'package:drift/drift.dart' as drift;
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
import 'utils/debugger.dart';

const String environment = String.fromEnvironment('ENV', defaultValue: 'dev');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env.$environment");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.init();
  await NotificationService.requestPermissions();
  final database = AppDatabase();
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final todayPractices =
      await (database.select(database.exercises)
            ..where((e) => e.performedAt.isBiggerOrEqualValue(startOfDay))
            ..limit(1))
          .get();
  final hasPracticedToday = todayPractices.isNotEmpty;
  await NotificationService.scheduleDailyReminder(hasPracticedToday);

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
    } catch (e) {
      Debugger.log("Initial sync skipped: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    // 1. Watch the AsyncValue
    final themeAsync = ref.watch(themeProvider);

    return MaterialApp.router(
      routerConfig: router,
      theme: lightTheme,
      darkTheme: darkTheme,
      // 2. Safely extract the data
      themeMode: themeAsync.maybeWhen(
        data: (mode) => mode,
        orElse: () => ThemeMode.light,
      ),
      locale: ref
          .watch(languageProvider)
          .maybeWhen(
            data: (locale) => locale,
            orElse: () => const Locale('cz'),
          ),
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
