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
              'ID': homework['ID'],
            },
        ];
        sortHomework();
      });
    } catch (e) {
      if (!mounted) return;
    }
  }

  void sortHomework() {
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

      if (aExpired && bExpired) {
        return b['DateEnd'].compareTo(a['DateEnd']);
      }

      if (a['DateEnd'] == b['DateEnd']) {
        return a['DateStart'].compareTo(b['DateStart']);
      }
      return a['DateEnd'].compareTo(b['DateEnd']);
    });
  }

  Future<bool> _setHomeworkFinished(String id, bool finished) async {
    final res = await api.request(
      'homeworks/$id/student-done/$finished',
      method: 'PUT',
    );

    if (res.isEmpty || !mounted) {
      return false;
    }

    final index = _homeworkParsed.indexWhere((hw) => hw['ID'] == id);

    if (index == -1) {
      return false;
    }

    setState(() {
      _homeworkParsed[index] = {
        ..._homeworkParsed[index],
        'Finished': finished,
      };
      sortHomework();
    });

    return true;
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
              Tab(child: Text(AppLocalizations.of(context)!.current)),
              Tab(child: Text(AppLocalizations.of(context)!.afterDeadline)),
              Tab(child: Text(AppLocalizations.of(context)!.closed)),
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
                            key: ValueKey(homework['ID']),
                            subject: homework['SubjectName'],
                            content: homework['Content'],
                            dateStart: homework['DateStart'],
                            dateEnd: homework['DateEnd'],
                            done: homework['Closed'],
                            finished: homework['Finished'],
                            onFinishedChange: (val) =>
                                _setHomeworkFinished(homework['ID'], val),
                          ),
                    ],
                  ),
                  ListView(
                    children: [
                      for (final homework in _homeworkParsed)
                        if (!homework['Closed'] &&
                            homework['DateEnd'].isBefore(DateTime.now()))
                          HomeworkCard(
                            key: ValueKey(homework['ID']),
                            subject: homework['SubjectName'],
                            content: homework['Content'],
                            dateStart: homework['DateStart'],
                            dateEnd: homework['DateEnd'],
                            done: homework['Closed'],
                            finished: homework['Finished'],
                            onFinishedChange: (val) =>
                                _setHomeworkFinished(homework['ID'], val),
                          ),
                    ],
                  ),
                  ListView(
                    children: [
                      for (final homework in _homeworkParsed)
                        if (homework['Closed'])
                          HomeworkCard(
                            key: ValueKey(homework['ID']),
                            subject: homework['SubjectName'],
                            content: homework['Content'],
                            dateStart: homework['DateStart'],
                            dateEnd: homework['DateEnd'],
                            done: homework['Closed'],
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
