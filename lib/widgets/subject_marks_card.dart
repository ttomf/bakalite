import 'package:bakalite/lang/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubjectMarksCard extends StatelessWidget {
  const SubjectMarksCard({
    super.key,
    required this.subject,
    required this.marks,
    required this.average,
    required this.note,
  });

  final String subject;
  final List<Map<String, dynamic>> marks;
  final String average;
  final String note;

  @override
  Widget build(BuildContext context) {
    int totalWeight = 0;
    for (final mark in marks) {
      totalWeight += int.tryParse(mark['Weight']) ?? 0;
    }
    return Card(
      child: ExpansionTile(
        key: PageStorageKey(subject),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject,
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
                        text: average,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                if (totalWeight != 0)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '${AppLocalizations.of(context)!.totalWeight}: ',
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                        TextSpan(
                          text: totalWeight.toString(),
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
                        text: marks.length.toString(),
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
          for (final mark in marks.reversed) ...[
            Divider(
              height: 0,
              color: Theme.of(context).colorScheme.primary,
              indent: 12,
              endIndent: 12,
            ),
            ListTile(
              leading: SizedBox(
                width: 24,
                child: Text(
                  mark['MarkText'],
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              title: mark['Caption'] != '' ? Text(mark['Caption']) : null,
              subtitle: mark['Theme'] != '' ? Text(mark['Theme']) : null,
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('d. M. yyyy')
                        .format(DateTime.parse(mark['MarkDate'])),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.weight}: ${mark['Weight']}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
          if (note != '')
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
              child: Text(note),
            ),
        ],
      ),
    );
  }
}
