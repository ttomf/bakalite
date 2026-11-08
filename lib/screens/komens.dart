import 'dart:convert';

import 'package:bakalite/api.dart';
import 'package:bakalite/cache/cache.dart';
import 'package:bakalite/config.dart';
import 'package:bakalite/exceptions.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/screens/wrapper.dart';
import 'package:bakalite/utils.dart';
import 'package:bakalite/widgets/message_card.dart';
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
  Map<String, Map<String, dynamic>>? _messageTypesParsed;

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
              : await api.fetch(
                  'komens/messages/$type',
                  method: 'POST',
                  body: jsonEncode({
                    'DateFrom': '2000-01-01T00:00:00.000',
                    'IncludeHidden': true,
                  }),
                ));

      if (!mounted) return;

      if (komensData != null) {
        setState(() {
          _messages[type] = komensData;
          _loaded[type] = true;
          _messagesParsed[type] = [
            for (final message in _messages[type]!['Messages'] ?? [])
              {
                'SentDate': parseTime(message['SentDate']),
                'Title': message['Title'],
                'Text': message['Text'],
                'SenderName': message['Sender']?['Name'],
                'Attachments': message['Attachments'],
                'Type':
                    _messageTypesParsed?['MessageTypes']?[message['Type']]?['Name'] ??
                    message['Type'],
              },
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

  Future<void> _load({
    bool useCache = true,
    bool throwNetwork = false,
    bool offline = false,
  }) async {
    try {
      final cached = useCache ? await cache.load('komens/message-types') : null;
      final komensData =
          cached?['data'] ??
          (offline ? null : await api.fetch('komens/message-types'));

      if (!mounted) return;

      if (komensData != null) {
        setState(() {
          _messages['types'] = komensData;
          _loaded['types'] = true;
          _messageTypesParsed = {
            'MessageTypes': {
              for (final type in _messages['types']['MessageTypes'])
                type['Abbreviation']: type,
            },
            'Recipients': {
              for (final recipient in _messages['types']['Recipients'])
                recipient['Code']: recipient,
            },
          };
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
          _load(useCache: false);
        }
      }
    } on BakaLiteException catch (e) {
      if (!mounted) return;
      setState(() {
        _error['types'] = true;
      });
      if (e.error == BakaLiteError.network && !throwNetwork) return;
      showError(context, e);
    }
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
        for (final type in ['received', 'sent', 'noticeboard'])
          _messagesParsed.isNotEmpty && _messagesParsed[type] != null
              ? ListView(
                  children: [
                    for (final message in _messagesParsed[type]!)
                      MessageCard(message),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
