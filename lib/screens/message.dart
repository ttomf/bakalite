import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/widgets/attachment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map message = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.message)),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SelectionArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message['SenderName'],
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      message['Title'],
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      DateFormat('d. M. yyyy H:mm').format(message['SentDate']),
                    ),
                    if (message['Attachments'] != null)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (final attachment in message['Attachments'])
                              AttachmentCard(
                                id: attachment['Id'],
                                name: attachment['Name'],
                                mime: attachment['Type'],
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Divider(
              height: 1,
              thickness: 1.5,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SelectionArea(
                      child: HtmlWidget(
                        message['Text'],
                        onTapUrl: (url) {
                          return launchUrl(Uri.parse(url));
                        },
                        textStyle: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
