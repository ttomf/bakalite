import 'package:bakalite/config.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/screens/wrapper.dart';
import 'package:bakalite/widgets/setting_card.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int settingsKey = 0;

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: AppLocalizations.of(context)!.settings,
      children: [
        ListView(
          children: [
            SettingCard<String>(
              key: ValueKey((settingsKey, 'language')),
              setting: Config.language,
              label: AppLocalizations.of(context)!.language,
              choices: {
                'System': AppLocalizations.of(context)!.systemDefault,
                for (final lang in AppLocalizations.supportedLocales)
                  lang.toLanguageTag(): lang.toLanguageTag(),
              },
            ),
            SettingCard<Color>(
              key: ValueKey((settingsKey, 'seedColor')),
              setting: Config.seedColor,
              info: AppLocalizations.of(context)!.seedColorInfo,
              label: AppLocalizations.of(context)!.seedColor,
            ),
            SettingCard<bool>(
              key: ValueKey((settingsKey, 'useM3Color')),
              setting: Config.useM3Color,
              label: AppLocalizations.of(context)!.useM3Color,
            ),
            SettingCard<String>(
              key: ValueKey((settingsKey, 'brightness')),
              setting: Config.brightness,
              label: AppLocalizations.of(context)!.theme,
              choices: {
                'System': AppLocalizations.of(context)!.systemDefault,
                'light': AppLocalizations.of(context)!.light,
                'dark': AppLocalizations.of(context)!.dark,
              },
            ),
            SettingCard<bool>(
              key: ValueKey((settingsKey, 'relativeDateLabels')),
              setting: Config.relativeDateLabels,
              info: AppLocalizations.of(context)!.relativeDateLabelsInfo,
              label: AppLocalizations.of(context)!.relativeDateLabels,
            ),
            SettingCard<bool>(
              key: ValueKey((settingsKey, 'devMode')),
              setting: Config.devMode,
              info: AppLocalizations.of(context)!.devModeInfo,
              label: AppLocalizations.of(context)!.devMode,
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
            SettingCard<void>(
              label: AppLocalizations.of(context)!.about,
              onSet: (value) async {
                showAboutDialog(
                  context: context,
                  applicationVersion: '0.1.0',
                  applicationName: 'BakaLite',
                  children: [
                    Text(AppLocalizations.of(context)!.aboutText),
                    TextButton(
                      child: const Text('github.com/ttomf/bakalite'),
                      onPressed: () {
                        launchUrl(
                          Uri.parse('https://github.com/ttomf/bakalite'),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
