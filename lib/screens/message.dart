import 'package:bakalite/api.dart';
import 'package:bakalite/data/data.dart';
import 'package:bakalite/data/models/komens.dart';
import 'package:bakalite/exceptions.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/utils.dart';
import 'package:bakalite/widgets/attachment_card.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Message message =
        ModalRoute.of(context)!.settings.arguments as Message;

    return ListenableBuilder(
      listenable: Data.komensRes.komens,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: Text(AppLocalizations.of(context)!.message)),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SelectionArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.relevantName,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          message.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          DateFormat('d. M. yyyy H:mm')
                              .format(message.sentDate),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (final attachment in message.attachments)
                                AttachmentCard(
                                  id: attachment.id,
                                  name: attachment.name,
                                  mime: attachment.type,
                                ),
                            ],
                          ),
                        ),
                        if (!message.read)
                          OutlinedButton(
                            child: Text(
                              AppLocalizations.of(context)!.markAsRead,
                            ),
                            onPressed: () async {
                              try {
                                await api.request(
                                  'komens/message/${message.id}/mark-as-read',
                                  method: 'PUT',
                                );

                                message.read = true;
                                Data.komensRes.komens.notify();
                              } on BakaLiteException catch (e) {
                                if (!context.mounted) return;
                                showError(context, e);
                              }
                            },
                          ),
                        if (!message.confirmed && message.canConfirm)
                          OutlinedButton(
                            child: Text(AppLocalizations.of(context)!.confirm),
                            onPressed: () async {
                              try {
                                await api.request(
                                  'komens/message/${message.id}/mark-as-confirmed',
                                  method: 'PUT',
                                );

                                message.confirmed = true;
                                Data.komensRes.komens.notify();
                              } on BakaLiteException catch (e) {
                                if (!context.mounted) return;
                                showError(context, e);
                              }
                            },
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
                            message.text,
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
      },
    );
  }
}
