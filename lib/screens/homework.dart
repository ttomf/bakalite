import 'package:bakalite/api.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/widgets/homework_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  Map<String, dynamic>? _homework;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      Map<String, dynamic>? homeworkData = _homework;

      if (_homework == null) {
        homeworkData = await api.fetch('homeworks');
      }
      if (!mounted) return;

      setState(() {
        _homework = homeworkData;
      });
    } catch (e) {
      if (!mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.homework),
          bottom: TabBar(
            tabs: [Tab(icon: Text(AppLocalizations.of(context)!.current))],
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TabBarView(
                children: [
                  ListView(
                    children: [
                      if (_homework != null)
                        for (final homework in _homework!['Homeworks'])
                          HomeworkCard(
                            subject: homework['Subject']['Name'],
                            content: homework['Content'],
                            dateStart: DateFormat('d. M. yyyy')
                                .format(DateTime.parse(homework['DateStart'])),
                            dateEnd: DateFormat('d. M. yyyy')
                                .format(DateTime.parse(homework['DateEnd'])),
                            canFinish: true,
                          ),
                    ],
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
