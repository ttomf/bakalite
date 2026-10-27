import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Cache {
  const Cache(this.id);

  static late SharedPreferences _prefs;

  final String id;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String encode(String value) {
    return base64Url.encode(utf8.encode(value));
  }

  static String decode(String value) {
    return utf8.decode(base64Url.decode(value));
  }

  String _key(String key) => 'cache_${id}_${encode(key)}';

  Future<void> save(String key, dynamic data) async {
    if (id == '') return;

    final content = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'data': data,
    };

    await _prefs.setString(_key(key), jsonEncode(content));
  }

  Future<dynamic> load(String key) async {
    if (id == '') return null;

    final content = _prefs.getString(_key(key));

    if (content == null) return null;

    return jsonDecode(content);
  }

  Future<void> clear() async {
    if (id == '') return;

    for (final key in _prefs.getKeys().toList()) {
      if (key.startsWith('cache_${id}_')) {
        await _prefs.remove(key);
      }
    }
  }
}

Cache cache = const Cache('');
