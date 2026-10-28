import 'package:bakalite/accounts.dart';
import 'package:bakalite/api.dart';
import 'package:bakalite/cache/cache.dart';
import 'package:bakalite/exceptions.dart';
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
  DateTime? _cacheInfo;
  Map<String, dynamic>? _homework;
  List<Map<String, dynamic>> _homeworkParsed = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load([bool useCache = true, bool throwNetwork = false]) async {
    try {
      final cached = useCache
          ? await cache.load('homeworks?from=2000-01-01')
          : null;
      final homeworkData =
          cached?['data'] ?? await api.fetch('homeworks?from=2000-01-01');

      if (!mounted) return;

      if (homeworkData != null) {
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
        if (cached == null) {
          setState(() {
            _cacheInfo = null;
          });
        }
      }
      if (_homework == null && homeworkData == null) {
        final account = await accountManager.getActiveAccount();
        if (account != null) {
          await api.login(account.username, account.password);
          _load();
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

  void sortHomework() {
    final now = DateTime.now();

    _homeworkParsed.sort((a, b) {
      final aFinished = a['Finished'];
      final bFinished = b['Finished'];

      if (aFinished != bFinished && !a['Closed'] && !b['Closed']) {
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

    if ((res?.isEmpty ?? true) || !mounted) {
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
      onRefresh: () {
        _load(false, true);
      },
      cached: _cacheInfo,
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
