import 'package:bakalite/data/models/homework.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/widgets/attachment_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeworkCard extends StatelessWidget {
  const HomeworkCard(this.homework, {super.key, this.onFinishedChange});

  final HomeworkItem homework;
  final Future<bool> Function(bool)? onFinishedChange;

  @override
  Widget build(BuildContext context) {
    final int remainingDays =
        (homework.dateEnd.difference(DateTime.now()).inHours / 24).ceil();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        homework.subject.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SelectableText(homework.content),
                    ],
                  ),
                ),
                if (!homework.closed)
                  Checkbox(
                    value: homework.finished,
                    onChanged: (val) => onFinishedChange?.call(val ?? false),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (homework.closed ||
                homework.dateEnd
                    .add(const Duration(days: 1))
                    .isBefore(DateTime.now())) ...[
              Divider(
                height: 1,
                thickness: 1.5,
                color: Theme.of(context).colorScheme.primary,
              ),
            ] else ...[
              LinearProgressIndicator(
                value:
                    1 -
                    remainingDays /
                        homework.dateEnd.difference(homework.dateStart).inDays,
                stopIndicatorRadius: 0,
                trackGap: 0,
                minHeight: 5,
                color: Colors.red[700],
                year2023: false, // Deprecated, but still defaults to true
              ),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${AppLocalizations.of(context)!.start}: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: DateFormat(
                          'EE d. M. yyyy',
                          Localizations.localeOf(context).languageCode,
                        ).format(homework.dateStart),
                      ),
                    ],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${AppLocalizations.of(context)!.end}: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: DateFormat(
                          'EE d. M. yyyy',
                          Localizations.localeOf(context).languageCode,
                        ).format(homework.dateEnd),
                      ),
                    ],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.days(remainingDays),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: remainingDays <= 2 && remainingDays >= 0
                        ? Colors.red[700]
                        : remainingDays <= 5 && remainingDays > 2
                        ? Colors.orange[800]
                        : null,
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final attachment in homework.attachments)
                    AttachmentCard(
                      id: attachment.id,
                      name: attachment.name,
                      mime: attachment.type,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
