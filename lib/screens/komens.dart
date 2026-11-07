import 'package:bakalite/api.dart';
import 'package:bakalite/cache/cache.dart';
import 'package:bakalite/config.dart';
import 'package:bakalite/exceptions.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/screens/wrapper.dart';
import 'package:bakalite/utils.dart';
import 'package:flutter/material.dart';

class KomensScreen extends StatefulWidget {
  const KomensScreen({super.key});

  @override
  State<KomensScreen> createState() => _KomensScreenState();
}

class _KomensScreenState extends State<KomensScreen> {
  DateTime? _cacheTimestamp;
  final Map<String, dynamic> _messages = {};
  final Map<String, List<Map<String, dynamic>>> _messagesParsed = {};

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
      final cached = useCache
          ? await cache.load('komens/messages/$type')
          : null;
      final komensData =
          cached?['data'] ??
          (offline
              ? null
              : await api.fetch('komens/messages/$type', method: 'POST'));

      if (!mounted) return;

      if (komensData != null) {
        setState(() {
          _messages[type] = komensData;
          _loaded[type] = true;
          _messagesParsed[type] = [
            for (final message in _messages[type]!['Messages'] ?? [])
              {...message, 'SentDate': parseTime(message['SentDate'])},
          ];
          _messagesParsed[type]!.sort(
            (a, b) => b['SentDate'].compareTo(a['SentDate']),
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

  void _load({
    bool useCache = true,
    bool throwNetwork = false,
    bool offline = false,
  }) {
    for (final type in ['received', 'sent', 'noticeboard']) {
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
      title: AppLocalizations.of(context)!.komens,
      subtitle: getCacheInfo(
        context,
        _cacheTimestamp,
        _loaded.isNotEmpty
            ? _loaded.values.every((element) => element == true)
            : false,
        _error.values.any((element) => element == true),
      ),
      tabs: [
        AppLocalizations.of(context)!.received,
        AppLocalizations.of(context)!.sent,
        AppLocalizations.of(context)!.noticeboard,
      ],
      onRefresh: () {
        setState(() {
          _loaded.clear();
          _messages.clear();
        });
        _load(useCache: false, throwNetwork: true);
      },
      children: [
        _messagesParsed.isNotEmpty && _messagesParsed['received'] != null
            ? ListView(
                children: [
                  for (final message in _messagesParsed['received']!)
                    Card(child: Text(message['Text'])),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
        _messagesParsed.isNotEmpty && _messagesParsed['sent'] != null
            ? ListView(
                children: [
                  for (final message in _messagesParsed['sent']!)
                    Card(child: Text(message['Text'])),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
        _messagesParsed.isNotEmpty && _messagesParsed['noticeboard'] != null
            ? ListView(
                children: [
                  for (final message in _messagesParsed['noticeboard']!)
                    Card(child: Text(message['Text'])),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
