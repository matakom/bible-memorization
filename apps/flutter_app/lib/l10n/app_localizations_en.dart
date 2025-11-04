// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login_screenTitle => 'Login';

  @override
  String get login_signInButton => 'Sign in';

  @override
  String get login_errorOnSignIn => 'Sign-in failed';

  @override
  String get reader_navbar => 'Bible';

  @override
  String get stats_navbar => 'Stats';

  @override
  String get practice_navbar => 'Practice';

  @override
  String get social_navbar => 'Friends';

  @override
  String get settings_navbar => 'Settings';

  @override
  String get settings_screenTitle => 'Settings';

  @override
  String get settings_signOutButton => 'Sign out';

  @override
  String get settings_errorOnSignOut => 'Sign-out failed';

  @override
  String get settings_appsLanguage => 'App\'s language';
}
