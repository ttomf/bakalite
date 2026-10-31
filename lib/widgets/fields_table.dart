import 'package:flutter/material.dart';

class FieldsTable extends StatelessWidget {
  const FieldsTable({super.key, required this.values});

  final Map<String, String?> values;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Table(
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children: [
          for (final entry in values.entries)
            if (entry.value != null && entry.value != '')
              TableRow(
                children: [
                  Text(
                    entry.key,
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(width: 8),
                  SelectableText(
                    entry.value!,
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
