import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/utils.dart';
import 'package:bakalite/widgets/setting_card.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.onColorChanged,
    required this.onLanguageChanged,
  });

  final ValueChanged<Color> onColorChanged;
  final ValueChanged<String> onLanguageChanged;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int settingsKey = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView(
              children: [
                SettingCard<Color>(
                  key: ValueKey((settingsKey, 'seedColor')),
                  label: AppLocalizations.of(context)!.seedColor,
                  name: 'seedColor',
                  defaultValue: Colors.lightBlue,
                  onSet: (value) {
                    widget.onColorChanged(value!);
                  },
                ),
                SettingCard<String>(
                  key: ValueKey((settingsKey, 'language')),
                  label: AppLocalizations.of(context)!.language,
                  name: 'language',
                  defaultValue: 'System',
                  choices: {
                    'System': AppLocalizations.of(context)!.systemLanguage,
                    for (final lang in AppLocalizations.supportedLocales)
                      lang.toLanguageTag(): lang.toLanguageTag(),
                  },
                  onSet: (value) {
                    widget.onLanguageChanged(value!);
                  },
                ),
                SettingCard<void>(
                  label: AppLocalizations.of(context)!.resetSettings,
                  onSet: (value) {
                    prefs.clear();
                    setState(() {
                      settingsKey++;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
