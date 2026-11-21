import 'package:bakalite/accounts.dart';
import 'package:bakalite/app.dart';
import 'package:bakalite/data/cache/cache.dart';
import 'package:bakalite/utils.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefsFuture = SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );
  final cacheFuture = Cache.init();
  prefs = await prefsFuture;
  await cacheFuture;
  Account? account = await accountManager.getActiveAccount();
  if (account != null) {
    setupApi(account, false);
  }
  runApp(MainApp(route: account == null ? '/login' : '/dashboard'));
}
