import 'dart:convert';

import 'package:bakalite/api.dart';
import 'package:bakalite/data/cache/cache.dart';
import 'package:bakalite/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DevScreen extends StatefulWidget {
  const DevScreen({super.key});

  @override
  State<DevScreen> createState() => _DevScreenState();
}

class _DevScreenState extends State<DevScreen> {
  final endpointController = TextEditingController(text: '');
  String _response = '';
  String _method = 'GET';

  Future<void> send() async {
    try {
      final res = await api.request(endpointController.text, method: _method);
      setState(() {
        try {
          _response = const JsonEncoder.withIndent('  ')
              .convert(jsonDecode(res ?? ''));
        } on FormatException {
          _response = res ?? '';
        }
      });
    } on BakaLiteException catch (e) {
      setState(() {
        _response = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dev')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 4,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 4,
                    children: [
                      OutlinedButton(
                        child: const Text('Clear cache'),
                        onPressed: () => cache.clear(),
                      ),
                      OutlinedButton(
                        child: const Text('Show PackageInfo'),
                        onPressed: () async {
                          final packageInfo = await PackageInfo.fromPlatform();
                          setState(() {
                            _response = const JsonEncoder.withIndent('  ')
                                .convert(packageInfo.data);
                          });
                        },
                      ),
                      OutlinedButton(
                        child: const Text('Show accessToken'),
                        onPressed: () {
                          setState(() {
                            _response = api.accessToken.toString();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  spacing: 4,
                  children: [
                    DropdownMenu(
                      width: 80,
                      showTrailingIcon: false,
                      initialSelection: _method,
                      dropdownMenuEntries: [
                        for (final method in ['GET', 'POST', 'PUT'])
                          DropdownMenuEntry(label: method, value: method),
                      ],
                      onSelected: (value) {
                        if (value != null) {
                          _method = value;
                        }
                      },
                    ),
                    Expanded(
                      child: Autocomplete(
                        optionsBuilder: (text) {
                          const options = [
                            'absence/student',
                            'classbook',
                            'classbook/\$ID',
                            'classbook/lessonTags',
                            'events',
                            'events/my',
                            'events/public',
                            'gdpr/commissioner',
                            'gdpr/commissioner/send-objection',
                            'gdpr/commissioner/send-report',
                            'gdpr/commissioners',
                            'gdpr/consent',
                            'gdpr/consents/person',
                            'gdpr/consents/person/child',
                            'gdpr/consents/person/new',
                            'homeworks',
                            'homeworks/count-actual',
                            'komens/attachment/\$ID',
                            'komens/message',
                            'komens/message/\$ID',
                            'komens/message/\$ID/mark-as-read',
                            'komens/message-types',
                            'komens/message-types/edit',
                            'komens/message-types/reply',
                            'komens/messages/apology',
                            'komens/messages/noticeboard',
                            'komens/messages/noticeboard/unread',
                            'komens/messages/rating',
                            'komens/messages/received',
                            'komens/messages/received/\$ID',
                            'komens/messages/sent/\$ID',
                            'komens/messages/received/unread',
                            'komens/messages/sent',
                            'komens/rating-templates',
                            'lesson/\$ID/absence',
                            'lesson/\$ID/past',
                            'lesson/\$ID/studentsTimetable',
                            'login',
                            'logintoken',
                            'marking/atoms',
                            'marking/marks/\$ID',
                            'marks',
                            'marks/count-new',
                            'marks/final',
                            'marks/measures',
                            'marks/what-if',
                            'payments/classfund',
                            'payments/classfund/paymentsinfo',
                            'payments/classfund/summary',
                            'register-notification',
                            'subjects',
                            'subjects/themes/\$ID',
                            'substitutions',
                            'timetable/actual',
                            'timetable/permanent',
                            'unregister-user-notification',
                            'user',
                            'user/student-at-school',
                            'webmodule',
                          ];
                          return options.where(
                            (o) => o.toLowerCase().contains(
                              text.text.toLowerCase(),
                            ),
                          );
                        },
                        onSelected: (selection) {
                          endpointController.text = selection;
                        },
                        fieldViewBuilder:
                            (context, controller, focusNode, onFieldSubmitted) {
                              controller.text = endpointController.text;
                              controller.addListener(() {
                                endpointController.text = controller.text;
                              });

                              return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                decoration: const InputDecoration(
                                  labelText: 'Endpoint',
                                ),
                                keyboardType: TextInputType.url,
                              );
                            },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 64,
                  child: FilledButton(
                    child: const Text('Send request'),
                    onPressed: () {
                      send();
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).highlightColor,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: SelectableText(_response),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton.filled(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: _response));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
