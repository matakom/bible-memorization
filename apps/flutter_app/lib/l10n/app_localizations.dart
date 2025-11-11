import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('en'),
  ];

  /// No description provided for @common_comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon!'**
  String get common_comingSoon;

  /// No description provided for @login_screenTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_screenTitle;

  /// No description provided for @login_signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get login_signInButton;

  /// No description provided for @login_errorOnSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed'**
  String get login_errorOnSignIn;

  /// No description provided for @reader_navbar.
  ///
  /// In en, this message translates to:
  /// **'Bible'**
  String get reader_navbar;

  /// No description provided for @stats_navbar.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats_navbar;

  /// No description provided for @practice_navbar.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practice_navbar;

  /// No description provided for @social_navbar.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get social_navbar;

  /// No description provided for @settings_navbar.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_navbar;

  /// No description provided for @settings_screenTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_screenTitle;

  /// No description provided for @settings_signOutButton.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settings_signOutButton;

  /// No description provided for @settings_errorOnSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign-out failed'**
  String get settings_errorOnSignOut;

  /// No description provided for @settings_appsLanguage.
  ///
  /// In en, this message translates to:
  /// **'App\'s language'**
  String get settings_appsLanguage;

  /// No description provided for @settings_themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settings_themeLight;

  /// No description provided for @settings_themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settings_themeDark;

  /// No description provided for @settings_themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settings_themeSystem;

  /// No description provided for @settings_tokenButton.
  ///
  /// In en, this message translates to:
  /// **'Print token'**
  String get settings_tokenButton;

  /// No description provided for @social_screenTitle.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get social_screenTitle;

  /// No description provided for @social_addFriend.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get social_addFriend;

  /// No description provided for @social_sendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get social_sendRequest;

  /// No description provided for @social_yourCode.
  ///
  /// In en, this message translates to:
  /// **'Your code'**
  String get social_yourCode;

  /// No description provided for @social_codeFetchError.
  ///
  /// In en, this message translates to:
  /// **'Error fetching code'**
  String get social_codeFetchError;

  /// No description provided for @social_nothingHere.
  ///
  /// In en, this message translates to:
  /// **'Nothing here...'**
  String get social_nothingHere;

  /// No description provided for @social_nothingToSeeHereYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing to see here yet. Start by adding some friends!'**
  String get social_nothingToSeeHereYet;

  /// No description provided for @social_friendRequest.
  ///
  /// In en, this message translates to:
  /// **'Friend request'**
  String get social_friendRequest;

  /// No description provided for @social_friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get social_friends;

  /// No description provided for @social_sentRequests.
  ///
  /// In en, this message translates to:
  /// **'Sent requests'**
  String get social_sentRequests;

  /// No description provided for @social_rejectedByMe.
  ///
  /// In en, this message translates to:
  /// **'Rejected by me'**
  String get social_rejectedByMe;

  /// No description provided for @social_rejectedByThem.
  ///
  /// In en, this message translates to:
  /// **'Rejected by them'**
  String get social_rejectedByThem;

  /// No description provided for @friendsStats_screenTitle.
  ///
  /// In en, this message translates to:
  /// **'Friend Stats'**
  String get friendsStats_screenTitle;

  /// No description provided for @friendsStats_future.
  ///
  /// In en, this message translates to:
  /// **'This is where the stats will be displayed.'**
  String get friendsStats_future;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['cs', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
