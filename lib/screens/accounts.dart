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
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  for (final account in _accounts)
                    AccountCard(
                      username: account.username,
                      url: account.baseUrl,
                      id: account.id,
                      onDelete: () async {
                        final delete = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                AppLocalizations.of(context)!.confirmDeletion,
                              ),
                              actions: [
                                TextButton(
                                  child: Text(AppLocalizations.of(context)!.no),
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                ),
                                TextButton(
                                  child: Text(
                                    AppLocalizations.of(context)!.yes,
                                  ),
                                  onPressed: () => Navigator.pop(context, true),
                                ),
                              ],
                            );
                          },
                        );
                        if (!mounted) return;
                        if (delete ?? false) {
                          await accountManager.deleteAccount(account.id);
                          _load();
                        }
                      },
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 64,
              child: FilledButton(
                child: Text(AppLocalizations.of(context)!.login),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
