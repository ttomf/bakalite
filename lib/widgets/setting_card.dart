import 'package:bakalite/utils.dart';
import 'package:flutter/material.dart';

class SettingCard<T> extends StatefulWidget {
  const SettingCard({
    super.key,
    required this.label,
    this.name,
    this.defaultValue,
    this.choices,
    this.onSet,
  });

  final String label;
  final String? name;
  final T? defaultValue;
  final List<T>? choices;
  final ValueChanged<T?>? onSet;

  @override
  State<SettingCard<T>> createState() => _SettingCardState<T>();
}

class _SettingCardState<T> extends State<SettingCard<T>> {
  late T value;

  @override
  void initState() {
    super.initState();
    if (widget.name != null) {
      value = load() ?? widget.defaultValue as T;
      if (widget.name != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            widget.onSet?.call(value);
          }
        });
      }
    }
  }

  void save() {
    if (T == bool) {
      prefs.setBool('settings_${widget.name}', value as bool);
    }
    if (T == String) {
      prefs.setString('settings_${widget.name}', value as String);
    }
    if (T == Color) {
      prefs.setInt('settings_${widget.name}', (value as Color).toARGB32());
    }
  }

  T? load() {
    if (widget.name == null || !prefs.containsKey('settings_${widget.name}')) {
      return null;
    }
    if (T == bool) {
      return prefs.getBool('settings_${widget.name}')! as T;
    }
    if (T == String) {
      return prefs.getString('settings_${widget.name}')! as T;
    }
    if (T == Color) {
      return Color(prefs.getInt('settings_${widget.name}')!) as T;
    }

    throw ArgumentError('Unsupported setting type: $T');
  }

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
              for (final color in const [
                Colors.red,
                Colors.deepOrange,
                Colors.orange,
                Colors.amber,
                Colors.yellow,
                Colors.lime,
                Colors.lightGreen,
                Colors.green,
                Colors.teal,
                Colors.cyan,
                Colors.lightBlue,
                Colors.blue,
                Colors.indigo,
                Colors.deepPurple,
                Colors.purple,
                Colors.pink,
                Colors.brown,
                Colors.blueGrey,
              ])
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
    if (val != null) {
      setState(() {
        value = val;
      });
      save();
      widget.onSet?.call(value);
    }
  }

  Widget getControl() {
    if (widget.name == null) {
      return SizedBox.fromSize(size: const Size(0, 48));
    }
    if (T == bool) {
      return Switch(
        value: value as bool,
        onChanged: (val) {
          setState(() {
            value = val as T;
          });
          save();
          widget.onSet?.call(value);
        },
      );
    }
    if (T == Color) {
      return InkWell(
        onTap: pickColor,
        borderRadius: BorderRadius.circular(24),
        child: CircleAvatar(backgroundColor: value as Color, radius: 24),
      );
    }

    throw ArgumentError('Unsupported setting type: $T');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          if (widget.name == null) {
            widget.onSet?.call(null);
            return;
          }

          if (T == bool) {
            setState(() {
              value = !(value as bool) as T;
            });
            save();
            widget.onSet?.call(value);
          } else if (T == Color) {
            pickColor();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Text(widget.label, style: Theme.of(context).textTheme.bodyLarge),
              const Spacer(),
              getControl(),
            ],
          ),
        ),
      ),
    );
  }
}
