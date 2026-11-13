import 'package:bakalite/api.dart';
import 'package:bakalite/data/data.dart';
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
  @override
  void initState() {
    super.initState();
    Data.loadHomework();
  }

  Future<bool> _setHomeworkFinished(String id, bool finished) async {
    try {
      final res = await api.request(
        'homeworks/$id/student-done/$finished',
        method: 'PUT',
      );
      if ((res?.isEmpty ?? true) || !mounted) {
        return false;
      }

      Data.homework?.homework.where((hw) => hw.id == id).firstOrNull?.finished =
          finished;
      Data.homework?.homework.sort();
      Data.homeworkRes.notify();

      return true;
    } on BakaLiteException catch (e) {
      showError(context, e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Data.homeworkRes,
      builder: (context, _) {
        return Wrapper(
          title: AppLocalizations.of(context)!.homework,
          subtitle: getCacheInfo(
            context,
            Data.homeworkRes.cacheTimestamp['homeworks?from=2000-01-01'],
            Data.homeworkRes.loaded['homeworks?from=2000-01-01'] != null,
            Data.homeworkRes.error['homeworks?from=2000-01-01'] != null,
          ),
          tabs: [
            AppLocalizations.of(context)!.current,
            AppLocalizations.of(context)!.afterDeadline,
            AppLocalizations.of(context)!.closed,
          ],
          onRefresh: () {
            Data.loadHomework(force: true);
          },
          children: [
            Data.homework != null
                ? ListView(
                    children: [
                      for (final homework in Data.homework!.homework)
                        if (!homework.closed &&
                            homework.dateEnd
                                .add(const Duration(days: 1))
                                .isAfter(DateTime.now()))
                          HomeworkCard(
                            homework,
                            key: ValueKey(homework.id),
                            onFinishedChange: (val) =>
                                _setHomeworkFinished(homework.id, val),
                          ),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
            Data.homework != null
                ? ListView(
                    children: [
                      for (final homework in Data.homework!.homework)
                        if (!homework.closed &&
                            homework.dateEnd
                                .add(const Duration(days: 1))
                                .isBefore(DateTime.now()))
                          HomeworkCard(
                            homework,
                            key: ValueKey(homework.id),
                            onFinishedChange: (val) =>
                                _setHomeworkFinished(homework.id, val),
                          ),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
            Data.homework != null
                ? ListView(
                    children: [
                      for (final homework in Data.homework!.homework)
                        if (homework.closed)
                          HomeworkCard(homework, key: ValueKey(homework.id)),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }
}
