// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get searchCityHint => 'Search city...';

  @override
  String get nothingFound => 'Nothing found';

  @override
  String get bakaLink => 'Bakaláři link';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get networkError => 'Network error';

  @override
  String get httpError => 'HTTP error';

  @override
  String get invalidCredentials => 'Invalid login credentials';

  @override
  String get invalidResponse => 'Invalid server response';

  @override
  String get invalidInput => 'Invalid input';

  @override
  String get cannotBeEmpty => 'This field cannot be empty';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get marks => 'Marks';

  @override
  String get weight => 'Weight';

  @override
  String get settings => 'Settings';

  @override
  String get seedColor => 'Theme seed color';

  @override
  String get resetSettings => 'Reset settings';

  @override
  String get byDate => 'By date';

  @override
  String get bySubject => 'By subject';

  @override
  String get predictor => 'Predictor';

  @override
  String get average => 'Average';

  @override
  String get homework => 'Homework';

  @override
  String get current => 'Current';

  @override
  String get start => 'start';

  @override
  String get end => 'end';

  @override
  String get language => 'Language';

  @override
  String get systemDefault => 'System default';

  @override
  String get useM3Color => 'Use Material 3 color scheme';

  @override
  String get devMode => 'Developer mode';

  @override
  String get totalWeight => 'Total weight';

  @override
  String get afterDeadline => 'After deadline';

  @override
  String get closed => 'Closed';

  @override
  String days(num daysCount) {
    String _temp0 = intl.Intl.pluralLogic(
      daysCount,
      locale: localeName,
      other: '$daysCount days',
      one: '$daysCount day',
    );
    return '$_temp0';
  }

  @override
  String get timetable => 'Timetable';

  @override
  String get dayNames =>
      'Monday Tuesday Wednesday Thursday Friday Saturday Sunday';

  @override
  String get dayNamesShort => 'Mon Tue Wed Thu Fri Sat Sun';

  @override
  String get permanent => 'Permanent';

  @override
  String get actual => 'Actual';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get about => 'About';

  @override
  String get aboutText =>
      'This is an open-source client for the Bakaláři school system, without ads and tracking. If you like it, please consider giving it a star on GitHub. Bug reports and suggestions for improvement are also welcome.';

  @override
  String get previousWeek => 'Previous week';

  @override
  String get thisWeek => 'This week';

  @override
  String get nextWeek => 'Next week';

  @override
  String get relativeDateLabels => 'Relative date labels';

  @override
  String get accounts => 'Accounts';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get confirmDeletion => 'Do you really want to delete this account?';

  @override
  String get noInternet => 'No internet connection';
}
