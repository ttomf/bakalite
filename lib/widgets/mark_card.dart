import 'package:bakalite/lang/app_localizations.dart';
import 'package:flutter/material.dart';

class MarkCard extends StatelessWidget {
  const MarkCard({
    super.key,
    required this.mark,
    required this.weight,
    required this.subject,
    required this.date,
    this.caption = '',
    this.theme = '',
  });

  final String mark;
  final String weight;
  final String subject;
  final String date;
  final String caption;
  final String theme;

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
                SizedBox(
                  width: 50,
                  child: Text(
                    mark,
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
                        subject,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (caption.isNotEmpty) Text(caption),
                      if (theme.isNotEmpty)
                        Text(
                          theme,
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
                Text(date, style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  AppLocalizations.of(context)!.weight(weight),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
