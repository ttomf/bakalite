import 'package:bakalite/api.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:flutter/material.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  Map<String, dynamic>? _timetable;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      Map<String, dynamic>? timetableData = _timetable;

      if (_timetable == null) {
        timetableData = await api.fetch('timetable/actual');
      }
      if (!mounted) return;

      setState(() {
        _timetable = timetableData;
      });
    } catch (e) {
      if (!mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.timetable)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    if (_timetable != null)
                      for (final day in _timetable!['Days'])
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: constraints.maxWidth / 5,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceDim,
                                  border: Border.all(
                                    color: Colors.black12,
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.dayNames
                                      .split(' ')[day['DayOfWeek'] - 1],
                                ),
                              ),
                            ],
                          ),
                        ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
