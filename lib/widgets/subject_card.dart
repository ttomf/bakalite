import 'package:bakalite/widgets/subject_sheet.dart';
import 'package:flutter/material.dart';

class SubjectCard extends StatelessWidget {
  const SubjectCard(this.subject, {super.key});

  final Map<String, dynamic> subject;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
            builder: (context) {
              return SubjectSheet(subject);
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxHeight < 100;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (subject['Subject'][0].isNotEmpty)
                          Text(
                            subject['Subject'][0],
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        if ((subject['Change']?['TypeAbbrev'] ?? '').isNotEmpty)
                          Text(
                            subject['Change']['TypeAbbrev'],
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        isCompact
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 10,
                                children: [
                                  if (subject['Teacher'][0].isNotEmpty)
                                    Text(subject['Teacher'][0]),
                                  if (subject['Room'][0].isNotEmpty)
                                    Text(subject['Room'][0]),
                                ],
                              )
                            : Column(
                                children: [
                                  if (subject['Teacher'][0].isNotEmpty)
                                    Text(subject['Teacher'][0]),
                                  if (subject['Room'][0].isNotEmpty)
                                    Text(subject['Room'][0]),
                                ],
                              ),
                      ],
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  subject['Groups'].map((group) => group[0]).join(', '),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
