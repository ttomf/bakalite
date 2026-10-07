import 'package:bakalite/screens/dashboard.dart';
import 'package:bakalite/screens/homework.dart';
import 'package:bakalite/screens/login.dart';
import 'package:bakalite/screens/marks.dart';
import 'package:bakalite/screens/settings.dart';
import 'package:bakalite/theme.dart';
import 'package:bakalite/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'lang/app_localizations.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key, this.route = '/login'});

  final String route;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Color seedColor = Color(
    prefs.getInt('settings_seedColor') ?? Colors.lightBlue.toARGB32(),
  );
  String? locale = prefs.getString('settings_language');
  bool useM3Color = prefs.getBool('settings_useM3Color') ?? true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BakaLite',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.getTheme(
        brightness: Brightness.light,
        seedColor: seedColor,
        useM3Color: useM3Color,
      ),
      darkTheme: AppTheme.getTheme(
        brightness: Brightness.dark,
        seedColor: seedColor,
        useM3Color: useM3Color,
      ),
      themeMode: ThemeMode.system,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale == null || locale == 'System' ? null : Locale(locale!),

      initialRoute: widget.route,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const Dashboard(),
        '/marks': (context) => const MarksScreen(),
        '/homework': (context) => const HomeworkScreen(),
        '/settings': (context) => SettingsScreen(
          onColorChanged: (value) {
            setState(() {
              seedColor = value;
            });
          },
          onLanguageChanged: (value) {
            setState(() {
              locale = value;
            });
          },
          onUseM3ColorChanged: (value) {
            setState(() {
              useM3Color = value;
            });
          },
        ),
      },
    );
  }
}
