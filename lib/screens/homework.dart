import 'package:bakalite/api.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/utils.dart';
import 'package:bakalite/widgets/homework_card.dart';
import 'package:flutter/material.dart';

class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  Map<String, dynamic>? _homework;
  List<Map<String, dynamic>> _homeworkParsed = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      Map<String, dynamic>? homeworkData = _homework;

      if (_homework == null) {
        homeworkData = await api.fetch('homeworks?from=2000-01-01');
      }
      if (!mounted) return;

      setState(() {
        _homework = homeworkData;
        _homeworkParsed = [
          for (final homework in _homework?['Homeworks'] ?? [])
            {
              'SubjectName': homework['Subject']['Name'],
              'Content': homework['Content'].trim(),
              'DateStart': parseTime(homework['DateStart']),
              'DateEnd': parseTime(homework['DateEnd']),
              'Closed': homework['Closed'] && homework['Done'],
              'Finished': homework['Finished'],
            },
        ];
        final now = DateTime.now();
        _homeworkParsed.sort((a, b) {
          final aExpired = a['DateEnd'].isBefore(now);
          final bExpired = b['DateEnd'].isBefore(now);
          final aFinished = a['Finished'];
          final bFinished = b['Finished'];

          if (aFinished != bFinished) {
            return aFinished ? 1 : -1;
          }

          if (aExpired != bExpired) {
            return aExpired ? 1 : -1;
          }

          if (aExpired) {
            return b['DateEnd'].compareTo(a['DateEnd']);
          }

          return a['DateEnd'].compareTo(b['DateEnd']);
        });
      });
    } catch (e) {
      if (!mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.homework),
          bottom: TabBar(
            tabs: [
              Tab(icon: Text(AppLocalizations.of(context)!.current)),
              Tab(icon: Text(AppLocalizations.of(context)!.afterDeadline)),
              Tab(icon: Text(AppLocalizations.of(context)!.closed)),
            ],
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
                      for (final homework in _homeworkParsed)
                        if (!homework['Closed'] &&
                            homework['DateEnd'].isAfter(DateTime.now()))
                          HomeworkCard(
                            subject: homework['SubjectName'],
                            content: homework['Content'],
                            dateStart: homework['DateStart'],
                            dateEnd: homework['DateEnd'],
                            done: homework['Closed'],
                            finished: homework['Finished'],
                          ),
                    ],
                  ),
                  ListView(
                    children: [
                      for (final homework in _homeworkParsed)
                        if (!homework['Closed'] &&
                            homework['DateEnd'].isBefore(DateTime.now()))
                          HomeworkCard(
                            subject: homework['SubjectName'],
                            content: homework['Content'],
                            dateStart: homework['DateStart'],
                            dateEnd: homework['DateEnd'],
                            done: homework['Closed'],
                            finished: homework['Finished'],
                          ),
                    ],
                  ),
                  ListView(
                    children: [
                      for (final homework in _homeworkParsed)
                        if (homework['Closed'])
                          HomeworkCard(
                            subject: homework['SubjectName'],
                            content: homework['Content'],
                            dateStart: homework['DateStart'],
                            dateEnd: homework['DateEnd'],
                            done: homework['Closed'],
                            finished: homework['Finished'],
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
