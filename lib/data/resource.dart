import 'package:bakalite/api.dart';
import 'package:bakalite/config.dart';
import 'package:bakalite/data/cache/cache.dart';
import 'package:flutter/foundation.dart';

class Resource<T> extends ChangeNotifier {
  Resource(this.parse);

  final T Function(String string) parse;

  final Map<String, T?> data = {};
  final Map<String, DateTime?> cacheTimestamp = {};
  final Map<String, DateTime?> loaded = {};
  final Map<String, Object?> error = {};

  Future<void> load(
    String endpoint, {
    bool force = false,
    bool cacheData = true,
  }) async {
    error[endpoint] = null;
    loaded[endpoint] = null;
    notify();

    try {
      final cached = await cache.load(endpoint);
      if (cached != null) {
        data[endpoint] = parse(cached['data']);
        cacheTimestamp[endpoint] = DateTime.fromMillisecondsSinceEpoch(
          cached['timestamp'],
        );
        error[endpoint] = null;
        loaded[endpoint] = DateTime.now();
        notify();
      }
    } catch (exception) {
      error[endpoint] = exception;
      notify();
    }

    if (!Config.autoRefresh.value && !force) return;
    error[endpoint] = null;
    loaded[endpoint] = null;
    notify();

    try {
      final fetched = await api.request(endpoint);
      if (fetched != null) {
        data[endpoint] = parse(fetched);
        cacheTimestamp[endpoint] = null;
        error[endpoint] = null;
        loaded[endpoint] = DateTime.now();
        notify();
        if (cacheData) {
          await cache.save(endpoint, fetched);
        }
      }
    } catch (exception) {
      error[endpoint] = exception;
      notify();
    }
  }

  void clear() {
    data.clear();
    cacheTimestamp.clear();
    loaded.clear();
    error.clear();
    notify();
  }

  void notify() {
    notifyListeners();
  }
}
