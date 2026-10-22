import 'package:bakalite/api.dart';
import 'package:bakalite/exceptions.dart';
import 'package:bakalite/utils.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';

class AttachmentCard extends StatelessWidget {
  const AttachmentCard({
    super.key,
    required this.name,
    required this.id,
    required this.mime,
  });

  final String name;
  final String id;
  final String mime;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: Theme.of(context).cardColor,
      elevation: 0,
      child: InkWell(
        onTap: () async {
          try {
            final res = await api.requestBytes('komens/attachment/$id');
            await FileSaver.instance.saveAs(
              name: name,
              bytes: res,
              mimeType: MimeType.get(mime) ?? MimeType.other,
            );
          } on BakaLiteException catch (e) {
            if (!context.mounted) return;
            showError(context, e);
          }
        },
        child: Padding(padding: const EdgeInsets.all(12), child: Text(name)),
      ),
    );
  }
}
