import 'package:bakalite/utils.dart';
import 'package:material_ui/material_ui.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({
    super.key,
    required this.date,
    required this.label,
    required this.onChanged,
    this.step = 1,
    this.initialDate,
  });

  final DateTime date;
  final String label;
  final ValueChanged<DateTime> onChanged;
  final int step;
  final DateTime? initialDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.filled(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () => onChanged(addDays(date, -step)),
        ),
        Expanded(
          child: TextButton.icon(
            icon: const Icon(Icons.date_range),
            label: Text(label),
            onPressed: () async {
              final selected = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime.now().subtract(
                  const Duration(days: 365 * 5),
                ),
                lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
              );

              if (selected != null && context.mounted) {
                onChanged(selected);
              }
            },
            onLongPress: () {
              onChanged(DateUtils.dateOnly(initialDate ?? DateTime.now()));
            },
          ),
        ),
        IconButton.filled(
          icon: const Icon(Icons.keyboard_arrow_right),
          onPressed: () => onChanged(addDays(date, step)),
        ),
      ],
    );
  }
}
