import 'package:bakalite/data/models/entity.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class SubjectCard extends StatelessWidget {
  const SubjectCard(this.subject, {super.key});

  final ({Entity subject, List<Entity> teachers}) subject;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: subject.subject.name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' (${subject.subject.abbrev})',
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              for (final teacher in subject.teachers)
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${AppLocalizations.of(context)!.teacher}: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '${teacher.name} (${teacher.abbrev})'),
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
