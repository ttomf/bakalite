import 'package:bakalite/data/models/timetable.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/widgets/fields_table.dart';
import 'package:flutter/material.dart';

class SubjectSheet extends StatelessWidget {
  const SubjectSheet(this.subject, {super.key});

  final Atom subject;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 24,
            children: [
              Text(
                subject.subject?.name ?? subject.change?.typeName ?? '',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              FieldsTable(
                values: {
                  AppLocalizations.of(context)!.group: subject.groups
                      .map((group) => group.abbrev)
                      .join(', '),
                  AppLocalizations.of(context)!.room: subject.room != null
                      ? '${subject.room?.name} (${subject.room?.abbrev})'
                      : null,
                  AppLocalizations.of(context)!.teacher: subject.teacher != null
                      ? '${subject.teacher?.name} (${subject.teacher?.abbrev})'
                      : null,
                  AppLocalizations.of(context)!.lessonTopic: subject.theme,
                  AppLocalizations.of(context)!.homework: subject.homework
                      .map((homework) => homework.text)
                      .join(', '),
                  AppLocalizations.of(context)!.change:
                      subject.change?.description,
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
