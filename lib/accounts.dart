import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Account {
  const Account({
    required this.id,
    required this.username,
    required this.password,
    required this.baseUrl,
  });

  final String id;
  final String username;
  final String password;
  final String baseUrl;

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'password': password,
    'baseUrl': baseUrl,
  };

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      baseUrl: json['baseUrl'],
    );
  }
}

class AccountManager {
  AccountManager({FlutterSecureStorage? storage})
    : storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage storage;

  static const accountsKey = 'accounts';
  static const activeAccountKey = 'activeAccount';

  Future<List<Account>> getAccounts() async {
    final value = await storage.read(key: accountsKey);

    if (value == null) {
      return [];
    }

    final json = jsonDecode(value);

    if (json is! List) {
      return [];
    }

    return json
        .whereType<Map<String, dynamic>>()
        .map(Account.fromJson)
        .toList();
  }

  Future<String> saveAccount(Account account) async {
    final accounts = await getAccounts();

    for (final item in accounts) {
      if (item.baseUrl == account.baseUrl &&
          item.username == account.username &&
          item.password == account.password) {
        return item.id;
      }
    }

    final index = accounts.indexWhere((item) => item.id == account.id);

    if (index == -1) {
      accounts.add(account);
    } else {
      accounts[index] = account;
    }

    await storage.write(
      key: accountsKey,
      value: jsonEncode(accounts.map((account) => account.toJson()).toList()),
    );

    return account.id;
  }

  Future<Account?> getAccount(String id) async {
    final accounts = await getAccounts();

    for (final account in accounts) {
      if (account.id == id) {
        return account;
      }
    }

    return null;
  }

  Future<void> deleteAccount(String id) async {
    final accounts = await getAccounts();

    accounts.removeWhere((account) => account.id == id);

    await storage.write(
      key: accountsKey,
      value: jsonEncode(accounts.map((account) => account.toJson()).toList()),
    );

    if (await getActiveAccountId() == id) {
      await storage.delete(key: activeAccountKey);
    }
  }

  Future<String?> getActiveAccountId() {
    return storage.read(key: activeAccountKey);
  }

  Future<void> setActiveAccount(String id) async {
    final account = await getAccount(id);

    if (account == null) {
      throw ArgumentError('Account does not exist');
    }

    await storage.write(key: activeAccountKey, value: id);
  }

  Future<Account?> getActiveAccount() async {
    final id = await getActiveAccountId();

    if (id == null) {
      return null;
    }

    return getAccount(id);
  }
}

final accountManager = AccountManager();
