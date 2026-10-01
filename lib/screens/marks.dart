import 'package:bakalite/api.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/widgets/mark_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Marks extends StatefulWidget {
  const Marks({super.key});

  @override
  State<Marks> createState() => _MarksState();
}

class _MarksState extends State<Marks> {
  Map<String, dynamic>? _marks;
  List<Map<String, dynamic>>? _marksLast;

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
      });
    } catch (e) {
      if (!mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.marks)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView(
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
          ),
        ),
      ),
    );
  }
}
