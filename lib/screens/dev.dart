import 'dart:convert';

import 'package:bakalite/api.dart';
import 'package:bakalite/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DevScreen extends StatefulWidget {
  const DevScreen({super.key});

  @override
  State<DevScreen> createState() => _DevScreenState();
}

class _DevScreenState extends State<DevScreen> {
  final endpointController = TextEditingController(text: '');
  String responseJson = '';
  IconData copyIcon = Icons.copy;

  Future<void> send() async {
    try {
      final res = await api.fetch(endpointController.text);
      setState(() {
        responseJson = const JsonEncoder.withIndent('  ').convert(res);
      });
    } on BakaLiteException catch (e) {
      setState(() {
        responseJson = e.toString();
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
              spacing: 16,
              children: [
                Autocomplete<String>(
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
                      (o) => o.toLowerCase().contains(text.text.toLowerCase()),
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
                SizedBox(
                  width: double.maxFinite,
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
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: double.maxFinite,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: SelectableText(responseJson),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton.filled(
                              icon: Icon(copyIcon),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: responseJson),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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
