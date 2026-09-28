import 'package:bakalite/accounts.dart';
import 'package:bakalite/app.dart';
import 'package:bakalite/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(
    MainApp(
      route: await accountManager.getActiveAccount() == null
          ? '/login'
          : '/dashboard',
    ),
  );
}
