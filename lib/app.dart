import 'package:bakalite/config.dart';
import 'package:bakalite/screens/accounts.dart';
import 'package:bakalite/screens/dashboard.dart';
import 'package:bakalite/screens/dev.dart';
import 'package:bakalite/screens/homework.dart';
import 'package:bakalite/screens/login.dart';
import 'package:bakalite/screens/marks.dart';
import 'package:bakalite/screens/settings.dart';
import 'package:bakalite/screens/timetable.dart';
import 'package:bakalite/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'lang/app_localizations.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key, this.route = '/login'});

  final String route;

  @override
  Widget build(BuildContext context) {
    final routes = {
      '/login': (context) => const LoginScreen(),
      '/dashboard': (context) => const Dashboard(),
      '/marks': (context) => const MarksScreen(),
      '/homework': (context) => const HomeworkScreen(),
      '/timetable': (context) => const TimetableScreen(),
      '/dev': (context) => const DevScreen(),
      '/settings': (context) => const SettingsScreen(),
      '/accounts': (context) => const AccountsScreen(),
    };

    return AnimatedBuilder(
      animation: Listenable.merge([
        Config.language,
        Config.seedColor,
        Config.useM3Color,
        Config.relativeDateLabels,
        Config.brightness,
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
          themeMode: switch (Config.brightness.value) {
            'System' => ThemeMode.system,
            'light' => ThemeMode.light,
            'dark' => ThemeMode.dark,
            _ => ThemeMode.system,
          },

          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Config.language.value == 'System'
              ? null
              : Locale(Config.language.value),

          initialRoute: route,
          onGenerateInitialRoutes: (initialRoute) => [
            if (initialRoute != '/dashboard')
              MaterialPageRoute(
                builder: (context) => const Dashboard(),
                settings: const RouteSettings(name: '/dashboard'),
              ),
            MaterialPageRoute(
              builder: (context) => routes[initialRoute]!(context),
              settings: RouteSettings(name: initialRoute),
            ),
          ],
          routes: routes,
        );
      },
    );
  }
}
