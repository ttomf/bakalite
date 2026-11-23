import 'dart:convert';

import 'package:bakalite/data/models/entity.dart';
import 'package:bakalite/utils.dart';

class Message({
  required final String id,
  required final DateTime sentDate,
  required final String title,
  required final String text,
  required final Entity sender,
  required final String relevantName,
  required final List<Entity> attachments,
  required final String type,
  required var bool read,
  required var bool confirmed,
  required final bool canConfirm,
});

class MessageType({required final String abbrev, required final String name});

class Komens({required final List<Message> messages}) {
  factory Komens.parse(String string) {
    final data = jsonDecode(string);

    final List<Message> messagesParsed = [
      for (final message in data['Messages'] ?? [])
        Message(
          id: safeString(message['Id']),
          sentDate: parseTime(
            safeString(message['SentDate'], def: '0000-01-01'),
          ),
          title: safeString(message['Title'], trim: true),
          text: safeString(message['Text'], trim: true),
          sender: Entity.parse(message['Sender'] ?? {}),
          relevantName: safeString(message['RelevantName'], trim: true),
          attachments: [
            for (final attachment in message['Attachments'] ?? [])
              Entity.parse(attachment ?? {}),
          ],
          type: safeString(message['Type']),
          read: message['Read'] ?? false,
          confirmed: message['Confirmed'] ?? false,
          canConfirm: message['CanConfirm'] ?? false,
        ),
    ];

    messagesParsed.sort((a, b) => b.sentDate.compareTo(a.sentDate));

    return Komens(messages: messagesParsed);
  }
}

class MessageTypes({required final Map<String, MessageType> types}) {
  factory MessageTypes.parse(String string) {
    final data = jsonDecode(string);

    final Map<String, MessageType> typesParsed = {
      for (final message in data['MessageTypes'] ?? [])
        safeString(message['Abbreviation']): MessageType(
          abbrev: safeString(message['Abbreviation']),
          name: safeString(message['Name']),
        ),
    };

    return MessageTypes(types: typesParsed);
  }
}
