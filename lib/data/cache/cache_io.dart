import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Cache {
  const Cache(this.id);

  static late Directory _dir;

  final String id;

  static Future<void> init() async {
    _dir = await getApplicationCacheDirectory();
  }

  static String encode(String value) {
    return base64Url.encode(utf8.encode(value));
  }

  static String decode(String value) {
    return utf8.decode(base64Url.decode(value));
  }

  Future<void> save(String key, dynamic data) async {
    if (id == '') return;

    final file = File('${_dir.path}/$id/${encode(key)}.json.gz');

    await file.parent.create(recursive: true);

    final content = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'data': data,
    };
    final compressed = gzip.encode(utf8.encode(jsonEncode(content)));

    await file.writeAsBytes(compressed);
  }

  Future<dynamic> load(String key) async {
    if (id == '') return null;

    final file = File('${_dir.path}/$id/${encode(key)}.json.gz');

    if (!await file.exists()) return null;

    final compressed = await file.readAsBytes();
    final content = jsonDecode(utf8.decode(gzip.decode(compressed)));

    return content;
  }

  Future<void> clear() async {
    if (id == '') return;

    final dir = Directory('${_dir.path}/$id');

    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }
}

Cache cache = const Cache('');
