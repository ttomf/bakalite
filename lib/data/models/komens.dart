import 'dart:convert';

import 'package:bakalite/data/models/entity.dart';
import 'package:bakalite/utils.dart';

class Message({
  required final DateTime sentDate,
  required final String title,
  required final String text,
  required final Entity sender,
  required final List<Entity> attachments,
  required final String type,
});

class Komens({required final List<Message> messages}) {
  factory Komens.parse(String string) {
    final data = jsonDecode(string);

    final List<Message> messagesParsed = [
      for (final message in data['Messages'] ?? [])
        Message(
          sentDate: parseTime(
            safeString(message['SentDate'], def: '0000-01-01'),
          ),
          title: safeString(message['Title'], trim: true),
          text: safeString(message['Text'], trim: true),
          sender: Entity.parse(message['Sender'] ?? {}),
          attachments: [
            for (final attachment in message['Attachments'] ?? [])
              Entity.parse(attachment ?? {}),
          ],
          type: safeString(message['Type']),
        ),
    ];

    messagesParsed.sort((a, b) => b.sentDate.compareTo(a.sentDate));

    return Komens(messages: messagesParsed);
  }
}
