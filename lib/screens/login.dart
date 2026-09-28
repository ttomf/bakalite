import 'dart:async';

import 'package:bakalite/accounts.dart';
import 'package:bakalite/api.dart';
import 'package:bakalite/exceptions.dart';
import 'package:bakalite/lang/app_localizations.dart';
import 'package:bakalite/utils.dart';
import 'package:flutter/material.dart';
import 'package:uuid/v4.dart';

class SchoolSearchDialog extends StatefulWidget {
  const SchoolSearchDialog({super.key, required this.api});

  final BakalariAPI api;

  @override
  State<SchoolSearchDialog> createState() => _SchoolSearchDialogState();
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _SchoolSearchDialogState extends State<SchoolSearchDialog> {
  Map<String, int> _cities = {};
  Map<String, String> _schools = {};
  bool _isLoading = true;
  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  int _searchRequest = 0;

  @override
  void initState() {
    super.initState();
    _loadSchools();
  }

  Future<void> _loadSchools() async {
    final request = _searchRequest;
    final search = _searchController.text.trim();

    try {
      setState(() {
        _isLoading = true;
      });

      Map<String, int> citiesMap = _cities;
      Map<String, String> schoolsMap = _schools;

      if (_cities.isEmpty) {
        citiesMap = await widget.api.getSchools();
      }

      if (search.isNotEmpty) {
        schoolsMap = await widget.api.getSchoolsIn(search);
      }

      if (!mounted || request != _searchRequest) return;

      setState(() {
        _cities = citiesMap;
        _schools = schoolsMap;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted || request != _searchRequest) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.searchCityHint,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: _searchController.text.isEmpty
                      ? const Icon(Icons.search)
                      : IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            _searchRequest++;
                            _searchController.text = '';
                            _loadSchools();
                          },
                        ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                onChanged: (String value) {
                  setState(() {});
                  _searchRequest++;
                  _searchDebounce?.cancel();

                  _searchDebounce = Timer(
                    const Duration(milliseconds: 300),
                    () {
                      _loadSchools();
                    },
                  );
                },
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : _searchController.text.isEmpty
                      ? ListView(
                          children: [
                            for (final name in _cities.keys.toList())
                              if (name.isNotEmpty)
                                Card(
                                  child: ListTile(
                                    title: Text(name),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${_cities[name]}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      _searchRequest++;
                                      _searchController.text = name;
                                      _loadSchools();
                                    },
                                  ),
                                ),
                          ],
                        )
                      : _schools.isNotEmpty
                      ? ListView(
                          children: [
                            for (final name in _schools.keys.toList())
                              Card(
                                child: ListTile(
                                  title: Text(name),
                                  onTap: () {
                                    Navigator.pop(context, _schools[name]);
                                  },
                                ),
                              ),
                          ],
                        )
                      : Text(AppLocalizations.of(context)!.nothingFound),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final BakalariAPI _api = BakalariAPI();
  bool _obscurePassword = true;
  final _urlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _urlError;
  String? _usernameError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.login)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 16,
              children: [
                TextField(
                  spellCheckConfiguration:
                      const SpellCheckConfiguration.disabled(),
                  autocorrect: false,
                  autofocus: true,
                  controller: _urlController,
                  keyboardType: TextInputType.url,
                  onChanged: (String value) {
                    setState(() {
                      _urlError = null;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.bakaLink,
                    errorText: _urlError,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () async {
                        final String? schoolUrl =
                            await showAdaptiveDialog<String>(
                              context: context,
                              builder: (context) {
                                return SchoolSearchDialog(api: _api);
                              },
                            );

                        if (schoolUrl != null) {
                          _urlController.text = schoolUrl;
                          setState(() {
                            _urlError = null;
                          });
                        }
                      },
                    ),
                  ),
                ),
                TextField(
                  spellCheckConfiguration:
                      const SpellCheckConfiguration.disabled(),
                  autocorrect: false,
                  controller: _usernameController,
                  keyboardType: TextInputType.name,
                  onChanged: (String value) {
                    setState(() {
                      _usernameError = null;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.username,
                    errorText: _usernameError,
                  ),
                ),
                TextField(
                  spellCheckConfiguration:
                      const SpellCheckConfiguration.disabled(),
                  autocorrect: false,
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (String value) {
                    setState(() {
                      _passwordError = null;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.password,
                    errorText: _passwordError,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: 64,
                  child: FilledButton(
                    child: Text(AppLocalizations.of(context)!.login),
                    onPressed: () async {
                      if (_urlController.text.isEmpty) {
                        setState(() {
                          _urlError = AppLocalizations.of(context)!
                              .cannotBeEmpty;
                        });
                      }

                      if (_usernameController.text.isEmpty) {
                        setState(() {
                          _usernameError = AppLocalizations.of(context)!
                              .cannotBeEmpty;
                        });
                      }

                      if (_passwordController.text.isEmpty) {
                        setState(() {
                          _passwordError = AppLocalizations.of(context)!
                              .cannotBeEmpty;
                        });
                      }

                      if (_urlError != null ||
                          _usernameError != null ||
                          _passwordError != null) {
                        return;
                      }

                      final url = _urlController.text;
                      final baseUrl = '${url.endsWith('/') ? url : '$url/'}api';
                      _api.baseUrl = baseUrl;
                      try {
                        await _api.login(
                          _usernameController.text,
                          _passwordController.text,
                        );
                        final account = Account(
                          id: const UuidV4().generate(),
                          username: _usernameController.text,
                          password: _passwordController.text,
                          baseUrl: baseUrl,
                        );
                        final id = await accountManager.saveAccount(account);
                        await accountManager.setActiveAccount(id);
                        if (!context.mounted) return;
                        Navigator.pushReplacementNamed(context, '/dashboard');
                      } on BakaLiteException catch (e) {
                        if (!context.mounted) return;
                        showError(context, e);
                      }
                    },
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
