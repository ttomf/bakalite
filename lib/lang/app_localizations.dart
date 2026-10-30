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
/// import 'lang/app_localizations.dart';
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

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'{daysCount, plural, one{{daysCount} day} other{{daysCount} days}}'**
  String days(num daysCount);

  /// No description provided for @dayNames.
  ///
  /// In en, this message translates to:
  /// **'Monday Tuesday Wednesday Thursday Friday Saturday Sunday'**
  String get dayNames;

  /// No description provided for @dayNamesShort.
  ///
  /// In en, this message translates to:
  /// **'Mon Tue Wed Thu Fri Sat Sun'**
  String get dayNamesShort;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @cached.
  ///
  /// In en, this message translates to:
  /// **'Cached data from'**
  String get cached;

  /// No description provided for @upToDate.
  ///
  /// In en, this message translates to:
  /// **'Up-to-date data'**
  String get upToDate;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Downloading data...'**
  String get syncing;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get networkError;

  /// No description provided for @httpError.
  ///
  /// In en, this message translates to:
  /// **'HTTP error'**
  String get httpError;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid login credentials'**
  String get invalidCredentials;

  /// No description provided for @invalidResponse.
  ///
  /// In en, this message translates to:
  /// **'Invalid server response'**
  String get invalidResponse;

  /// No description provided for @invalidInput.
  ///
  /// In en, this message translates to:
  /// **'Invalid input'**
  String get invalidInput;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @marks.
  ///
  /// In en, this message translates to:
  /// **'Marks'**
  String get marks;

  /// No description provided for @homework.
  ///
  /// In en, this message translates to:
  /// **'Homework'**
  String get homework;

  /// No description provided for @timetable.
  ///
  /// In en, this message translates to:
  /// **'Timetable'**
  String get timetable;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @seedColor.
  ///
  /// In en, this message translates to:
  /// **'Theme seed color'**
  String get seedColor;

  /// No description provided for @useM3Color.
  ///
  /// In en, this message translates to:
  /// **'Use Material 3 color scheme'**
  String get useM3Color;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @relativeDateLabels.
  ///
  /// In en, this message translates to:
  /// **'Relative date labels'**
  String get relativeDateLabels;

  /// No description provided for @devMode.
  ///
  /// In en, this message translates to:
  /// **'Developer mode'**
  String get devMode;

  /// No description provided for @resetSettings.
  ///
  /// In en, this message translates to:
  /// **'Reset settings'**
  String get resetSettings;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About app'**
  String get about;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @aboutText.
  ///
  /// In en, this message translates to:
  /// **'This is an open-source client for the Bakaláři school system, without ads and tracking. If you like it, please consider giving it a star on GitHub. Bug reports and suggestions for improvement are also welcome.'**
  String get aboutText;

  /// No description provided for @seedColorInfo.
  ///
  /// In en, this message translates to:
  /// **'The default color of the app theme, from which other colors are derived. If you want to use this exact color as the primary color, turn off the \"Use Material 3 color scheme\" option.'**
  String get seedColorInfo;

  /// No description provided for @relativeDateLabelsInfo.
  ///
  /// In en, this message translates to:
  /// **'Use labels such as \"today\", \"tomorrow\", or \"last week\" instead of dates.'**
  String get relativeDateLabelsInfo;

  /// No description provided for @devModeInfo.
  ///
  /// In en, this message translates to:
  /// **'Enable developer mode screen with advanced controls.'**
  String get devModeInfo;

  /// No description provided for @bakaLink.
  ///
  /// In en, this message translates to:
  /// **'Bakaláři link'**
  String get bakaLink;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @searchCityHint.
  ///
  /// In en, this message translates to:
  /// **'Search city...'**
  String get searchCityHint;

  /// No description provided for @confirmDeletion.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete this account?'**
  String get confirmDeletion;

  /// No description provided for @cannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'This field cannot be empty'**
  String get cannotBeEmpty;

  /// No description provided for @nothingFound.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get nothingFound;

  /// No description provided for @byDate.
  ///
  /// In en, this message translates to:
  /// **'By date'**
  String get byDate;

  /// No description provided for @bySubject.
  ///
  /// In en, this message translates to:
  /// **'By subject'**
  String get bySubject;

  /// No description provided for @predictor.
  ///
  /// In en, this message translates to:
  /// **'Predictor'**
  String get predictor;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @totalWeight.
  ///
  /// In en, this message translates to:
  /// **'Total weight'**
  String get totalWeight;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @afterDeadline.
  ///
  /// In en, this message translates to:
  /// **'After deadline'**
  String get afterDeadline;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'start'**
  String get start;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'end'**
  String get end;

  /// No description provided for @permanent.
  ///
  /// In en, this message translates to:
  /// **'Permanent'**
  String get permanent;

  /// No description provided for @actual.
  ///
  /// In en, this message translates to:
  /// **'Actual'**
  String get actual;

  /// No description provided for @previousWeek.
  ///
  /// In en, this message translates to:
  /// **'Previous week'**
  String get previousWeek;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @nextWeek.
  ///
  /// In en, this message translates to:
  /// **'Next week'**
  String get nextWeek;
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
