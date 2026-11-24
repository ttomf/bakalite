import 'package:bakalite/data/models/timetable.dart';
import 'package:bakalite/widgets/subject_sheet.dart';
import 'package:material_ui/material_ui.dart';

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
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  atom.groups.map((group) => group.abbrev).join(', '),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      Flexible(
                        child: Wrap(
                          direction: Axis.vertical,
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runSpacing: 8,
                          children: [
                            if ((atom.teacher?.abbrev ?? '').isNotEmpty)
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(atom.teacher!.abbrev),
                              ),
                            if ((atom.room?.abbrev ?? '').isNotEmpty)
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(atom.room!.abbrev),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (atom.homework.isNotEmpty && !atom.permanent)
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Card(
                    elevation: 0,
                    color: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        'H',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
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
