import 'package:bakalite/config.dart';
import 'package:bakalite/data/data.dart';
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
  @override
  void initState() {
    super.initState();
    Data.loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        Data.userRes,
        Config.devMode,
        Config.dashboardOrder,
        Config.dashboardColor,
      ]),
      builder: (context, _) {
        return Wrapper(
          title: AppLocalizations.of(context)!.dashboard,
          subtitle: getCacheInfo(
            context,
            Data.userRes.cacheTimestamp['user'],
            Data.userRes.loaded['user'] != null,
            Data.userRes.error['user'] != null,
          ),
          onRefresh: () {
            Data.loadUser(force: true);
          },
          children: [
            ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: Column(
                children: [
                  Center(
                    child: SelectableText(
                      Data.user != null
                          ? '${Data.user!.fullName} – ${Data.user!.userTypeText}'
                          : '',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Expanded(
                    child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 300,
                          ),
                      children: [
                        for (final item in Config.dashboardOrder.value)
                          switch (item) {
                            'komens' => ModuleCard(
                              route: '/komens',
                              label: AppLocalizations.of(context)!.komens,
                              icon: Icons.message,
                              color: Config.dashboardColor.value,
                            ),
                            'events' => ModuleCard(
                              route: '/events',
                              label: AppLocalizations.of(context)!.events,
                              icon: Icons.event,
                              color: Config.dashboardColor.value,
                            ),
                            'marks' => ModuleCard(
                              route: '/marks',
                              label: AppLocalizations.of(context)!.marks,
                              icon: Icons.grade,
                              color: Config.dashboardColor.value,
                            ),
                            'homework' => ModuleCard(
                              route: '/homework',
                              label: AppLocalizations.of(context)!.homework,
                              icon: Icons.assignment,
                              color: Config.dashboardColor.value,
                            ),
                            'timetable' => ModuleCard(
                              route: '/timetable',
                              label: AppLocalizations.of(context)!.timetable,
                              icon: Icons.calendar_month,
                              color: Config.dashboardColor.value,
                            ),
                            _ => const SizedBox.shrink(),
                          },
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
              ),
            ),
          ],
        );
      },
    );
  }
}
