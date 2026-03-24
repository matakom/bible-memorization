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

  /// No description provided for @social_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get social_pending;

  /// No description provided for @social_accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get social_accept;

  /// No description provided for @social_unfriendTitle.
  ///
  /// In en, this message translates to:
  /// **'Unfriend?'**
  String get social_unfriendTitle;

  /// No description provided for @social_unfriendBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this friend?'**
  String get social_unfriendBody;

  /// No description provided for @social_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get social_cancel;

  /// No description provided for @social_remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get social_remove;

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

  /// No description provided for @reader_screenTitle.
  ///
  /// In en, this message translates to:
  /// **'Bible'**
  String get reader_screenTitle;

  /// No description provided for @reader_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading Scripture...'**
  String get reader_loading;

  /// No description provided for @reader_error.
  ///
  /// In en, this message translates to:
  /// **'Could not load text'**
  String get reader_error;

  /// No description provided for @reader_bookSelector.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get reader_bookSelector;

  /// No description provided for @reader_chapterSelector.
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get reader_chapterSelector;

  /// No description provided for @reader_saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save {count} Verses'**
  String reader_saveButton(int count);

  /// No description provided for @reader_saveDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Save to Memory'**
  String get reader_saveDialogTitle;

  /// No description provided for @reader_saveDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Do you want to add these verses to your daily practice?'**
  String get reader_saveDialogBody;

  /// No description provided for @reader_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get reader_cancel;

  /// No description provided for @reader_confirm.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get reader_confirm;

  /// No description provided for @reader_savedVerses.
  ///
  /// In en, this message translates to:
  /// **'Saved {count} Verses'**
  String reader_savedVerses(int count);

  /// No description provided for @reader_savedVersesTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved verses'**
  String get reader_savedVersesTitle;

  /// No description provided for @reader_retrySavedVersesFetch.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get reader_retrySavedVersesFetch;

  /// No description provided for @reader_errorLoadingSavedVerses.
  ///
  /// In en, this message translates to:
  /// **'Error loading saved verses: '**
  String get reader_errorLoadingSavedVerses;

  /// No description provided for @reader_noSavedVersesYet.
  ///
  /// In en, this message translates to:
  /// **'No verses saved in this translation yet.\nGo to the Bible to add some!'**
  String get reader_noSavedVersesYet;

  /// No description provided for @practice_title.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practice_title;

  /// No description provided for @practice_completedForToday.
  ///
  /// In en, this message translates to:
  /// **'All done today!'**
  String get practice_completedForToday;

  /// No description provided for @practice_modes.
  ///
  /// In en, this message translates to:
  /// **'Study modes'**
  String get practice_modes;

  /// No description provided for @practice_flashcards.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get practice_flashcards;

  /// No description provided for @practice_flashcardsDescription.
  ///
  /// In en, this message translates to:
  /// **'Classic flip cards'**
  String get practice_flashcardsDescription;

  /// No description provided for @practice_noVerses.
  ///
  /// In en, this message translates to:
  /// **'No verses available to practice.'**
  String get practice_noVerses;

  /// No description provided for @practice_readeToReview.
  ///
  /// In en, this message translates to:
  /// **'Ready to review'**
  String get practice_readeToReview;

  /// No description provided for @practice_error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String practice_error(String error);

  /// No description provided for @practice_allVersesReviewed.
  ///
  /// In en, this message translates to:
  /// **'You have reviewed all {totalCount} verses.'**
  String practice_allVersesReviewed(int totalCount);

  /// No description provided for @practice_versesScheduled.
  ///
  /// In en, this message translates to:
  /// **'You have {dueCount} verses scheduled for today.'**
  String practice_versesScheduled(int dueCount);

  /// No description provided for @practice_practiceAnyway.
  ///
  /// In en, this message translates to:
  /// **'Practice Anyway'**
  String get practice_practiceAnyway;

  /// No description provided for @practice_startSession.
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get practice_startSession;

  /// No description provided for @practiceShell_sessionComplete.
  ///
  /// In en, this message translates to:
  /// **'Session Complete!'**
  String get practiceShell_sessionComplete;

  /// No description provided for @practiceShell_versesMastered.
  ///
  /// In en, this message translates to:
  /// **'Verses mastered today: {count}'**
  String practiceShell_versesMastered(int count);

  /// No description provided for @practiceShell_finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get practiceShell_finish;

  /// No description provided for @practiceShell_remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining: {count}'**
  String practiceShell_remaining(int count);

  /// No description provided for @reader_appearanceTooltip.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get reader_appearanceTooltip;

  /// No description provided for @reader_errorSavingVerses.
  ///
  /// In en, this message translates to:
  /// **'Error saving verses: {error}'**
  String reader_errorSavingVerses(String error);

  /// No description provided for @savedVerses_currentTranslation.
  ///
  /// In en, this message translates to:
  /// **'Current Translation: {abbreviation}'**
  String savedVerses_currentTranslation(String abbreviation);

  /// No description provided for @savedVerses_verseDeleted.
  ///
  /// In en, this message translates to:
  /// **'Verse deleted'**
  String get savedVerses_verseDeleted;

  /// No description provided for @savedVerses_bookFallback.
  ///
  /// In en, this message translates to:
  /// **'Book {book} {chapter}:{verse}'**
  String savedVerses_bookFallback(int book, int chapter, int verse);

  /// No description provided for @savedVerses_difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get savedVerses_difficultyEasy;

  /// No description provided for @savedVerses_difficultyNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get savedVerses_difficultyNormal;

  /// No description provided for @savedVerses_difficultyModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get savedVerses_difficultyModerate;

  /// No description provided for @savedVerses_difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get savedVerses_difficultyHard;

  /// No description provided for @savedVerses_difficultyElite.
  ///
  /// In en, this message translates to:
  /// **'Elite'**
  String get savedVerses_difficultyElite;

  /// No description provided for @settings_debugTools.
  ///
  /// In en, this message translates to:
  /// **'Debug Tools'**
  String get settings_debugTools;

  /// No description provided for @settings_debugDb.
  ///
  /// In en, this message translates to:
  /// **'Debug DB'**
  String get settings_debugDb;

  /// No description provided for @settings_testNotification.
  ///
  /// In en, this message translates to:
  /// **'Test 5s Notification'**
  String get settings_testNotification;

  /// No description provided for @settings_notificationScheduled.
  ///
  /// In en, this message translates to:
  /// **'Notification scheduled for 5 seconds from now!'**
  String get settings_notificationScheduled;

  /// No description provided for @settings_forceSync.
  ///
  /// In en, this message translates to:
  /// **'Force Sync Now'**
  String get settings_forceSync;

  /// No description provided for @settings_forceSyncDescription.
  ///
  /// In en, this message translates to:
  /// **'Push/Pull data manually'**
  String get settings_forceSyncDescription;

  /// No description provided for @settings_syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get settings_syncing;

  /// No description provided for @settings_syncSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sync Success!'**
  String get settings_syncSuccess;

  /// No description provided for @settings_syncError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String settings_syncError(String error);

  /// No description provided for @settings_errorLoadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error loading profile: {error}'**
  String settings_errorLoadingProfile(String error);

  /// No description provided for @settings_guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get settings_guestUser;

  /// No description provided for @settings_guestProgressSavedLocally.
  ///
  /// In en, this message translates to:
  /// **'Progress saved locally'**
  String get settings_guestProgressSavedLocally;

  /// No description provided for @social_errorLoadingUser.
  ///
  /// In en, this message translates to:
  /// **'Error loading user: {error}'**
  String social_errorLoadingUser(String error);

  /// No description provided for @social_unavailableOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'Social features unavailable offline'**
  String get social_unavailableOfflineTitle;

  /// No description provided for @social_unavailableOfflineDescription.
  ///
  /// In en, this message translates to:
  /// **'Please connect to the internet and restart the app to sync your friend code.'**
  String get social_unavailableOfflineDescription;

  /// No description provided for @social_errorLoadingFriendships.
  ///
  /// In en, this message translates to:
  /// **'Error loading friendships: {error}'**
  String social_errorLoadingFriendships(String error);

  /// No description provided for @social_guestTitle.
  ///
  /// In en, this message translates to:
  /// **'Memorize Together'**
  String get social_guestTitle;

  /// No description provided for @social_guestDescription.
  ///
  /// In en, this message translates to:
  /// **'Log in to connect with friends, share your progress, and motivate each other to keep learning.'**
  String get social_guestDescription;

  /// No description provided for @stats_screenTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get stats_screenTitle;

  /// No description provided for @stats_errorLoadingStats.
  ///
  /// In en, this message translates to:
  /// **'Error loading stats: {error}'**
  String stats_errorLoadingStats(String error);

  /// No description provided for @game_firstLetter_hardMode.
  ///
  /// In en, this message translates to:
  /// **'Hard Mode'**
  String get game_firstLetter_hardMode;

  /// No description provided for @game_firstLetter_easyMode.
  ///
  /// In en, this message translates to:
  /// **'Easy Mode'**
  String get game_firstLetter_easyMode;

  /// No description provided for @game_firstLetter_mistakes.
  ///
  /// In en, this message translates to:
  /// **'Mistakes: {count}'**
  String game_firstLetter_mistakes(int count);

  /// No description provided for @game_firstLetter_hintText.
  ///
  /// In en, this message translates to:
  /// **'Type first letter...'**
  String get game_firstLetter_hintText;

  /// No description provided for @game_firstLetter_revealTooltip.
  ///
  /// In en, this message translates to:
  /// **'Reveal Next Word'**
  String get game_firstLetter_revealTooltip;

  /// No description provided for @game_flashcard_markedForReview.
  ///
  /// In en, this message translates to:
  /// **'Marked for review. You\'ll see this again soon!'**
  String get game_flashcard_markedForReview;

  /// No description provided for @game_flashcard_rateRecall.
  ///
  /// In en, this message translates to:
  /// **'Rate your recall:'**
  String get game_flashcard_rateRecall;

  /// No description provided for @game_flashcard_tapToShow.
  ///
  /// In en, this message translates to:
  /// **'Tap card to show answer'**
  String get game_flashcard_tapToShow;

  /// No description provided for @game_flashcard_errorBookName.
  ///
  /// In en, this message translates to:
  /// **'There was an error!'**
  String get game_flashcard_errorBookName;

  /// No description provided for @game_flashcard_errorLoadText.
  ///
  /// In en, this message translates to:
  /// **'Could not load text'**
  String get game_flashcard_errorLoadText;

  /// No description provided for @game_reference_prompt.
  ///
  /// In en, this message translates to:
  /// **'Where is this verse found?'**
  String get game_reference_prompt;

  /// No description provided for @game_reference_incorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect reference. Let\'s study this one again!'**
  String get game_reference_incorrect;

  /// No description provided for @game_reference_bookFallback.
  ///
  /// In en, this message translates to:
  /// **'Book {book}'**
  String game_reference_bookFallback(int book);

  /// No description provided for @game_builder_prompt.
  ///
  /// In en, this message translates to:
  /// **'Build the verse:'**
  String get game_builder_prompt;

  /// No description provided for @game_builder_incorrect.
  ///
  /// In en, this message translates to:
  /// **'Not quite! Try a different word.'**
  String get game_builder_incorrect;

  /// No description provided for @game_wordChoice_prompt.
  ///
  /// In en, this message translates to:
  /// **'Complete the verse ({current} / {total}):'**
  String game_wordChoice_prompt(int current, int total);

  /// No description provided for @game_wordChoice_incorrect.
  ///
  /// In en, this message translates to:
  /// **'Oops! The correct word was \'{word}\''**
  String game_wordChoice_incorrect(String word);

  /// No description provided for @game_wordChoice_errorFallback1.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get game_wordChoice_errorFallback1;

  /// No description provided for @game_wordChoice_errorFallback2.
  ///
  /// In en, this message translates to:
  /// **'loading'**
  String get game_wordChoice_errorFallback2;

  /// No description provided for @game_wordChoice_errorFallback3.
  ///
  /// In en, this message translates to:
  /// **'verse'**
  String get game_wordChoice_errorFallback3;

  /// No description provided for @reader_appearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get reader_appearanceTitle;

  /// No description provided for @reader_appearanceSansSerif.
  ///
  /// In en, this message translates to:
  /// **'Sans-Serif'**
  String get reader_appearanceSansSerif;

  /// No description provided for @reader_appearanceSerif.
  ///
  /// In en, this message translates to:
  /// **'Serif'**
  String get reader_appearanceSerif;

  /// No description provided for @reader_appearanceSpacing.
  ///
  /// In en, this message translates to:
  /// **'Spacing'**
  String get reader_appearanceSpacing;

  /// No description provided for @settings_deleteAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settings_deleteAccountButton;

  /// No description provided for @settings_deleteAccountDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete All Data'**
  String get settings_deleteAccountDialogTitle;

  /// No description provided for @settings_deleteAccountDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to wipe all your data? This will permanently remove all your saved verses, statistics, and friendships. You will start completely fresh.'**
  String get settings_deleteAccountDialogBody;

  /// No description provided for @settings_deleteAccountCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settings_deleteAccountCancel;

  /// No description provided for @settings_deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get settings_deleteAccountConfirm;

  /// No description provided for @settings_deleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'All data deleted. Starting fresh!'**
  String get settings_deleteAccountSuccess;

  /// No description provided for @settings_deleteAccountError.
  ///
  /// In en, this message translates to:
  /// **'Error deleting data: {error}'**
  String settings_deleteAccountError(String error);

  /// No description provided for @leaderboard_title.
  ///
  /// In en, this message translates to:
  /// **'LEADERBOARD'**
  String get leaderboard_title;

  /// No description provided for @leaderboard_you.
  ///
  /// In en, this message translates to:
  /// **'{name} (You)'**
  String leaderboard_you(String name);

  /// No description provided for @leaderboard_points.
  ///
  /// In en, this message translates to:
  /// **'{score} pts'**
  String leaderboard_points(int score);

  /// No description provided for @stats_score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get stats_score;

  /// No description provided for @stats_streak.
  ///
  /// In en, this message translates to:
  /// **'Daily Streak'**
  String get stats_streak;

  /// No description provided for @stats_memorized.
  ///
  /// In en, this message translates to:
  /// **'Memorized'**
  String get stats_memorized;

  /// No description provided for @stats_timeSpent.
  ///
  /// In en, this message translates to:
  /// **'Time Spent'**
  String get stats_timeSpent;

  /// No description provided for @stats_practices.
  ///
  /// In en, this message translates to:
  /// **'Practices'**
  String get stats_practices;

  /// No description provided for @stats_timeSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String stats_timeSeconds(int seconds);

  /// No description provided for @stats_timeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m'**
  String stats_timeMinutes(int minutes);

  /// No description provided for @stats_timeHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String stats_timeHoursMinutes(int hours, int minutes);

  /// No description provided for @game_title_flashcards.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get game_title_flashcards;

  /// No description provided for @game_desc_flashcards.
  ///
  /// In en, this message translates to:
  /// **'Classic flip cards for active recall'**
  String get game_desc_flashcards;

  /// No description provided for @game_title_typing.
  ///
  /// In en, this message translates to:
  /// **'First Letter'**
  String get game_title_typing;

  /// No description provided for @game_desc_typing.
  ///
  /// In en, this message translates to:
  /// **'Type the first letter of each word'**
  String get game_desc_typing;

  /// No description provided for @game_title_builder.
  ///
  /// In en, this message translates to:
  /// **'Verse Builder'**
  String get game_title_builder;

  /// No description provided for @game_desc_builder.
  ///
  /// In en, this message translates to:
  /// **'Assemble the verse from a word bank'**
  String get game_desc_builder;

  /// No description provided for @game_title_reference.
  ///
  /// In en, this message translates to:
  /// **'Reference Match'**
  String get game_title_reference;

  /// No description provided for @game_desc_reference.
  ///
  /// In en, this message translates to:
  /// **'Match the text to the correct reference'**
  String get game_desc_reference;

  /// No description provided for @game_title_choice.
  ///
  /// In en, this message translates to:
  /// **'Word Choice'**
  String get game_title_choice;

  /// No description provided for @game_desc_choice.
  ///
  /// In en, this message translates to:
  /// **'Pick the correct word for the blanks'**
  String get game_desc_choice;

  /// No description provided for @practice_emptyLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Library is Empty'**
  String get practice_emptyLibraryTitle;

  /// No description provided for @practice_emptyLibraryBody.
  ///
  /// In en, this message translates to:
  /// **'Save some verses from the Bible tab to start your memorization journey.'**
  String get practice_emptyLibraryBody;

  /// No description provided for @practice_emptyLibraryAction.
  ///
  /// In en, this message translates to:
  /// **'Go to Bible'**
  String get practice_emptyLibraryAction;

  /// No description provided for @settings_deleteAccountOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection Required'**
  String get settings_deleteAccountOfflineTitle;

  /// No description provided for @settings_deleteAccountOfflineBody.
  ///
  /// In en, this message translates to:
  /// **'To safely delete your account from our servers, you need to be online. Please connect and try again.'**
  String get settings_deleteAccountOfflineBody;

  /// No description provided for @settings_deleteAccountGeneralError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while deleting your account. Please try again later.'**
  String get settings_deleteAccountGeneralError;

  /// No description provided for @settings_deleteAccountErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error deleting account!'**
  String get settings_deleteAccountErrorTitle;

  /// No description provided for @stats_defaultUserName.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get stats_defaultUserName;

  /// No description provided for @settings_syncPartialSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sync finished, but some data couldn\'t be sent.'**
  String get settings_syncPartialSuccess;

  /// No description provided for @settings_syncFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed. Please check your connection.'**
  String get settings_syncFailed;

  /// No description provided for @sync_reconnecting.
  ///
  /// In en, this message translates to:
  /// **'Connection restored. Syncing data...'**
  String get sync_reconnecting;

  /// No description provided for @sync_offlineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline mode. Changes will save locally.'**
  String get sync_offlineMode;

  /// No description provided for @friends_serverOffline.
  ///
  /// In en, this message translates to:
  /// **'Server unreachable. Friend updates are paused.'**
  String get friends_serverOffline;

  /// No description provided for @friends_tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Retry Connection'**
  String get friends_tryAgain;

  /// No description provided for @social_phoneOffline.
  ///
  /// In en, this message translates to:
  /// **'Your phone has no internet connection.'**
  String get social_phoneOffline;

  /// No description provided for @social_serverOffline.
  ///
  /// In en, this message translates to:
  /// **'The server is currently unreachable.'**
  String get social_serverOffline;

  /// No description provided for @social_connectButton.
  ///
  /// In en, this message translates to:
  /// **'Connect to Server'**
  String get social_connectButton;

  /// No description provided for @social_serverUnreachableTitle.
  ///
  /// In en, this message translates to:
  /// **'Server Unreachable'**
  String get social_serverUnreachableTitle;

  /// No description provided for @social_serverUnreachableDescription.
  ///
  /// In en, this message translates to:
  /// **'Our servers are taking a brief rest. Please try again later.'**
  String get social_serverUnreachableDescription;

  /// No description provided for @social_unavailableServerOfflineDescription.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t reach the server to load your social profile. Please try again later.'**
  String get social_unavailableServerOfflineDescription;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get something_went_wrong;
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
