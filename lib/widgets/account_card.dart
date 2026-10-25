import 'package:bakalite/accounts.dart';
import 'package:bakalite/utils.dart';
import 'package:flutter/material.dart';

class AccountCard<T> extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.username,
    required this.url,
    required this.id,
  });

  final String username;
  final String url;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () async {
          await accountManager.setActiveAccount(id);
          if (!context.mounted) return;
          await setupApi();
          if (!context.mounted) return;
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/dashboard',
            (route) => false,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        username,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(url, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
