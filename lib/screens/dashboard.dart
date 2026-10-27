import 'package:bakalite/accounts.dart';
import 'package:bakalite/api.dart';
import 'package:bakalite/cache/cache.dart';
import 'package:bakalite/config.dart';
import 'package:bakalite/exceptions.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/utils.dart';
import 'package:bakalite/widgets/module_card.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load([bool useCache = true]) async {
    try {
      final cached = useCache ? await cache.load('user') : null;
      final userData = cached?['data'] ?? await api.fetch('user');

      if (!mounted) return;

      if (userData != null) {
        setState(() {
          _user = userData;
        });
      }
      if (_user == null && userData == null) {
        final account = await accountManager.getActiveAccount();
        if (account != null) {
          await api.login(account.username, account.password);
          _load();
        }
      }
      if (cached != null) {
        _load(false);
      }
    } on BakaLiteException catch (e) {
      if (!mounted) return;
      showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.dashboard),
            SelectableText(
              _user?['FullName'] != null
                  ? '${_user!['FullName']} – ${_user!['UserTypeText']}'
                  : '',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ValueListenableBuilder(
                valueListenable: Config.devMode,
                builder: (context, value, child) {
                  return Column(
                    children: [
                      Expanded(
                        child: GridView(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 300,
                              ),
                          children: [
                            ModuleCard(
                              route: '/marks',
                              label: AppLocalizations.of(context)!.marks,
                              icon: Icons.grade,
                            ),
                            ModuleCard(
                              route: '/homework',
                              label: AppLocalizations.of(context)!.homework,
                              icon: Icons.assignment,
                            ),
                            ModuleCard(
                              route: '/timetable',
                              label: AppLocalizations.of(context)!.timetable,
                              icon: Icons.calendar_month,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                              child: ModuleCard(
                                route: '/accounts',
                                label: AppLocalizations.of(context)!.accounts,
                                icon: Icons.account_circle,
                              ),
                            ),
                            Expanded(
                              child: ModuleCard(
                                route: '/settings',
                                label: AppLocalizations.of(context)!.settings,
                                icon: Icons.settings,
                              ),
                            ),
                            if (Config.devMode.value)
                              const Expanded(
                                child: ModuleCard(
                                  route: '/dev',
                                  label: 'Dev',
                                  icon: Icons.developer_mode,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
