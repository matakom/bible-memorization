// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get login_screenTitle => 'Přihlášení';

  @override
  String get login_signInButton => 'Přihlásit se';

  @override
  String get login_errorOnSignIn => 'Přihlášení se nezdařilo';

  @override
  String get reader_navbar => 'Bible';

  @override
  String get stats_navbar => 'Statistiky';

  @override
  String get practice_navbar => 'Trénink';

  @override
  String get social_navbar => 'Přátelé';

  @override
  String get settings_navbar => 'Nastavení';

  @override
  String get settings_screenTitle => 'Nastavení';

  @override
  String get settings_signOutButton => 'Odhlásit se';

  @override
  String get settings_errorOnSignOut => 'Odhlášení se nezdařilo';

  @override
  String get settings_appsLanguage => 'Jazyk aplikace';

  @override
  String get settings_theme_light => 'Světlý';

  @override
  String get settings_theme_dark => 'Tmavý';

  @override
  String get settings_theme_system => 'Systém';

  @override
  String get settings_token_button => 'Vypiš token';
}
