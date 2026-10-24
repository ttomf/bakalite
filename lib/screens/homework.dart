import 'package:bakalite/api.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/screens/wrapper.dart';
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
      final homeworkData =
          _homework ?? await api.fetch('homeworks?from=2000-01-01');

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
              'Closed': homework['Closed'] || homework['Done'],
              'Finished': homework['Finished'],
              'ID': homework['ID'],
              'Attachments': homework['Attachments'],
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
      final aFinished = a['Finished'];
      final bFinished = b['Finished'];

      if (aFinished != bFinished) {
        return aFinished ? 1 : -1;
      }

      final aEnd = a['DateEnd'];
      final bEnd = b['DateEnd'];
      final aExpired = aEnd.add(const Duration(days: 1)).isBefore(now);
      final bExpired = bEnd.add(const Duration(days: 1)).isBefore(now);

      if (aExpired != bExpired) {
        return aExpired ? 1 : -1;
      }

      final dateComparison = aExpired
          ? bEnd.compareTo(aEnd)
          : aEnd.compareTo(bEnd);

      if (dateComparison != 0) {
        return dateComparison;
      }

      return a['ID'].compareTo(b['ID']);
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
    return Wrapper(
      title: AppLocalizations.of(context)!.homework,
      tabs: [
        AppLocalizations.of(context)!.current,
        AppLocalizations.of(context)!.afterDeadline,
        AppLocalizations.of(context)!.closed,
      ],
      children: [
        _homework != null
            ? ListView(
                children: [
                  if (_homework == null)
                    const Center(child: CircularProgressIndicator()),
                  for (final homework in _homeworkParsed)
                    if (!homework['Closed'] &&
                        homework['DateEnd']
                            .add(const Duration(days: 1))
                            .isAfter(DateTime.now()))
                      HomeworkCard(
                        homework,
                        key: ValueKey(homework['ID']),
                        onFinishedChange: (val) =>
                            _setHomeworkFinished(homework['ID'], val),
                      ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
        _homework != null
            ? ListView(
                children: [
                  for (final homework in _homeworkParsed)
                    if (!homework['Closed'] &&
                        homework['DateEnd']
                            .add(const Duration(days: 1))
                            .isBefore(DateTime.now()))
                      HomeworkCard(
                        homework,
                        key: ValueKey(homework['ID']),
                        onFinishedChange: (val) =>
                            _setHomeworkFinished(homework['ID'], val),
                      ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
        _homework != null
            ? ListView(
                children: [
                  for (final homework in _homeworkParsed)
                    if (homework['Closed'])
                      HomeworkCard(homework, key: ValueKey(homework['ID'])),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
