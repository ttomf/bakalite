// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get searchHint => 'Hledat...';

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
}
