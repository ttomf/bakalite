import 'package:bakalite/api.dart';
import 'package:bakalite/lang/app_localizations.dart';
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

  Future<void> _load() async {
    try {
      Map<String, dynamic>? userData = _user;

      if (_user == null) {
        userData = await api.fetch('user');
      }

      if (!mounted) return;

      setState(() {
        _user = userData;
      });
    } catch (e) {
      if (!mounted) return;
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
              child: GridView(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                ),
                children: [
                  Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/marks');
                      },
                      child: Center(
                        child: Text(AppLocalizations.of(context)!.marks),
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/homework');
                      },
                      child: Center(
                        child: Text(AppLocalizations.of(context)!.homework),
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                      child: Center(
                        child: Text(AppLocalizations.of(context)!.settings),
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Center(
                        child: Text(AppLocalizations.of(context)!.login),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
