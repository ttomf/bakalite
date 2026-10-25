// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get searchCityHint => 'Hledat město...';

  @override
  String get nothingFound => 'Nic nenalezeno';

  @override
  String get bakaLink => 'Odkaz na Bakaláře';

  @override
  String get username => 'Uživatelské jméno';

  @override
  String get password => 'Heslo';

  @override
  String get login => 'Přihlášení';

  @override
  String get networkError => 'Chyba sítě';

  @override
  String get httpError => 'Chyba HTTP';

  @override
  String get invalidCredentials => 'Neplatné přihlašovací údaje';

  @override
  String get invalidResponse => 'Neplatná odpověď serveru';

  @override
  String get invalidInput => 'Neplatný vstup';

  @override
  String get cannotBeEmpty => 'Toto pole nemůže být prázdné';

  @override
  String get dashboard => 'Přehled';

  @override
  String get marks => 'Známky';

  @override
  String get weight => 'Váha';

  @override
  String get settings => 'Nastavení';

  @override
  String get seedColor => 'Výchozí barva vzhledu';

  @override
  String get resetSettings => 'Obnovit nastavení';

  @override
  String get byDate => 'Podle data';

  @override
  String get bySubject => 'Podle předmětu';

  @override
  String get predictor => 'Předvídač';

  @override
  String get average => 'Průměr';

  @override
  String get homework => 'Domácí úkoly';

  @override
  String get current => 'Aktuální';

  @override
  String get start => 'začátek';

  @override
  String get end => 'konec';

  @override
  String get language => 'Jazyk';

  @override
  String get systemDefault => 'Podle systému';

  @override
  String get useM3Color => 'Použít schéma barev Material 3';

  @override
  String get devMode => 'Vývojářský mód';

  @override
  String get totalWeight => 'Celková váha';

  @override
  String get afterDeadline => 'Po odevzdání';

  @override
  String get closed => 'Uzavřené';

  @override
  String days(num daysCount) {
    String _temp0 = intl.Intl.pluralLogic(
      daysCount,
      locale: localeName,
      other: '$daysCount dní',
      few: '$daysCount dny',
      one: '1 den',
    );
    return '$_temp0';
  }

  @override
  String get timetable => 'Rozvrh hodin';

  @override
  String get dayNames => 'Pondělí Úterý Středa Čtvrtek Pátek Sobota Neděle';

  @override
  String get dayNamesShort => 'PO ÚT ST ČT PÁ SO NE';

  @override
  String get permanent => 'Stálý';

  @override
  String get actual => 'Aktuální';

  @override
  String get theme => 'Motiv';

  @override
  String get light => 'Světlý';

  @override
  String get dark => 'Tmavý';

  @override
  String get about => 'O aplikaci';

  @override
  String get aboutText =>
      'Toto je open-source klient pro školní systém Bakaláři, bez reklam a sledování. Pokud se vám líbí, zvažte prosím udělení hvězdičky na GitHubu. Budu rád také za nahlášení případných chyb nebo návrhy na vylepšení.';

  @override
  String get previousWeek => 'Minulý týden';

  @override
  String get thisWeek => 'Tento týden';

  @override
  String get nextWeek => 'Příští týden';

  @override
  String get relativeDateLabels => 'Relativní názvy dat';

  @override
  String get accounts => 'Účty';

  @override
  String get yes => 'Ano';

  @override
  String get no => 'Ne';

  @override
  String get confirmDeletion => 'Opravdu chcete smazat tento účet?';
}
