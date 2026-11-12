import 'package:bakalite/data/data.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/screens/wrapper.dart';
import 'package:bakalite/utils.dart';
import 'package:bakalite/widgets/mark_card.dart';
import 'package:bakalite/widgets/subject_marks_card.dart';
import 'package:flutter/material.dart';

class MarksScreen extends StatefulWidget {
  const MarksScreen({super.key});

  @override
  State<MarksScreen> createState() => _MarksScreenState();
}

class _MarksScreenState extends State<MarksScreen> {
  @override
  void initState() {
    super.initState();
    Data.loadMarks();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Data.marksRes,
      builder: (context, _) {
        return Wrapper(
          title: AppLocalizations.of(context)!.marks,
          subtitle: getCacheInfo(
            context,
            Data.marksRes.cacheTimestamp['marks'],
            Data.marksRes.loaded['marks'] != null,
            Data.marksRes.error['marks'] != null,
          ),
          tabs: [
            AppLocalizations.of(context)!.byDate,
            AppLocalizations.of(context)!.bySubject,
          ],
          onRefresh: () {
            Data.loadMarks(force: true);
          },
          children: [
            Data.marks != null
                ? ListView(
                    children: [
                      for (final mark in Data.marks!.marks) MarkCard(mark),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
            Data.marks != null
                ? ListView(
                    children: [
                      for (final subject in Data.marks!.bySubject.keys)
                        SubjectMarksCard(
                          subject: subject,
                          marks: Data.marks!.bySubject[subject]!.marks,
                          note: Data.marks!.bySubject[subject]!.note,
                        ),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }
}
