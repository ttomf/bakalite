import 'package:bakalite/data/data.dart';
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
  @override
  void initState() {
    super.initState();
    Data.loadKomens();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Data.komensRes,
      builder: (context, _) {
        return Wrapper(
          title: AppLocalizations.of(context)!.komens,
          subtitle: getCacheInfo(
            context,
            Data.komensRes.cacheTimestamp['komens/messages/received'] ??
                Data.komensRes.cacheTimestamp['komens/messages/sent'] ??
                Data.komensRes.cacheTimestamp['komens/messages/noticeboard'],
            Data.komensRes.loaded['komens/messages/received'] != null &&
                Data.komensRes.loaded['komens/messages/sent'] != null &&
                Data.komensRes.loaded['komens/messages/noticeboard'] != null,
            Data.komensRes.error['komens/messages/received'] != null ||
                Data.komensRes.error['komens/messages/sent'] != null ||
                Data.komensRes.error['komens/messages/noticeboard'] != null,
          ),
          tabs: [
            AppLocalizations.of(context)!.received,
            AppLocalizations.of(context)!.sent,
            AppLocalizations.of(context)!.noticeboard,
          ],
          onRefresh: () {
            Data.loadKomens(force: true);
          },
          children: [
            for (final type in [
              Data.komens.received,
              Data.komens.sent,
              Data.komens.noticeboard,
            ])
              type != null
                  ? ListView(
                      children: [
                        for (final message in type.messages)
                          MessageCard(message),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }
}
