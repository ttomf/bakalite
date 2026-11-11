import 'package:bakalite/data/models/user.dart';
import 'package:bakalite/data/resource.dart';

class Data {
  static final userRes = Resource<User>(User.parse);
  static User? get user => userRes.data['user'];
  static Future<void> loadUser({bool force = false}) {
    return userRes.load('user', force: force);
  }

  static void clear() {
    userRes.clear();
  }
}
