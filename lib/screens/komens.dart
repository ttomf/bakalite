import 'package:bakalite/data/data.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/screens/wrapper.dart';
import 'package:bakalite/utils.dart';
import 'package:bakalite/widgets/message_card.dart';
import 'package:material_ui/material_ui.dart';

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
      listenable: Listenable.merge([
        Data.komensRes.komens,
        Data.komensRes.messageTypes,
      ]),
      builder: (context, _) {
        return Wrapper(
          title: AppLocalizations.of(context)!.komens,
          subtitle: getCacheInfo(
            context,
            Data.komensRes.komens.cacheTimestamp['komens/messages/received'] ??
                Data.komensRes.komens.cacheTimestamp['komens/messages/sent'] ??
                Data
                    .komensRes
                    .komens
                    .cacheTimestamp['komens/messages/noticeboard'] ??
                Data
                    .komensRes
                    .messageTypes
                    .cacheTimestamp['komens/message-types'],
            Data.komensRes.komens.loaded['komens/messages/received'] != null &&
                Data.komensRes.komens.loaded['komens/messages/sent'] != null &&
                Data.komensRes.komens.loaded['komens/messages/noticeboard'] !=
                    null &&
                Data.komensRes.messageTypes.loaded['komens/message-types'] !=
                    null,
            Data.komensRes.komens.error['komens/messages/received'] != null ||
                Data.komensRes.komens.error['komens/messages/sent'] != null ||
                Data.komensRes.komens.error['komens/messages/noticeboard'] !=
                        null &&
                    Data.komensRes.messageTypes.error['komens/message-types'] !=
                        null,
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
                        for (final message in type) MessageCard(message),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }
}
