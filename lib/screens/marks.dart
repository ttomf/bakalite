import 'package:bakalite/api.dart';
import 'package:bakalite/exceptions.dart';
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
  Map<String, dynamic>? _marks;
  List<Map<String, dynamic>> _marksLast = [];
  Map<String, List<Map<String, dynamic>>> _marksSubjects = {};
  Map<String, dynamic>? _subjects;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final marksData = _marks ?? await api.fetch('marks');

      if (!mounted) return;

      setState(() {
        _marks = marksData;
        _marksLast = [
          for (final subject in _marks?['Subjects'] ?? [])
            for (final mark in subject['Marks'] ?? [])
              {
                'MarkText': mark['MarkText'],
                'Weight': mark['Weight'].toString(),
                'SubjectName': subject['Subject']['Name'],
                'MarkDate': parseTime(mark['MarkDate']),
                'Caption': mark['Caption'].trim(),
                'Theme': mark['Theme'].trim(),
              },
        ];
        _marksLast.sort((a, b) => b['MarkDate'].compareTo(a['MarkDate']));
        _marksSubjects = {};
        for (final subject in _marks?['Subjects'] ?? []) {
          _marksSubjects[subject['Subject']['Name']] = [
            for (final mark in subject['Marks'] ?? [])
              {
                'MarkText': mark['MarkText'],
                'Weight': mark['Weight'].toString(),
                'MarkDate': parseTime(mark['MarkDate']),
                'Caption': mark['Caption'].trim(),
                'Theme': mark['Theme'].trim(),
              },
          ];
          _marksSubjects[subject['Subject']['Name']]!.sort(
            (a, b) => b['MarkDate'].compareTo(a['MarkDate']),
          );
        }
        _subjects = {};
        for (final subject in _marks?['Subjects'] ?? []) {
          _subjects![subject['Subject']['Name']] = {
            'AverageText': subject['AverageText'],
            'SubjectNote': subject['SubjectNote'],
          };
        }
      });
    } on BakaLiteException catch (e) {
      if (!mounted) return;
      showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: AppLocalizations.of(context)!.marks,
      tabs: [
        AppLocalizations.of(context)!.byDate,
        AppLocalizations.of(context)!.bySubject,
        AppLocalizations.of(context)!.predictor,
      ],
      children: [
        _marks != null
            ? ListView(
                children: [for (final mark in _marksLast) MarkCard(mark)],
              )
            : const Center(child: CircularProgressIndicator()),
        _marks != null
            ? ListView(
                children: [
                  if (_subjects != null)
                    for (final subject in _marksSubjects.keys)
                      SubjectMarksCard(
                        subject: subject,
                        marks: _marksSubjects[subject]!,
                        average: _subjects![subject]['AverageText'],
                        note: _subjects![subject]['SubjectNote'],
                      ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
        _marks != null
            ? ListView(children: const [Text('todo')])
            : const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
