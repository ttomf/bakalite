import 'package:bakalite/widgets/subject_sheet.dart';
import 'package:flutter/material.dart';

class SubjectCard extends StatelessWidget {
  const SubjectCard(this.subject, {super.key});

  final Map<String, dynamic> subject;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: (subject['Now'] ?? false)
            ? BorderSide(color: Theme.of(context).colorScheme.primary)
            : BorderSide.none,
        borderRadius: BorderRadius.circular(4),
      ),
      color: subject['Change'] != null
          ? Theme.of(context).colorScheme.errorContainer
          : null,
      margin: const EdgeInsets.all(1),
      elevation: 1,
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            showDragHandle: true,
            context: context,
            useSafeArea: true,
            constraints: const BoxConstraints(minWidth: double.infinity),
            builder: (context) => SubjectSheet(subject),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  (subject['Groups'] ?? [])
                      .where((group) => group != null)
                      .map((group) => group[0])
                      .join(', '),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const Spacer(),
              if ((subject['Subject']?[0] ?? '').isNotEmpty)
                Text(
                  subject['Subject'][0],
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              if ((subject['Change']?['TypeAbbrev'] ?? '').isNotEmpty)
                Text(
                  subject['Change']['TypeAbbrev'],
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              Expanded(
                flex: 3,
                child: Wrap(
                  direction: Axis.vertical,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 8,
                  children: [
                    if ((subject['Teacher']?[0] ?? '').isNotEmpty)
                      Text(subject['Teacher'][0]),
                    if ((subject['Room']?[0] ?? '').isNotEmpty)
                      Text(subject['Room'][0]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
