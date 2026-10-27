class Cache {
  const Cache(this.id);

  final String id;

  static Future<void> init() async {}

  static String encode(String value) => value;

  static String decode(String value) => value;

  Future<void> save(String key, dynamic data) async {}

  Future<dynamic> load(String key) async => null;

  Future<void> clear() async {}
}

Cache cache = const Cache('');
