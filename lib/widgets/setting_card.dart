import 'package:flutter/material.dart';

class SettingCard<T> extends StatefulWidget {
  const SettingCard({
    super.key,
    required this.label,
    this.setting,
    this.choices,
    this.onSet,
  });

  final String label;
  final ValueNotifier<T>? setting;
  final Map<T, String>? choices;
  final ValueChanged<T?>? onSet;

  @override
  State<SettingCard<T>> createState() => _SettingCardState<T>();
}

class _SettingCardState<T> extends State<SettingCard<T>> {
  final GlobalKey _key = GlobalKey();

  Future<void> pickColor() async {
    final val = await showAdaptiveDialog<Color>(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(widget.label),
          content: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final color in Colors.primaries)
                InkWell(
                  onTap: () => Navigator.pop(context, color),
                  borderRadius: BorderRadius.circular(24),
                  child: CircleAvatar(backgroundColor: color, radius: 24),
                ),
            ],
          ),
        );
      },
    ) as T?;

    if (val == null) return;
    setState(() {
      widget.setting!.value = val;
    });
    widget.onSet?.call(widget.setting!.value);
  }

  Future<void> pickString() async {
    final choices = widget.choices;
    if (choices == null) return;

    final button = _key.currentContext!.findRenderObject() as RenderBox;
    final overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;

    final val = await showMenu<T>(
      context: context,
      position: RelativeRect.fromRect(
        button.localToGlobal(
              button.size.bottomRight(Offset.zero),
              ancestor: overlay,
            ) &
            button.size,
        Offset.zero & overlay.size,
      ),
      items: [
        for (final e in choices.entries)
          PopupMenuItem<T>(value: e.key, child: Text(e.value)),
      ],
    );

    if (val == null) return;
    setState(() {
      widget.setting!.value = val;
    });
    widget.onSet?.call(widget.setting!.value);
  }

  Widget getControl() {
    if (widget.setting == null) {
      return SizedBox.fromSize(size: const Size(0, 48));
    }
    if (T == bool) {
      return Switch(
        value: widget.setting!.value as bool,
        onChanged: (val) {
          setState(() {
            widget.setting!.value = val as T;
          });
          widget.onSet?.call(widget.setting!.value);
        },
      );
    }
    if (T == Color) {
      return CircleAvatar(
        backgroundColor: widget.setting!.value as Color,
        radius: 24,
      );
    }
    if (T == String && (widget.choices?.isNotEmpty ?? false)) {
      return Text(
        (widget.choices?[widget.setting!.value] ?? widget.setting!.value)
            as String,
        style: Theme.of(context).textTheme.labelLarge,
      );
    }

    throw ArgumentError('Unsupported setting type: $T');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        key: _key,
        onTap: () {
          if (widget.setting == null) {
            widget.onSet?.call(null);
            return;
          }

          if (T == bool) {
            setState(() {
              widget.setting!.value = !(widget.setting!.value as bool) as T;
            });
            widget.onSet?.call(widget.setting!.value);
          } else if (T == Color) {
            pickColor();
          } else if (T == String) {
            pickString();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.label,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(width: 12),
                getControl(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
