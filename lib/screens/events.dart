import 'package:bakalite/api.dart';
import 'package:bakalite/cache/cache.dart';
import 'package:bakalite/config.dart';
import 'package:bakalite/exceptions.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/screens/wrapper.dart';
import 'package:bakalite/utils.dart';
import 'package:flutter/material.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  DateTime? _cacheTimestamp;
  final Map<String, dynamic> _events = {};
  final Map<String, List<Map<String, dynamic>>> _eventsParsed = {};

  final Map<String, bool> _loaded = {};
  final Map<String, bool> _error = {};

  @override
  void initState() {
    super.initState();
    _load(offline: !Config.autoRefresh.value);
  }

  Future<void> _loadOne(
    String type, {
    bool useCache = true,
    bool throwNetwork = false,
    bool offline = false,
  }) async {
    _error[type] = false;
    try {
      final cached = useCache ? await cache.load('events/$type') : null;
      final eventsData =
          cached?['data'] ?? (offline ? null : await api.fetch('events/$type'));

      if (!mounted) return;

      if (eventsData != null) {
        setState(() {
          _events[type] = eventsData;
          _loaded[type] = true;
          _eventsParsed[type] = [
            for (final event in _events[type]!['Events'] ?? [])
              {
                ...event,
                'SortingTime': parseTime(event['Times'].first['StartTime']),
              },
          ];
          _eventsParsed[type]!.sort(
            (a, b) => a['SortingTime'].compareTo(b['SortingTime']),
          );
        });
        if (cached == null) {
          setState(() {
            _cacheTimestamp = null;
          });
        }
      }
      if (cached != null) {
        setState(() {
          _cacheTimestamp = DateTime.fromMillisecondsSinceEpoch(
            cached['timestamp'],
          );
        });
        if (!offline) {
          _loadOne(type, useCache: false);
        }
      }
    } on BakaLiteException catch (e) {
      if (!mounted) return;
      setState(() {
        _error[type] = true;
      });
      if (e.error == BakaLiteError.network && !throwNetwork) return;
      showError(context, e);
    }
  }

  Future<void> _load({
    bool useCache = true,
    bool throwNetwork = false,
    bool offline = false,
  }) async {
    for (final type in ['', 'my', 'public']) {
      _loadOne(
        type,
        useCache: useCache,
        throwNetwork: throwNetwork,
        offline: offline,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: AppLocalizations.of(context)!.events,
      subtitle: getCacheInfo(
        context,
        _cacheTimestamp,
        _loaded.isNotEmpty
            ? _loaded.values.every((element) => element == true)
            : false,
        _error.values.any((element) => element == true),
      ),
      tabs: [
        AppLocalizations.of(context)!.all,
        AppLocalizations.of(context)!.my,
        AppLocalizations.of(context)!.public,
      ],
      onRefresh: () {
        setState(() {
          _loaded.clear();
          _events.clear();
        });
        _load(useCache: false, throwNetwork: true);
      },
      children: [
        for (final type in ['', 'my', 'public'])
          _eventsParsed[type] != null
              ? ListView(
                  children: [
                    for (final event in _eventsParsed[type]!)
                      Card(child: Text(event.toString())),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
