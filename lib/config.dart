import 'package:bakalite/utils.dart';
import 'package:material_ui/material_ui.dart';

class ConfigOption<T> extends ValueNotifier<T> {
  final String key;
  final T defaultValue;

  ConfigOption(this.key, this.defaultValue) : super(_load(key, defaultValue)) {
    addListener(() => save(value));
  }

  static T _load<T>(String key, T defaultValue) {
    final storageKey = 'settings_$key';

    final value = switch (defaultValue) {
      Color _ =>
        prefs.getInt(storageKey) == null
            ? defaultValue
            : Color(prefs.getInt(storageKey)!),
      bool _ => prefs.getBool(storageKey) ?? defaultValue,
      int _ => prefs.getInt(storageKey) ?? defaultValue,
      double _ => prefs.getDouble(storageKey) ?? defaultValue,
      String _ => prefs.getString(storageKey) ?? defaultValue,
      List<String> _ => prefs.getStringList(storageKey) ?? defaultValue,
      _ => throw ArgumentError(
        'Unsupported setting type: ${defaultValue.runtimeType}',
      ),
    };

    if (defaultValue is List<String> && value is List<String>) {
      final defaultSet = defaultValue.toSet();
      final valueSet = value.toSet();

      if (defaultSet.length != valueSet.length ||
          !defaultSet.containsAll(valueSet)) {
        return defaultValue as T;
      }
    }

    return value as T;
  }

  Future<void> save([T? newValue]) async {
    final storageKey = 'settings_$key';
    final currentValue = newValue ?? value;

    switch (currentValue) {
      case Color color:
        await prefs.setInt(storageKey, color.toARGB32());
      case bool boolean:
        await prefs.setBool(storageKey, boolean);
      case int integer:
        await prefs.setInt(storageKey, integer);
      case double decimal:
        await prefs.setDouble(storageKey, decimal);
      case String string:
        await prefs.setString(storageKey, string);
      case List<String> list:
        await prefs.setStringList(storageKey, list);
      default:
        throw ArgumentError(
          'Unsupported setting type: ${currentValue.runtimeType}',
        );
    }
  }

  Future<void> reset() async {
    value = defaultValue;
    await save();
  }
}

class Config {
  static final language = ConfigOption('language', 'System');
  static final seedColor = ConfigOption('seedColor', Colors.lightBlue as Color);
  static final useM3Color = ConfigOption('useM3Color', false);
  static final brightness = ConfigOption('brightness', 'System');
  static final autoRefresh = ConfigOption('autoRefresh', true);
  static final flexTimetable = ConfigOption('useFlexTimetable', false);
  static final relativeDateLabels = ConfigOption('relativeDateLabels', true);
  static final dashboardOrder = ConfigOption('dashboardOrder', [
    'komens',
    'events',
    'marks',
    'homework',
    'timetable',
    'subjects',
  ]);
  static final dashboardColor = ConfigOption('dashboardColor', true);
  static final devMode = ConfigOption('devMode', false);

  static Future<void> reset() async {
    await Future.wait([
      language.reset(),
      seedColor.reset(),
      useM3Color.reset(),
      brightness.reset(),
      autoRefresh.reset(),
      flexTimetable.reset(),
      relativeDateLabels.reset(),
      dashboardOrder.reset(),
      dashboardColor.reset(),
      devMode.reset(),
    ]);
  }
}
