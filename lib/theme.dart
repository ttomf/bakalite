import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getThemeData(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: colorScheme.surface,
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: colorScheme.surface,
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationThemeData(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
      ),
      colorScheme: colorScheme,
    );
  }

  static ThemeData get lightTheme {
    return getThemeData(Brightness.light);
  }

  static ThemeData get darkTheme {
    return getThemeData(Brightness.dark);
  }
}
