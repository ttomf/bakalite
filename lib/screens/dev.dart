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
                TextField(
                  controller: endpointController,
                  decoration: const InputDecoration(labelText: 'Endpoint'),
                  keyboardType: TextInputType.url,
                  onSubmitted: (val) {
                    send();
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: SingleChildScrollView(
                              child: SelectableText(responseJson),
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
