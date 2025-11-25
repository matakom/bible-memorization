// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get common_comingSoon => 'Již brzy!';

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
  String get settings_themeLight => 'Světlý';

  @override
  String get settings_themeDark => 'Tmavý';

  @override
  String get settings_themeSystem => 'Systém';

  @override
  String get settings_tokenButton => 'Vypiš token';

  @override
  String get social_screenTitle => 'Přátelé';

  @override
  String get social_addFriend => 'Přidat přítele';

  @override
  String get social_sendRequest => 'Odeslat žádost';

  @override
  String get social_yourCode => 'Váš kód';

  @override
  String get social_codeFetchError => 'Chyba při získávání kódu';

  @override
  String get social_nothingHere => 'Nic zde...';

  @override
  String get social_nothingToSeeHereYet =>
      'Zatím zde nic není. Začněte přidáním přátel!';

  @override
  String get social_friendRequest => 'Žádost o přátelství';

  @override
  String get social_friends => 'Přátelé';

  @override
  String get social_sentRequests => 'Odeslané žádosti';

  @override
  String get social_pending => 'Nevyřízené';

  @override
  String get social_accept => 'Přijmout';

  @override
  String get social_unfriendTitle => 'Odebrat přítele?';

  @override
  String get social_unfriendBody => 'Opravdu chcete odebrat tohoto přítele?';

  @override
  String get social_cancel => 'Zrušit';

  @override
  String get social_remove => 'Odebrat';

  @override
  String get friendsStats_screenTitle => 'Statistiky přátel';

  @override
  String get friendsStats_future => 'Zde se zobrazí statistiky.';

  @override
  String get reader_screenTitle => 'Bible';

  @override
  String get reader_loading => 'Načítání Písma...';

  @override
  String get reader_error => 'Text se nepodařilo načíst';

  @override
  String get reader_bookSelector => 'Kniha';

  @override
  String get reader_chapterSelector => 'Kapitola';

  @override
  String reader_saveButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uložit $count veršů',
      few: 'Uložit $count verše',
      one: 'Uložit verš',
    );
    return '$_temp0';
  }

  @override
  String get reader_saveDialogTitle => 'Uložit k zapamatování';

  @override
  String get reader_saveDialogBody =>
      'Chcete přidat tyto verše do svého denního procvičování?';

  @override
  String get reader_cancel => 'Zrušit';

  @override
  String get reader_confirm => 'Uložit';

  @override
  String reader_savedVerses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uloženo $count veršů',
      few: 'Uloženy $count verše',
      one: 'Verš uložen',
    );
    return '$_temp0';
  }

  @override
  String get reader_savedVersesTitle => 'Uložené verše';

  @override
  String get reader_retrySavedVersesFetch => 'Zkusit znovu';

  @override
  String get reader_errorLoadingSavedVerses => 'Nepovedlo se načíst verše: ';

  @override
  String get reader_noSavedVersesYet =>
      'Zatím tu nemáš žádné verše!\nBěž do Bible a přidej nějaký!';
}
