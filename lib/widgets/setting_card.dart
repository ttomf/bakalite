import 'package:bakalite/config.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/screens/wrapper.dart';
import 'package:material_ui/material_ui.dart';

class SettingCard<T> extends StatefulWidget {
  const SettingCard({
    super.key,
    required this.label,
    this.info,
    this.setting,
    this.choices,
    this.order,
    this.onSet,
    this.child,
  });

  final String label;
  final String? info;
  final ConfigOption<T>? setting;
  final Map<T, String>? choices;
  final List<({String key, String label})>? order;
  final ValueChanged<T?>? onSet;
  final Widget? child;

  @override
  State<SettingCard<T>> createState() => _SettingCardState<T>();
}

class _SettingCardState<T> extends State<SettingCard<T>> {
  final GlobalKey _key = GlobalKey();

  Future<void> pickColor() async {
    final val = await showDialog<Color>(
      context: context,
      builder: (context) {
        return AlertDialog(
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
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () => Navigator.pop(context, null),
            ),
          ],
        );
      },
    ) as T?;

    if (!mounted || val == null) return;
    widget.setting!.value = val;
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

    if (!mounted || val == null) return;
    widget.setting!.value = val;
    widget.onSet?.call(widget.setting!.value);
  }

  Future<void> sortList() async {
    if (widget.order == null) return;
    final order = (widget.setting!.value as List)
        .map((item) => widget.order!.firstWhere((e) => e.key == item))
        .toList();

    final val = await showDialog<T>(
      context: context,
      builder: (context) {
        final items = List.of(order);

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(widget.label),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: ReorderableListView(
                  onReorderItem: (oldIndex, newIndex) {
                    setDialogState(() {
                      final item = items.removeAt(oldIndex);
                      items.insert(newIndex, item);
                    });
                  },
                  proxyDecorator: (child, index, animation) => child,
                  children: [
                    for (final e in items)
                      Card(
                        key: ValueKey(e.key),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(e.label),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text(AppLocalizations.of(context)!.cancel),
                  onPressed: () => Navigator.pop(context, null),
                ),
                TextButton(
                  child: Text(AppLocalizations.of(context)!.ok),
                  onPressed: () =>
                      Navigator.pop(context, items.map((e) => e.key).toList()),
                ),
              ],
            );
          },
        );
      },
    );

    if (!mounted || val == null) return;
    widget.setting!.value = val;
    widget.onSet?.call(widget.setting!.value);
  }

  Widget getControl() {
    if (widget.setting == null) {
      if (widget.child == null) {
        return const SizedBox(height: 48);
      } else {
        return const Icon(Icons.arrow_forward);
      }
    }
    if (T == bool) {
      return Switch(
        value: widget.setting!.value as bool,
        onChanged: (val) {
          widget.setting!.value = val as T;
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
    if ((T == List<String>) && (widget.order?.isNotEmpty ?? false)) {
      return const Icon(Icons.sort);
    }

    throw ArgumentError('Unsupported setting type: $T');
  }

  @override
  Widget build(BuildContext context) {
    final setting = widget.setting;

    if (setting == null) {
      return buildCard();
    }

    return ValueListenableBuilder<T>(
      valueListenable: setting,
      builder: (context, value, child) => buildCard(),
    );
  }

  Card buildCard() {
    return Card(
      child: InkWell(
        key: _key,
        onTap: () {
          if (widget.setting == null) {
            if (widget.child == null) {
              widget.onSet?.call(null);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Wrapper(
                      title: widget.label,
                      children: [widget.child!],
                    );
                  },
                ),
              );
            }
            return;
          }

          if (T == bool) {
            widget.setting!.value = !(widget.setting!.value as bool) as T;
            widget.onSet?.call(widget.setting!.value);
          } else if (T == Color) {
            pickColor();
          } else if (T == String) {
            pickString();
          } else if (T == List<String>) {
            sortList();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.label,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      if (widget.setting?.defaultValue != widget.setting?.value)
                        IconButton(
                          key: const ValueKey('undo'),
                          icon: const Icon(Icons.undo),
                          onPressed: () {
                            widget.setting!.value =
                                widget.setting!.defaultValue;
                            widget.onSet?.call(widget.setting!.value);
                          },
                        ),
                      if (widget.info != null)
                        IconButton(
                          key: const ValueKey('info'),
                          icon: const Icon(Icons.info_outline),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(widget.label),
                                  content: Text(widget.info!),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                    ],
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
