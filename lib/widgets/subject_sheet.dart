import 'package:flutter/material.dart';

class SubjectSheet extends StatelessWidget {
  const SubjectSheet(this.subject, {super.key});

  final Map<String, dynamic> subject;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (context) {
        return SafeArea(
          child: Column(
            children: [
              Text(
                subject['Subject'][1],
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                subject['Teacher'][1],
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                '${subject['Room'][0]} ${subject['Room'][1]}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                subject['Theme'] ?? '',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                subject['Change']?['Description'] ?? '',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                subject['Groups'].map((group) => group[0]).join(', '),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        );
      },
      onClosing: () {},
    );
  }
}
