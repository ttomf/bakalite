import 'package:bakalite/screens/login.dart';
import 'package:bakalite/screens/dashboard.dart';
import 'package:bakalite/screens/marks.dart';
import 'package:bakalite/screens/settings.dart';
import 'package:bakalite/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'lang/app_localizations.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key, this.route = '/login'});

  final String route;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BakaLite',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      initialRoute: route,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const Dashboard(),
        '/marks': (context) => const MarksScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
