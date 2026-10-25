import 'package:bakalite/accounts.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/screens/wrapper.dart';
import 'package:bakalite/widgets/account_card.dart';
import 'package:flutter/material.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  List<Account> _accounts = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final accountsData = await accountManager.getAccounts();
    if (!mounted) return;
    setState(() {
      _accounts = accountsData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      title: AppLocalizations.of(context)!.accounts,
      tabs: const [],
      children: [
        ListView(
          children: [
            for (final account in _accounts)
              AccountCard(
                username: account.username,
                url: account.baseUrl,
                id: account.id,
              ),
          ],
        ),
      ],
    );
  }
}
