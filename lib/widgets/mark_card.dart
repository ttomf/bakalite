import 'package:bakalite/lang/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MarkCard extends StatelessWidget {
  const MarkCard(this.mark, {super.key});

  final Map<String, dynamic> mark;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  child: Text(
                    mark['MarkText'],
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mark['SubjectName'],
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (mark['Caption']?.isNotEmpty ?? false)
                        SelectableText(mark['Caption']),
                      if (mark['Theme']?.isNotEmpty ?? false)
                        SelectableText(
                          mark['Theme'],
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Divider(
              height: 1,
              thickness: 1.5,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('d. M. yyyy').format(mark['MarkDate'])),
                Text(
                  '${AppLocalizations.of(context)!.weight}: ${mark['Weight']}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
