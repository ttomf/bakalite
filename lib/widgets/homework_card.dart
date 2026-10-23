import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/widgets/attachment_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeworkCard extends StatefulWidget {
  const HomeworkCard(this.homework, {super.key, this.onFinishedChange});

  final Map<String, dynamic> homework;
  final Future<bool> Function(bool)? onFinishedChange;

  @override
  State<HomeworkCard> createState() => _HomeworkCardState();
}

class _HomeworkCardState extends State<HomeworkCard> {
  bool? finished = false;

  @override
  void initState() {
    finished = widget.homework['Finished'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int remainingDays =
        (widget.homework['DateEnd'].difference(DateTime.now()).inHours / 24)
            .ceil();
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
                        widget.homework['SubjectName'],
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SelectableText(widget.homework['Content']),
                    ],
                  ),
                ),
                if (!widget.homework['Closed'])
                  Checkbox(
                    value: finished,
                    onChanged: (val) async {
                      if (await widget.onFinishedChange?.call(val ?? false) ??
                          false) {
                        setState(() {
                          finished = val;
                        });
                      }
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (widget.homework['Closed'] ||
                widget.homework['DateEnd']
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
                        widget.homework['DateEnd']
                            .difference(widget.homework['DateStart'])
                            .inDays,
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
                        ).format(widget.homework['DateStart']),
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
                        ).format(widget.homework['DateEnd']),
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
            if (widget.homework['Attachments'] != null)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final attachment in widget.homework['Attachments'])
                      AttachmentCard(
                        id: attachment['Id'],
                        name: attachment['Name'],
                        mime: attachment['Type'],
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
