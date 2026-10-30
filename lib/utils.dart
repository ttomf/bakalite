import 'package:bakalite/accounts.dart';
import 'package:bakalite/api.dart';
import 'package:bakalite/cache/cache.dart';
import 'package:bakalite/exceptions.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/mocks/mock_http_client.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferencesWithCache prefs;

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

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      dismissDirection: DismissDirection.horizontal,
      backgroundColor: Theme.of(context).colorScheme.error,
      content: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.onError),
      ),
    ),
  );
}

DateTime parseTime(String time) {
  return DateTime.parse(time).toLocal();
}

Future<void> setupApi(Account account, bool throwErrors) async {
  if (account.baseUrl == 'https://debug/api') {
    api = BakalariAPI(client: MockHttpClient());
    cache = const Cache('');
  } else {
    api = BakalariAPI();
    cache = Cache(account.id);
  }
  api.baseUrl = account.baseUrl;
  try {
    await api.login(account.username, account.password);
  } on BakaLiteException {
    if (throwErrors) rethrow;
  }
}

String getCacheInfo(
  BuildContext context,
  DateTime? timestamp,
  bool loaded,
  bool error,
) {
  List<String> texts = [];

  if (error) {
    texts.add(AppLocalizations.of(context)!.error);
  } else {
    if (!loaded) {
      texts.add(AppLocalizations.of(context)!.syncing);
    }
  }

  if (timestamp != null) {
    texts.add(
      '${AppLocalizations.of(context)!.cached} ${DateFormat('d. M. HH:mm').format(timestamp)}',
    );
  }

  if (loaded && timestamp == null) {
    texts.add(AppLocalizations.of(context)!.upToDate);
  }

  return texts.join(', ');
}
