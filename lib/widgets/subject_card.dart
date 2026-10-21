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
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                subject['Subject'][0],
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(subject['Room'][0]),
              Text(subject['Teacher'][0]),
            ],
          ),
        ),
      ),
    );
  }
}
