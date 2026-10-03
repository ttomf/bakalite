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
                  key: ValueKey(settingsKey),
                  label: AppLocalizations.of(context)!.seedColor,
                  name: 'seedColor',
                  defaultValue: Colors.lightBlue,
                  onSet: (value) {},
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
