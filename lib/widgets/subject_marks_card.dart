import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/widgets/edit_mark_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubjectMarksCard extends StatefulWidget {
  const SubjectMarksCard({
    super.key,
    required this.subject,
    required this.marks,
    required this.note,
  });

  final String subject;
  final List<Map<String, dynamic>> marks;
  final String note;

  @override
  State<SubjectMarksCard> createState() => _SubjectMarksCardState();
}

class _SubjectMarksCardState extends State<SubjectMarksCard> {
  int _totalWeight = 0;
  double _average = 0;
  late List<Map<String, dynamic>> _marks;

  @override
  void initState() {
    super.initState();
    _marks = [...widget.marks];
    _compute();
  }

  void _compute() {
    double gradeSum = 0;
    int weightSum = 0;
    for (final mark in _marks) {
      final text = mark['MarkText']?.toString() ?? '';
      final weight = int.tryParse(mark['Weight']?.toString() ?? '') ?? 0;
      final grade = text.endsWith('-')
          ? (int.tryParse(text.replaceAll('-', ''))?.toDouble() ?? 0) + 0.5
          : int.tryParse(text)?.toDouble();
      if (grade == null) continue;
      gradeSum += grade * weight;
      weightSum += weight;
    }
    _totalWeight = weightSum;
    _average = weightSum == 0 ? 0.0 : gradeSum / weightSum;
  }

  @override
  void didUpdateWidget(covariant SubjectMarksCard old) {
    super.didUpdateWidget(old);
    if (!identical(old.marks, widget.marks)) {
      _marks = [...widget.marks];
      _compute();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        key: PageStorageKey(widget.subject),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.subject,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${AppLocalizations.of(context)!.average}: ',
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                      TextSpan(
                        text: NumberFormat(
                          '0.00',
                          Localizations.localeOf(context).languageCode,
                        ).format(_average),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${AppLocalizations.of(context)!.totalWeight}: ',
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                      TextSpan(
                        text: _totalWeight.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${AppLocalizations.of(context)!.marks}: ',
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                      TextSpan(
                        text: widget.marks.length.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          for (final (index, mark) in _marks.indexed) ...[
            Divider(
              height: 0,
              color: Theme.of(context).colorScheme.primary,
              indent: 12,
              endIndent: 12,
            ),
            InkWell(
              onTap: () async {
                final newMark = await showDialog<Map<String, dynamic>>(
                  context: context,
                  builder: (context) => EditMarkDialog(mark: mark),
                );
                if (!mounted || newMark == null) return;
                setState(() {
                  if (newMark['Remove'] == true) {
                    _marks.removeAt(index);
                  } else {
                    _marks[index] = {...mark, ...newMark};
                  }
                  _compute();
                });
              },
              child: ListTile(
                tileColor: mark['Changed'] == true
                    ? Theme.of(context).colorScheme.secondaryContainer
                    : null,
                leading: SizedBox(
                  width: 24,
                  child: Text(
                    mark['MarkText'] ?? '',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                title: (mark['Caption'] ?? '').isNotEmpty
                    ? Text(mark['Caption'])
                    : null,
                subtitle: (mark['Theme'] ?? '').isNotEmpty
                    ? Text(mark['Theme'])
                    : null,
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (mark['Changed'] == true)
                      const Icon(Icons.edit, size: 16),
                    if (mark['MarkDate'] != null)
                      Text(
                        DateFormat('d. M. yyyy').format(mark['MarkDate']),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    if (mark['Weight'] != null)
                      Text(
                        '${AppLocalizations.of(context)!.weight}: ${mark['Weight']}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ),
          ],
          TextButton(
            onPressed: () async {
              final newMark = await showDialog<Map<String, dynamic>>(
                context: context,
                builder: (context) => const EditMarkDialog(),
              );
              if (!mounted || newMark == null) return;
              setState(() {
                _marks.insert(0, {
                  ...newMark,
                  'MarkDate': DateTime.now(),
                  'Caption': '',
                  'Theme': '',
                });
                _compute();
              });
            },
            child: Text(AppLocalizations.of(context)!.addMark),
          ),
          if (widget.note != '')
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
              child: Text(widget.note),
            ),
        ],
      ),
    );
  }
}
