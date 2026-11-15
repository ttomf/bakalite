import 'package:bakalite/data/models/timetable.dart';
import 'package:bakalite/widgets/subject_sheet.dart';
import 'package:flutter/material.dart';

class SubjectCard extends StatelessWidget {
  const SubjectCard(this.atom, {super.key});

  final Atom atom;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final isNow =
        atom.date != null &&
        atom.date!.year == now.year &&
        atom.date!.month == now.month &&
        atom.date!.day == now.day &&
        atom.start < nowMinutes &&
        nowMinutes < (atom.start + atom.duration);

    return Card(
      shape: RoundedRectangleBorder(
        side: isNow
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
            : BorderSide.none,
        borderRadius: BorderRadius.circular(4),
      ),
      color: atom.change != null
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
            builder: (context) => SubjectSheet(atom),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  atom.groups.map((group) => group.abbrev).join(', '),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const Spacer(),
              if ((atom.subject?.abbrev ?? '').isNotEmpty)
                Text(
                  atom.subject!.abbrev,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              if ((atom.change?.typeAbbrev ?? '').isNotEmpty)
                Text(
                  atom.change!.typeAbbrev,
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
                    if ((atom.teacher?.abbrev ?? '').isNotEmpty)
                      Text(atom.teacher!.abbrev),
                    if ((atom.room?.abbrev ?? '').isNotEmpty)
                      Text(atom.room!.abbrev),
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
