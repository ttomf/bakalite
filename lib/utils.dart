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
