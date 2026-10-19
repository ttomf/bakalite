import 'package:flutter/material.dart';

class SubjectCard extends StatelessWidget {
  const SubjectCard({
    super.key,
    this.subject,
    this.room,
    this.teacher,
    this.changeType,
    this.change,
  });

  final String? subject;
  final String? room;
  final String? teacher;
  final String? changeType;
  final String? change;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(subject ?? ''),
            Text(room ?? ''),
            Text(teacher ?? ''),
            Text(changeType ?? ''),
            Text(change ?? ''),
          ],
        ),
      ),
    );
  }
}
