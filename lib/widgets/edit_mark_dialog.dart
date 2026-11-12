import 'package:bakalite/data/models/marks.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:flutter/material.dart';

class EditMarkDialog extends StatefulWidget {
  const EditMarkDialog({super.key, this.mark});

  final Mark? mark;

  @override
  State<EditMarkDialog> createState() => _EditMarkDialogState();
}

class _EditMarkDialogState extends State<EditMarkDialog> {
  String? _mark;
  int? _weight;

  @override
  void initState() {
    super.initState();
    _mark = widget.mark?.markText;
    _weight = widget.mark?.weight;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.mark,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                DropdownMenu(
                  initialSelection: _mark,
                  onSelected: (value) => setState(() => _mark = value),
                  dropdownMenuEntries: [
                    for (final m in List.generate(
                      9,
                      (i) => i % 2 == 0
                          ? ((i / 2).floor() + 1).toString()
                          : '${(i / 2).floor() + 1}-',
                      growable: false,
                    ))
                      DropdownMenuEntry(label: m, value: m),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.weight,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                DropdownMenu<int>(
                  initialSelection: _weight,
                  onSelected: (value) => setState(() => _weight = value),
                  dropdownMenuEntries: [
                    for (final m in List.generate(
                      10,
                      (i) => i + 1,
                      growable: false,
                    ))
                      DropdownMenuEntry(label: m.toString(), value: m),
                  ],
                ),
              ],
            ),
            FilledButton(
              onPressed: (_mark != null && _weight != null)
                  ? () => Navigator.pop(context, {
                      'MarkText': _mark,
                      'Weight': _weight,
                    })
                  : null,
              child: Text(
                widget.mark == null
                    ? AppLocalizations.of(context)!.add
                    : AppLocalizations.of(context)!.update,
              ),
            ),
            if (widget.mark != null)
              FilledButton(
                onPressed: () => Navigator.pop(context, {'Remove': true}),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.error,
                  ),
                  foregroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.onError,
                  ),
                ),
                child: Text(AppLocalizations.of(context)!.remove),
              ),
          ],
        ),
      ),
    );
  }
}
