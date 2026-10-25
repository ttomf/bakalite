import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getTheme({
    Brightness brightness = Brightness.light,
    Color seedColor = Colors.lightBlue,
    bool useM3Color = true,
  }) {
    final colorScheme = useM3Color
        ? ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness)
        : brightness == Brightness.light
        ? ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: brightness,
            surface: Colors.grey[100],
            surfaceBright: Colors.white,
            surfaceContainer: Colors.white,
            surfaceContainerHigh: Colors.white,
            surfaceContainerHighest: Colors.white,
            surfaceContainerLow: Colors.white,
            surfaceContainerLowest: Colors.white,
            primary: seedColor,
          )
        : ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: brightness,
            surface: Colors.black,
            surfaceBright: Colors.grey[900],
            surfaceContainer: Colors.grey[900],
            surfaceContainerHigh: Colors.grey[900],
            surfaceContainerHighest: Colors.grey[900],
            surfaceContainerLow: Colors.grey[900],
            surfaceContainerLowest: Colors.grey[900],
            primary: seedColor,
          );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: colorScheme.surface,
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
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
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
      ),
      expansionTileTheme: const ExpansionTileThemeData(
        shape: Border(),
        collapsedShape: Border(),
      ),
      colorScheme: colorScheme,
    );
  }
}
