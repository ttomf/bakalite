import 'package:bakalite/screens/dashboard.dart';
import 'package:bakalite/screens/dev.dart';
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
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        Config.seedColor,
        Config.language,
        Config.useM3Color,
      ]),
      builder: (context, child) {
        return MaterialApp(
          title: 'BakaLite',
          debugShowCheckedModeBanner: false,

          theme: AppTheme.getTheme(
            brightness: Brightness.light,
            seedColor: Config.seedColor.value,
            useM3Color: Config.useM3Color.value,
          ),
          darkTheme: AppTheme.getTheme(
            brightness: Brightness.dark,
            seedColor: Config.seedColor.value,
            useM3Color: Config.useM3Color.value,
          ),
          themeMode: ThemeMode.system,

          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Config.language.value == 'System'
              ? null
              : Locale(Config.language.value),

          initialRoute: widget.route,
          routes: {
            '/login': (context) => const LoginScreen(),
            '/dashboard': (context) => const Dashboard(),
            '/marks': (context) => const MarksScreen(),
            '/homework': (context) => const HomeworkScreen(),
            '/dev': (context) => const DevScreen(),
            '/settings': (context) => const SettingsScreen(),
          },
        );
      },
    );
  }
}
