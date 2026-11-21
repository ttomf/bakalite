import 'package:bakalite/data/data.dart';
import 'package:bakalite/data/models/komens.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

class MessageCard extends StatelessWidget {
  const MessageCard(this.message, {super.key});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: !message.read || (!message.confirmed && message.canConfirm)
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
            : BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/komens/message', arguments: message);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.sender.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(message.title),
              const SizedBox(height: 8),
              Divider(
                height: 1,
                thickness: 1.5,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('d. M. yyyy H:mm').format(message.sentDate)),
                  Text(
                    Data.komens.messageTypes?[message.type]?.name ??
                        message.type,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
