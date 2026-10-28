import 'package:bakalite/api.dart';
import 'package:bakalite/cache/cache.dart';
import 'package:bakalite/config.dart';
import 'package:bakalite/exceptions.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/screens/wrapper.dart';
import 'package:bakalite/utils.dart';
import 'package:bakalite/widgets/module_card.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime? _cacheInfo;
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load([bool useCache = true, bool throwNetwork = false]) async {
    try {
      final cached = useCache ? await cache.load('user') : null;
      final userData = cached?['data'] ?? await api.fetch('user');

      if (!mounted) return;

      if (userData != null) {
        setState(() {
          _user = userData;
        });
        if (cached == null) {
          setState(() {
            _cacheInfo = null;
          });
        }
      }
      if (cached != null) {
        setState(() {
          _cacheInfo = DateTime.fromMillisecondsSinceEpoch(cached['timestamp']);
        });
        _load(false);
      }
    } on BakaLiteException catch (e) {
      if (!mounted) return;
      if (e.error == BakaLiteError.network && !throwNetwork) return;
      showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: AppLocalizations.of(context)!.dashboard,
      subtitle: _user?['FullName'] != null
          ? '${_user!['FullName']} – ${_user!['UserTypeText']}'
          : '',
      onRefresh: () {
        _load(false, true);
      },
      cached: _cacheInfo,
      children: [
        ScrollConfiguration(
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
      ],
    );
  }
}
