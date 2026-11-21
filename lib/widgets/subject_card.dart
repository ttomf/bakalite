import 'package:bakalite/data/models/timetable.dart';
import 'package:bakalite/widgets/subject_sheet.dart';
import 'package:flutter/material.dart';

class SubjectCard extends StatelessWidget {
  const SubjectCard(this.atom, {super.key});

  final Atom atom;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: atom.isNow
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
              if (atom.homework.isNotEmpty)
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'H',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
