// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get common_comingSoon => 'Brzy dostupné!';

  @override
  String get login_screenTitle => 'Přihlášení';

  @override
  String get login_signInButton => 'Přihlásit se';

  @override
  String get login_errorOnSignIn => 'Přihlášení selhalo';

  @override
  String get reader_navbar => 'Bible';

  @override
  String get stats_navbar => 'Statistiky';

  @override
  String get practice_navbar => 'Procvičování';

  @override
  String get social_navbar => 'Přátelé';

  @override
  String get settings_navbar => 'Nastavení';

  @override
  String get settings_screenTitle => 'Nastavení';

  @override
  String get settings_signOutButton => 'Odhlásit se';

  @override
  String get settings_errorOnSignOut => 'Odhlášení selhalo';

  @override
  String get settings_appsLanguage => 'Jazyk aplikace';

  @override
  String get settings_themeLight => 'Světlý';

  @override
  String get settings_themeDark => 'Tmavý';

  @override
  String get settings_themeSystem => 'Výchozí systémový';

  @override
  String get settings_tokenButton => 'Zobrazit token';

  @override
  String get social_screenTitle => 'Přátelé';

  @override
  String get social_addFriend => 'Přidat přítele';

  @override
  String get social_sendRequest => 'Odeslat žádost';

  @override
  String get social_yourCode => 'Tvůj kód';

  @override
  String get social_codeFetchError => 'Chyba při načítání kódu';

  @override
  String get social_nothingHere => 'Zatím tu nic není...';

  @override
  String get social_nothingToSeeHereYet =>
      'Zatím tu nic není. Začni tím, že si přidáš pár přátel!';

  @override
  String get social_friendRequest => 'Žádost o přátelství';

  @override
  String get social_friends => 'Přátelé';

  @override
  String get social_sentRequests => 'Odeslané žádosti';

  @override
  String get social_pending => 'Čeká se';

  @override
  String get social_accept => 'Přijmout';

  @override
  String get social_unfriendTitle => 'Odebrat z přátel?';

  @override
  String get social_unfriendBody => 'Opravdu chceš odebrat tohoto přítele?';

  @override
  String get social_cancel => 'Zrušit';

  @override
  String get social_remove => 'Odebrat';

  @override
  String get friendsStats_screenTitle => 'Statistiky přítele';

  @override
  String get friendsStats_future => 'Zde se zobrazí statistiky.';

  @override
  String get reader_screenTitle => 'Bible';

  @override
  String get reader_loading => 'Načítání Písma...';

  @override
  String get reader_error => 'Nepodařilo se načíst text';

  @override
  String get reader_bookSelector => 'Kniha';

  @override
  String get reader_chapterSelector => 'Kapitola';

  @override
  String reader_saveButton(int count) {
    return 'Uložit $count veršů';
  }

  @override
  String get reader_saveDialogTitle => 'Uložit k zapamatování';

  @override
  String get reader_saveDialogBody =>
      'Chceš tyto verše přidat do svého denního procvičování?';

  @override
  String get reader_cancel => 'Zrušit';

  @override
  String get reader_confirm => 'Uložit';

  @override
  String reader_savedVerses(int count) {
    return 'Uloženo $count veršů';
  }

  @override
  String get reader_savedVersesTitle => 'Uložené verše';

  @override
  String get reader_retrySavedVersesFetch => 'Zkusit znovu';

  @override
  String get reader_errorLoadingSavedVerses =>
      'Chyba při načítání uložených veršů: ';

  @override
  String get reader_noSavedVersesYet =>
      'Zatím nemáš žádné uložené verše v tomto překladu.\nBěž do Bible a nějaké si přidej!';

  @override
  String get practice_title => 'Procvičování';

  @override
  String get practice_completedForToday => 'Pro dnešek máš hotovo!';

  @override
  String get practice_modes => 'Režimy učení';

  @override
  String get practice_flashcards => 'Kartičky';

  @override
  String get practice_flashcardsDescription => 'Klasické oboustranné kartičky';

  @override
  String get practice_noVerses => 'Žádné verše k procvičování.';

  @override
  String get practice_readeToReview => 'Připraveno k opakování';

  @override
  String practice_error(String error) {
    return 'Chyba: $error';
  }

  @override
  String practice_allVersesReviewed(int totalCount) {
    return 'Zopakoval jsi všech $totalCount veršů.';
  }

  @override
  String practice_versesScheduled(int dueCount) {
    return 'Na dnešek máš naplánováno $dueCount veršů.';
  }

  @override
  String get practice_practiceAnyway => 'Přesto procvičovat';

  @override
  String get practice_startSession => 'Začít lekci';

  @override
  String get practiceShell_sessionComplete => 'Lekce dokončena!';

  @override
  String practiceShell_versesMastered(int count) {
    return 'Dnes zvládnutých veršů: $count';
  }

  @override
  String get practiceShell_finish => 'Dokončit';

  @override
  String practiceShell_remaining(int count) {
    return 'Zbývá: $count';
  }

  @override
  String get reader_appearanceTooltip => 'Vzhled';

  @override
  String reader_errorSavingVerses(String error) {
    return 'Chyba při ukládání veršů: $error';
  }

  @override
  String savedVerses_currentTranslation(String abbreviation) {
    return 'Aktuální překlad: $abbreviation';
  }

  @override
  String get savedVerses_verseDeleted => 'Verš byl smazán';

  @override
  String savedVerses_bookFallback(int book, int chapter, int verse) {
    return 'Kniha $book $chapter:$verse';
  }

  @override
  String get savedVerses_difficultyEasy => 'Snadné';

  @override
  String get savedVerses_difficultyNormal => 'Normální';

  @override
  String get savedVerses_difficultyModerate => 'Střední';

  @override
  String get savedVerses_difficultyHard => 'Těžké';

  @override
  String get savedVerses_difficultyElite => 'Elitní';

  @override
  String get settings_debugTools => 'Nástroje pro vývojáře';

  @override
  String get settings_debugDb => 'Ladění DB';

  @override
  String get settings_testNotification => 'Testovací oznámení (5s)';

  @override
  String get settings_notificationScheduled =>
      'Oznámení je naplánováno za 5 sekund!';

  @override
  String get settings_forceSync => 'Vynutit synchronizaci';

  @override
  String get settings_forceSyncDescription => 'Ruční odeslání/stažení dat';

  @override
  String get settings_syncing => 'Synchronizace...';

  @override
  String get settings_syncSuccess => 'Synchronizace byla úspěšná!';

  @override
  String settings_syncError(String error) {
    return 'Chyba: $error';
  }

  @override
  String settings_errorLoadingProfile(String error) {
    return 'Chyba při načítání profilu: $error';
  }

  @override
  String get settings_guestUser => 'Host';

  @override
  String get settings_guestProgressSavedLocally =>
      'Pokrok se ukládá pouze v zařízení';

  @override
  String social_errorLoadingUser(String error) {
    return 'Chyba při načítání uživatele: $error';
  }

  @override
  String get social_unavailableOfflineTitle =>
      'Sociální funkce nejsou dostupné offline';

  @override
  String get social_unavailableOfflineDescription =>
      'Připoj se k internetu a restartuj aplikaci, aby se synchronizoval tvůj kód přítele.';

  @override
  String social_errorLoadingFriendships(String error) {
    return 'Chyba při načítání přátel: $error';
  }

  @override
  String get social_guestTitle => 'Učte se společně';

  @override
  String get social_guestDescription =>
      'Přihlas se, abys mohl komunikovat s přáteli, sdílet svůj pokrok a navzájem se motivovat.';

  @override
  String get stats_screenTitle => 'Můj profil';

  @override
  String stats_errorLoadingStats(String error) {
    return 'Chyba při načítání statistik: $error';
  }

  @override
  String get game_firstLetter_hardMode => 'Těžký režim';

  @override
  String get game_firstLetter_easyMode => 'Lehký režim';

  @override
  String game_firstLetter_mistakes(int count) {
    return 'Chyby: $count';
  }

  @override
  String get game_firstLetter_hintText => 'Napiš první písmeno...';

  @override
  String get game_firstLetter_revealTooltip => 'Odhalit další slovo';

  @override
  String get game_flashcard_markedForReview =>
      'Označeno k opakování. Brzy tento verš uvidíš znovu!';

  @override
  String get game_flashcard_rateRecall => 'Ohodnoť, jak sis to pamatoval:';

  @override
  String get game_flashcard_tapToShow => 'Klepnutím zobrazíš odpověď';

  @override
  String get game_flashcard_errorBookName => 'Nastala chyba!';

  @override
  String get game_flashcard_errorLoadText => 'Nepodařilo se načíst text';

  @override
  String get game_reference_prompt => 'Kde se nachází tento verš?';

  @override
  String get game_reference_incorrect =>
      'Nesprávný odkaz. Zkusíme to příště znovu!';

  @override
  String game_reference_bookFallback(int book) {
    return 'Kniha $book';
  }

  @override
  String get game_builder_prompt => 'Sestav verš:';

  @override
  String get game_builder_incorrect => 'Těsně vedle! Zkus jiné slovo.';

  @override
  String game_wordChoice_prompt(int current, int total) {
    return 'Doplň verš ($current / $total):';
  }

  @override
  String game_wordChoice_incorrect(String word) {
    return 'Jejda! Správné slovo bylo \'$word\'';
  }

  @override
  String get game_wordChoice_errorFallback1 => 'Chyba';

  @override
  String get game_wordChoice_errorFallback2 => 'při';

  @override
  String get game_wordChoice_errorFallback3 => 'načítání';

  @override
  String get reader_appearanceTitle => 'Vzhled';

  @override
  String get reader_appearanceSansSerif => 'Bezpatkové';

  @override
  String get reader_appearanceSerif => 'Patkové';

  @override
  String get reader_appearanceSpacing => 'Řádkování';

  @override
  String get settings_deleteAccountButton => 'Smazat účet';

  @override
  String get settings_deleteAccountDialogTitle => 'Smazat všechna data';

  @override
  String get settings_deleteAccountDialogBody =>
      'Opravdu chceš smazat všechna svá data? Tím trvale odstraníš všechny uložené verše, statistiky a přátele. Začneš úplně od začátku.';

  @override
  String get settings_deleteAccountCancel => 'Zrušit';

  @override
  String get settings_deleteAccountConfirm => 'Smazat';

  @override
  String get settings_deleteAccountSuccess =>
      'Všechna data byla smazána. Začínáš s čistým štítem!';

  @override
  String settings_deleteAccountError(String error) {
    return 'Chyba při mazání dat: $error';
  }

  @override
  String get leaderboard_title => 'ŽEBŘÍČEK';

  @override
  String leaderboard_you(String name) {
    return '$name (Ty)';
  }

  @override
  String leaderboard_points(int score) {
    return '$score b';
  }

  @override
  String get stats_score => 'Skóre';

  @override
  String get stats_streak => 'Denní řada';

  @override
  String get stats_memorized => 'Zapamatováno';

  @override
  String get stats_timeSpent => 'Čas učení';

  @override
  String get stats_practices => 'Procvičení';

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
  String get game_title_flashcards => 'Kartičky';

  @override
  String get game_desc_flashcards => 'Klasické oboustranné kartičky';

  @override
  String get game_title_typing => 'První písmena';

  @override
  String get game_desc_typing => 'Piš první písmena slov';

  @override
  String get game_title_builder => 'Skládání';

  @override
  String get game_desc_builder => 'Sestav verš ze zásoby slov';

  @override
  String get game_title_reference => 'Odkazy';

  @override
  String get game_desc_reference => 'Přiřaď správný biblický odkaz';

  @override
  String get game_title_choice => 'Výběr slov';

  @override
  String get game_desc_choice => 'Doplňuj chybějící slova do verše';

  @override
  String get practice_emptyLibraryTitle => 'Tvá knihovna je prázdná';

  @override
  String get practice_emptyLibraryBody =>
      'Ulož si nějaké verše z Bible, abys mohl začít s procvičováním.';

  @override
  String get practice_emptyLibraryAction => 'Přejít do Bible';

  @override
  String get settings_deleteAccountOfflineTitle => 'Vyžadováno připojení';

  @override
  String get settings_deleteAccountOfflineBody =>
      'Pro bezpečné smazání účtu z našich serverů musíš být online. Připoj se prosím a zkuste to znovu.';

  @override
  String get settings_deleteAccountGeneralError =>
      'Při mazání účtu došlo k chybě. Zkuste to prosím později.';

  @override
  String get settings_deleteAccountErrorTitle => 'Chyba při mazání účtu!';

  @override
  String get stats_defaultUserName => 'Uživatel';

  @override
  String get settings_syncPartialSuccess =>
      'Synchronizace dokončena, ale některá data se nepodařilo odeslat.';

  @override
  String get settings_syncFailed =>
      'Synchronizace se nezdařila. Zkontrolujte připojení.';

  @override
  String get sync_reconnecting => 'Připojení obnoveno. Synchronizuji data...';

  @override
  String get sync_offlineMode => 'Režim offline. Změny se ukládají lokálně.';

  @override
  String get friends_serverOffline =>
      'Server je nedostupný. Aktualizace přátel jsou pozastaveny.';

  @override
  String get friends_tryAgain => 'Zkusit znovu';

  @override
  String get social_phoneOffline => 'Nemáš připojení k internetu.';

  @override
  String get social_serverOffline => 'Server je momentálně nedostupný.';

  @override
  String get social_connectButton => 'Připojit k serveru';

  @override
  String get social_serverUnreachableTitle => 'Server je nedostupný';

  @override
  String get social_serverUnreachableDescription =>
      'Naše servery si dávají krátkou pauzu. Zkuste to prosím později.';

  @override
  String get social_unavailableServerOfflineDescription =>
      'Nepodařilo se nám připojit k serveru pro načtení vašeho sociálního profilu. Zkuste to prosím později.';

  @override
  String get something_went_wrong => 'Něco se nepovedlo';
}
