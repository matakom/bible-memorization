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
  String get social_pending => 'Pending';

  @override
  String get social_accept => 'Accept';

  @override
  String get social_unfriendTitle => 'Unfriend?';

  @override
  String get social_unfriendBody =>
      'Are you sure you want to remove this friend?';

  @override
  String get social_cancel => 'Cancel';

  @override
  String get social_remove => 'Remove';

  @override
  String get friendsStats_screenTitle => 'Friend Stats';

  @override
  String get friendsStats_future =>
      'This is where the stats will be displayed.';

  @override
  String get reader_screenTitle => 'Bible';

  @override
  String get reader_loading => 'Loading Scripture...';

  @override
  String get reader_error => 'Could not load text';

  @override
  String get reader_bookSelector => 'Book';

  @override
  String get reader_chapterSelector => 'Chapter';

  @override
  String reader_saveButton(int count) {
    return 'Save $count Verses';
  }

  @override
  String get reader_saveDialogTitle => 'Save to Memory';

  @override
  String get reader_saveDialogBody =>
      'Do you want to add these verses to your daily practice?';

  @override
  String get reader_cancel => 'Cancel';

  @override
  String get reader_confirm => 'Save';

  @override
  String reader_savedVerses(int count) {
    return 'Saved $count Verses';
  }

  @override
  String get reader_savedVersesTitle => 'Saved verses';

  @override
  String get reader_retrySavedVersesFetch => 'Retry';

  @override
  String get reader_errorLoadingSavedVerses => 'Error loading saved verses: ';

  @override
  String get reader_noSavedVersesYet =>
      'No verses saved in this translation yet.\nGo to the Bible to add some!';

  @override
  String get practice_title => 'Practice';

  @override
  String get practice_completedForToday => 'All done today!';

  @override
  String get practice_modes => 'Study modes';

  @override
  String get practice_flashcards => 'Flashcards';

  @override
  String get practice_flashcardsDescription => 'Classic flip cards';

  @override
  String get practice_noVerses => 'No verses available to practice.';

  @override
  String get practice_readeToReview => 'Ready to review';

  @override
  String practice_error(String error) {
    return 'Error: $error';
  }

  @override
  String practice_allVersesReviewed(int totalCount) {
    return 'You have reviewed all $totalCount verses.';
  }

  @override
  String practice_versesScheduled(int dueCount) {
    return 'You have $dueCount verses scheduled for today.';
  }

  @override
  String get practice_practiceAnyway => 'Practice Anyway';

  @override
  String get practice_startSession => 'Start Session';

  @override
  String get practiceShell_sessionComplete => 'Session Complete!';

  @override
  String practiceShell_versesMastered(int count) {
    return 'Verses mastered today: $count';
  }

  @override
  String get practiceShell_finish => 'Finish';

  @override
  String practiceShell_remaining(int count) {
    return 'Remaining: $count';
  }

  @override
  String get reader_appearanceTooltip => 'Appearance';

  @override
  String reader_errorSavingVerses(String error) {
    return 'Error saving verses: $error';
  }

  @override
  String savedVerses_currentTranslation(String abbreviation) {
    return 'Current Translation: $abbreviation';
  }

  @override
  String get savedVerses_verseDeleted => 'Verse deleted';

  @override
  String savedVerses_bookFallback(int book, int chapter, int verse) {
    return 'Book $book $chapter:$verse';
  }

  @override
  String get savedVerses_difficultyEasy => 'Easy';

  @override
  String get savedVerses_difficultyNormal => 'Normal';

  @override
  String get savedVerses_difficultyModerate => 'Moderate';

  @override
  String get savedVerses_difficultyHard => 'Hard';

  @override
  String get savedVerses_difficultyElite => 'Elite';

  @override
  String get settings_debugTools => 'Debug Tools';

  @override
  String get settings_debugDb => 'Debug DB';

  @override
  String get settings_testNotification => 'Test 10s Notification';

  @override
  String get settings_notificationScheduled =>
      'Notification scheduled for 10 seconds from now!';

  @override
  String get settings_forceSync => 'Force Sync Now';

  @override
  String get settings_forceSyncDescription => 'Push/Pull data manually';

  @override
  String get settings_syncing => 'Syncing...';

  @override
  String get settings_syncSuccess => 'Sync Success!';

  @override
  String settings_syncError(String error) {
    return 'Error: $error';
  }

  @override
  String settings_errorLoadingProfile(String error) {
    return 'Error loading profile: $error';
  }

  @override
  String get settings_guestUser => 'Guest User';

  @override
  String get settings_guestProgressSavedLocally => 'Progress saved locally';

  @override
  String social_errorLoadingUser(String error) {
    return 'Error loading user: $error';
  }

  @override
  String get social_unavailableOfflineTitle =>
      'Social features unavailable offline';

  @override
  String get social_unavailableOfflineDescription =>
      'Please connect to the internet and restart the app to sync your friend code.';

  @override
  String social_errorLoadingFriendships(String error) {
    return 'Error loading friendships: $error';
  }

  @override
  String get social_guestTitle => 'Memorize Together';

  @override
  String get social_guestDescription =>
      'Log in to connect with friends, share your progress, and motivate each other to keep learning.';

  @override
  String get stats_screenTitle => 'My Profile';

  @override
  String stats_errorLoadingStats(String error) {
    return 'Error loading stats: $error';
  }

  @override
  String get game_firstLetter_hardMode => 'Hard Mode';

  @override
  String get game_firstLetter_easyMode => 'Easy Mode';

  @override
  String game_firstLetter_mistakes(int count) {
    return 'Mistakes: $count';
  }

  @override
  String get game_firstLetter_hintText => 'Type first letter...';

  @override
  String get game_firstLetter_revealTooltip => 'Reveal Next Word';

  @override
  String get game_flashcard_markedForReview =>
      'Marked for review. You\'ll see this again soon!';

  @override
  String get game_flashcard_rateRecall => 'Rate your recall:';

  @override
  String get game_flashcard_tapToShow => 'Tap card to show answer';

  @override
  String get game_flashcard_errorBookName => 'There was an error!';

  @override
  String get game_flashcard_errorLoadText => 'Could not load text';

  @override
  String get game_reference_prompt => 'Where is this verse found?';

  @override
  String get game_reference_incorrect =>
      'Incorrect reference. Let\'s study this one again!';

  @override
  String game_reference_bookFallback(int book) {
    return 'Book $book';
  }

  @override
  String get game_builder_prompt => 'Build the verse:';

  @override
  String get game_builder_incorrect => 'Not quite! Try a different word.';

  @override
  String get game_builder_dummyLord => 'Lord';

  @override
  String get game_builder_dummyGrace => 'grace';

  @override
  String get game_builder_dummyFaith => 'faith';

  @override
  String get game_builder_dummyHoly => 'holy';

  @override
  String game_wordChoice_prompt(int current, int total) {
    return 'Complete the verse ($current / $total):';
  }

  @override
  String game_wordChoice_incorrect(String word) {
    return 'Oops! The correct word was \'$word\'';
  }

  @override
  String get game_wordChoice_errorFallback1 => 'Error';

  @override
  String get game_wordChoice_errorFallback2 => 'loading';

  @override
  String get game_wordChoice_errorFallback3 => 'verse';

  @override
  String get reader_appearanceTitle => 'Appearance';

  @override
  String get reader_appearanceSansSerif => 'Sans-Serif';

  @override
  String get reader_appearanceSerif => 'Serif';

  @override
  String get reader_appearanceSpacing => 'Spacing';

  @override
  String get settings_deleteAccountButton => 'Delete Account';

  @override
  String get settings_deleteAccountDialogTitle => 'Delete All Data';

  @override
  String get settings_deleteAccountDialogBody =>
      'Are you sure you want to wipe all your data? This will permanently remove all your saved verses, statistics, and friendships. You will start completely fresh.';

  @override
  String get settings_deleteAccountCancel => 'Cancel';

  @override
  String get settings_deleteAccountConfirm => 'Delete';

  @override
  String get settings_deleteAccountSuccess =>
      'All data deleted. Starting fresh!';

  @override
  String settings_deleteAccountError(String error) {
    return 'Error deleting data: $error';
  }

  @override
  String get leaderboard_title => 'LEADERBOARD';

  @override
  String leaderboard_you(String name) {
    return '$name (You)';
  }

  @override
  String leaderboard_points(int score) {
    return '$score pts';
  }

  @override
  String get stats_score => 'Score';

  @override
  String get stats_streak => 'Daily Streak';

  @override
  String get stats_memorized => 'Memorized';

  @override
  String get stats_timeSpent => 'Time Spent';

  @override
  String get stats_practices => 'Practices';

  @override
  String stats_timeSeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String stats_timeMinutes(int minutes) {
    return '${minutes}m';
  }

  @override
  String stats_timeHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get game_title_flashcards => 'Flashcards';

  @override
  String get game_desc_flashcards => 'Classic flip cards for active recall';

  @override
  String get game_title_typing => 'First Letter';

  @override
  String get game_desc_typing => 'Type the first letter of each word';

  @override
  String get game_title_builder => 'Verse Builder';

  @override
  String get game_desc_builder => 'Assemble the verse from a word bank';

  @override
  String get game_title_reference => 'Reference Match';

  @override
  String get game_desc_reference => 'Match the text to the correct reference';

  @override
  String get game_title_choice => 'Word Choice';

  @override
  String get game_desc_choice => 'Pick the correct word for the blanks';

  @override
  String get practice_emptyLibraryTitle => 'Your Library is Empty';

  @override
  String get practice_emptyLibraryBody =>
      'Save some verses from the Bible tab to start your memorization journey.';

  @override
  String get practice_emptyLibraryAction => 'Go to Bible';

  @override
  String get settings_deleteAccountOfflineTitle => 'Connection Required';

  @override
  String get settings_deleteAccountOfflineBody =>
      'To safely delete your account from our servers, you need to be online. Please connect and try again.';

  @override
  String get settings_deleteAccountGeneralError =>
      'Something went wrong while deleting your account. Please try again later.';

  @override
  String get settings_deleteAccountErrorTitle => 'Error deleting account!';

  @override
  String get stats_defaultUserName => 'User';

  @override
  String get settings_syncPartialSuccess =>
      'Sync finished, but some data couldn\'t be sent.';

  @override
  String get settings_syncFailed =>
      'Sync failed. Please check your connection.';

  @override
  String get sync_reconnecting => 'Connection restored. Syncing data...';

  @override
  String get sync_offlineMode => 'Offline mode. Changes will save locally.';

  @override
  String get friends_serverOffline =>
      'Server unreachable. Friend updates are paused.';

  @override
  String get friends_tryAgain => 'Retry Connection';

  @override
  String get social_phoneOffline => 'Your phone has no internet connection.';

  @override
  String get social_serverOffline => 'The server is currently unreachable.';

  @override
  String get social_connectButton => 'Connect to Server';

  @override
  String get social_serverUnreachableTitle => 'Server Unreachable';

  @override
  String get social_serverUnreachableDescription =>
      'Our servers are taking a brief rest. Please try again later.';

  @override
  String get social_unavailableServerOfflineDescription =>
      'We couldn\'t reach the server to load your social profile. Please try again later.';
}
