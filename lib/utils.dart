import 'package:bakalite/exceptions.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences prefs;

void showError(BuildContext context, BakaLiteException error) {
  final lang = AppLocalizations.of(context)!;

  final message =
      switch (error.error) {
        BakaLiteError.network => lang.networkError,
        BakaLiteError.http => lang.httpError,
        BakaLiteError.invalidCredentials => lang.invalidCredentials,
        BakaLiteError.invalidResponse => lang.invalidResponse,
        BakaLiteError.invalidInput => lang.invalidInput,
      } +
      ((error.info?.isNotEmpty ?? false) ? ': ${error.info}' : '');

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        content: Text(
          message,
          style: TextStyle(color: Theme.of(context).colorScheme.onError),
        ),
      ),
    );
}

class Config {
  static final seedColor = ValueNotifier(
    Color(prefs.getInt('settings_seedColor') ?? Colors.lightBlue.toARGB32()),
  );
  static final language = ValueNotifier(
    prefs.getString('settings_language') ?? 'System',
  );
  static final useM3Color = ValueNotifier(
    prefs.getBool('settings_useM3Color') ?? true,
  );
  static final devMode = ValueNotifier(
    prefs.getBool('settings_devMode') ?? false,
  );

  static void init() {
    seedColor.addListener(() {
      save('seedColor', seedColor.value);
    });
    language.addListener(() {
      save('language', language.value);
    });
    useM3Color.addListener(() {
      save('useM3Color', useM3Color.value);
    });
    devMode.addListener(() {
      save('devMode', devMode.value);
    });
  }

  static Future<void> reset() async {
    await prefs.remove('settings_seedColor');
    await prefs.remove('settings_language');
    await prefs.remove('settings_useM3Color');
    await prefs.remove('settings_devMode');
    seedColor.value = Colors.lightBlue;
    language.value = 'System';
    useM3Color.value = true;
    devMode.value = false;
  }

  static Future<void> save<T>(String? key, T value) async {
    if (key == null) {
      return;
    }
    final storageKey = 'settings_$key';

    switch (value) {
      case Color color:
        await prefs.setInt(storageKey, color.toARGB32());
        break;
      case bool boolean:
        await prefs.setBool(storageKey, boolean);
        break;
      case int integer:
        await prefs.setInt(storageKey, integer);
        break;
      case double decimal:
        await prefs.setDouble(storageKey, decimal);
        break;
      case String string:
        await prefs.setString(storageKey, string);
        break;
      case List<String> list:
        await prefs.setStringList(storageKey, list);
        break;
      default:
        throw ArgumentError('Unsupported setting type: ${value.runtimeType}');
    }
  }
}
