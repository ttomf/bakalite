import 'package:bakalite/data/data.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/screens/wrapper.dart';
import 'package:bakalite/utils.dart';
import 'package:bakalite/widgets/event_card.dart';
import 'package:flutter/material.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  void initState() {
    super.initState();
    Data.loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Data.eventsRes,
      builder: (context, _) {
        return Wrapper(
          title: AppLocalizations.of(context)!.events,
          subtitle: getCacheInfo(
            context,
            Data.eventsRes.cacheTimestamp['events'] ??
                Data.eventsRes.cacheTimestamp['events/my'] ??
                Data.eventsRes.cacheTimestamp['events/public'],
            Data.eventsRes.loaded['events'] != null &&
                Data.eventsRes.loaded['events/my'] != null &&
                Data.eventsRes.loaded['events/public'] != null,
            Data.eventsRes.error['events'] != null ||
                Data.eventsRes.error['events/my'] != null ||
                Data.eventsRes.error['events/public'] != null,
          ),
          tabs: [
            AppLocalizations.of(context)!.all,
            AppLocalizations.of(context)!.my,
            AppLocalizations.of(context)!.public,
          ],
          onRefresh: () {
            Data.loadEvents(force: true);
          },
          children: [
            for (final type in [
              Data.events.all,
              Data.events.my,
              Data.events.public,
            ])
              type != null
                  ? ListView(
                      children: [for (final event in type) EventCard(event)],
                    )
                  : const Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }
}
