import 'package:bakalite/accounts.dart';
import 'package:bakalite/api.dart';
import 'package:bakalite/app.dart';
import 'package:bakalite/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  Account? activeAccount = await accountManager.getActiveAccount();
  if (activeAccount != null) {
    try {
      api.baseUrl = activeAccount.baseUrl;
      await api.login(activeAccount.username, activeAccount.password);
    } catch (e) {
      activeAccount = null;
    }
  }
  runApp(MainApp(route: activeAccount == null ? '/login' : '/dashboard'));
}
