import 'package:bakalite/api.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _loadSchools();
  }

  Future<void> _loadSchools() async {
    try {
      setState(() {
        _isLoading = true;
      });

      Map<String, int> citiesMap = _cities;
      Map<String, String> schoolsMap = _schools;
      if (_cities.isEmpty) {
        citiesMap = await widget.api.getSchools();
      }
      if (_searchController.text.isNotEmpty) {
        schoolsMap = await widget.api.getSchoolsIn(
          _searchController.text.trim(),
        );
      }

      if (!mounted) return;

      setState(() {
        _cities = citiesMap;
        _schools = schoolsMap;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
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
                  hintText: 'Search',
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
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            _searchController.text = '';
                            _loadSchools();
                          },
                        ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                onChanged: (String value) {
                  _loadSchools();
                },
              ),
              SizedBox(height: 8),
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
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Icon(Icons.arrow_forward_ios, size: 16),
                                      ],
                                    ),
                                    onTap: () {
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
                      : Text('Nothing found.'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final BakalariAPI _api = BakalariAPI();
  bool _obscurePassword = true;
  final _urlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 16,
              children: [
                TextField(
                  spellCheckConfiguration: SpellCheckConfiguration.disabled(),
                  autocorrect: false,
                  autofocus: true,
                  controller: _urlController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: 'Bakaláři link',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
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
                        }
                      },
                    ),
                  ),
                ),
                TextField(
                  spellCheckConfiguration: SpellCheckConfiguration.disabled(),
                  autocorrect: false,
                  controller: _usernameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  spellCheckConfiguration: SpellCheckConfiguration.disabled(),
                  autocorrect: false,
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
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
                  child: FilledButton(child: Text('Login'), onPressed: () {}),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
