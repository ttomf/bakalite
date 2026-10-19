import 'package:bakalite/lang/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeworkCard extends StatefulWidget {
  const HomeworkCard({
    super.key,
    required this.subject,
    required this.content,
    required this.dateStart,
    required this.dateEnd,
    required this.done,
    this.finished,
    this.onFinishedChange,
  });

  final String subject;
  final String content;
  final DateTime dateStart;
  final DateTime dateEnd;
  final bool done;
  final bool? finished;
  final Future<bool> Function(bool)? onFinishedChange;

  @override
  State<HomeworkCard> createState() => _HomeworkCardState();
}

class _HomeworkCardState extends State<HomeworkCard> {
  bool? finished = false;

  @override
  void initState() {
    finished = widget.finished;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final remainingDays =
        (widget.dateEnd.difference(DateTime.now()).inHours / 24).ceil();
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                        widget.subject,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SelectableText(widget.content),
                    ],
                  ),
                ),
                if (!widget.done)
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
            if (widget.done ||
                widget.dateEnd
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
                        widget.dateEnd.difference(widget.dateStart).inDays,
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
                        ).format(widget.dateStart),
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
                        ).format(widget.dateEnd),
                      ),
                    ],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.days(remainingDays),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: remainingDays <= 2 && remainingDays > 0
                        ? Colors.red[700]
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
