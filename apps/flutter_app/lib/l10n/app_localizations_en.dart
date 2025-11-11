// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get common_comingSoon => 'Coming soon!';

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

  @override
  String get settings_themeLight => 'Light';

  @override
  String get settings_themeDark => 'Dark';

  @override
  String get settings_themeSystem => 'System default';

  @override
  String get settings_tokenButton => 'Print token';

  @override
  String get social_screenTitle => 'Friends';

  @override
  String get social_addFriend => 'Add Friend';

  @override
  String get social_sendRequest => 'Send Request';

  @override
  String get social_yourCode => 'Your code';

  @override
  String get social_codeFetchError => 'Error fetching code';

  @override
  String get social_nothingHere => 'Nothing here...';

  @override
  String get social_nothingToSeeHereYet =>
      'Nothing to see here yet. Start by adding some friends!';

  @override
  String get social_friendRequest => 'Friend request';

  @override
  String get social_friends => 'Friends';

  @override
  String get social_sentRequests => 'Sent requests';

  @override
  String get social_rejectedByMe => 'Rejected by me';

  @override
  String get social_rejectedByThem => 'Rejected by them';

  @override
  String get friendsStats_screenTitle => 'Friend Stats';

  @override
  String get friendsStats_future =>
      'This is where the stats will be displayed.';
}
