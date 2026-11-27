import 'package:bakalite/data/models/themes.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

class ThemeCard extends StatelessWidget {
  const ThemeCard(this.theme, {super.key});

  final SubjectTheme theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              theme.theme,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${AppLocalizations.of(context)!.hour}: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: theme.lessonLabel),
                ],
              ),
            ),
            if (theme.note.isNotEmpty)
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${AppLocalizations.of(context)!.note}: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: theme.note),
                  ],
                ),
              ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${AppLocalizations.of(context)!.date}: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: DateFormat('d. M. yyyy').format(theme.date)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
