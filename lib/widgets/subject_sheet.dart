import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/widgets/fields_table.dart';
import 'package:flutter/material.dart';

class SubjectSheet extends StatelessWidget {
  const SubjectSheet(this.subject, {super.key});

  final Map<String, dynamic> subject;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 24,
          children: [
            SelectableText(
              subject['Subject']?[1] ?? '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            FieldsTable(
              values: {
                AppLocalizations.of(context)!.group: (subject['Groups'] ?? [])
                    .where((group) => group != null)
                    .map((group) => group[0])
                    .join(', '),
                AppLocalizations.of(context)!.room: subject['Room'] != null
                    ? '${subject['Room'][1]} (${subject['Room'][0]})'
                    : null,
                AppLocalizations.of(context)!
                    .teacher: subject['Teacher'] != null
                    ? '${subject['Teacher'][1]} (${subject['Teacher'][0]})'
                    : null,
                AppLocalizations.of(context)!.lessonTopic: subject['Theme'],
                AppLocalizations.of(context)!.change: subject['Change'] != null
                    ? subject['Change']['Description']
                    : null,
              },
            ),
          ],
        ),
      ),
    );
  }
}
