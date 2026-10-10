import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/utils.dart';
import 'package:bakalite/widgets/setting_card.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

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
                  setting: Config.seedColor,
                  label: AppLocalizations.of(context)!.seedColor,
                ),
                SettingCard<String>(
                  key: ValueKey((settingsKey, 'language')),
                  setting: Config.language,
                  label: AppLocalizations.of(context)!.language,
                  choices: {
                    'System': AppLocalizations.of(context)!.systemLanguage,
                    for (final lang in AppLocalizations.supportedLocales)
                      lang.toLanguageTag(): lang.toLanguageTag(),
                  },
                ),
                SettingCard<bool>(
                  key: ValueKey((settingsKey, 'useM3Color')),
                  setting: Config.useM3Color,
                  label: AppLocalizations.of(context)!.useM3Color,
                ),
                SettingCard<void>(
                  label: AppLocalizations.of(context)!.resetSettings,
                  onSet: (value) async {
                    await Config.reset();
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
