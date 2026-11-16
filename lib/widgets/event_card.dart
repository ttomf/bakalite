import 'package:bakalite/data/models/events.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  const EventCard(this.event, {super.key});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (event.description.isNotEmpty) Text(event.description),
            if (event.eventType.name.isNotEmpty) Text(event.eventType.name),
            const SizedBox(height: 8),
            Divider(
              height: 1,
              thickness: 1.5,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            if (event.classes.isNotEmpty)
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${AppLocalizations.of(context)!.classes}: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: event.classes
                          .map((entity) => entity.abbrev)
                          .join(', '),
                    ),
                  ],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            if (event.teachers.isNotEmpty)
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${AppLocalizations.of(context)!.teachers}: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: event.teachers
                          .map((entity) => entity.name)
                          .join(', '),
                    ),
                  ],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            if (event.rooms.isNotEmpty)
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${AppLocalizations.of(context)!.rooms}: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: event.rooms
                          .map((entity) => entity.abbrev)
                          .join(', '),
                    ),
                  ],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            Text(
              '${DateFormat('EE d. M. yyyy H:mm', Localizations.localeOf(context).languageCode).format(event.interval.start)} – ${DateFormat('EE d. M. yyyy H:mm', Localizations.localeOf(context).languageCode).format(event.interval.end)}',
            ),
          ],
        ),
      ),
    );
  }
}
