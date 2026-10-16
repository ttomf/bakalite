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
  });

  final String subject;
  final String content;
  final DateTime dateStart;
  final DateTime dateEnd;
  final bool done;
  final bool? finished;

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

  // TODO timeline
  @override
  Widget build(BuildContext context) {
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
                      Text(widget.content),
                    ],
                  ),
                ),
                if (!widget.done)
                  Checkbox(value: finished, onChanged: (val) {}),
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
                Text(
                  '${AppLocalizations.of(context)!.start}: ${DateFormat('d. M. yyyy').format(widget.dateStart)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${AppLocalizations.of(context)!.end}: ${DateFormat('d. M. yyyy').format(widget.dateEnd)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (!widget.done)
                  Text(
                    '${(widget.dateEnd.difference(DateTime.now()).inHours / 24).ceil()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
