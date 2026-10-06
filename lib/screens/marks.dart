import 'package:bakalite/api.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/widgets/mark_card.dart';
import 'package:bakalite/widgets/subject_marks_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MarksScreen extends StatefulWidget {
  const MarksScreen({super.key});

  @override
  State<MarksScreen> createState() => _MarksScreenState();
}

class _MarksScreenState extends State<MarksScreen> {
  Map<String, dynamic>? _marks;
  List<Map<String, dynamic>>? _marksLast;
  Map<String, dynamic>? _marksSubjects;
  Map<String, dynamic>? _subjects;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      Map<String, dynamic>? marksData = _marks;

      if (_marks == null) {
        marksData = await api.fetch('marks');
      }
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
                'MarkDate': mark['MarkDate'],
                'Caption': mark['Caption'].trim(),
                'Theme': mark['Theme'].trim(),
              },
        ];
        _marksLast!.sort(
          (a, b) =>
              DateTime.parse(b['MarkDate'])
                  .compareTo(DateTime.parse(a['MarkDate'])),
        );
        _marksSubjects = {};
        for (final subject in _marks?['Subjects'] ?? []) {
          _marksSubjects![subject['Subject']['Name']] = [
            for (final mark in subject['Marks'] ?? [])
              {
                'MarkText': mark['MarkText'],
                'Weight': mark['Weight'].toString(),
                'MarkDate': mark['MarkDate'],
                'Caption': mark['Caption'].trim(),
                'Theme': mark['Theme'].trim(),
              },
          ];
        }
        _subjects = {};
        for (final subject in _marks?['Subjects'] ?? []) {
          _subjects![subject['Subject']['Name']] = {
            'AverageText': subject['AverageText'],
            'SubjectNote': subject['SubjectNote'],
          };
        }
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
          title: Text(AppLocalizations.of(context)!.marks),
          bottom: TabBar(
            tabs: [
              Tab(icon: Text(AppLocalizations.of(context)!.byDate)),
              Tab(icon: Text(AppLocalizations.of(context)!.bySubject)),
              Tab(icon: Text(AppLocalizations.of(context)!.predictor)),
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
                      if (_marksLast != null)
                        for (final mark in _marksLast!)
                          MarkCard(
                            mark: mark['MarkText'],
                            weight: mark['Weight'],
                            subject: mark['SubjectName'],
                            date: DateFormat('d. M. yyyy')
                                .format(DateTime.parse(mark['MarkDate'])),
                            caption: mark['Caption'],
                            theme: mark['Theme'],
                          ),
                    ],
                  ),
                  ListView(
                    children: [
                      if (_marksSubjects != null && _subjects != null)
                        for (final subject in _marksSubjects!.keys)
                          SubjectMarksCard(
                            subject: subject,
                            marks: _marksSubjects![subject],
                            average: _subjects![subject]['AverageText'],
                            note: _subjects![subject]['SubjectNote'],
                          ),
                    ],
                  ),
                  ListView(children: [Text('todo')]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
