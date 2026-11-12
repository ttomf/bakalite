import 'package:bakalite/data/models/marks.dart';
import 'package:bakalite/data/models/user.dart';
import 'package:bakalite/data/resource.dart';

class Data {
  static final userRes = Resource<User>(User.parse);
  static User? get user => userRes.data['user'];
  static Future<void> loadUser({bool force = false}) {
    return userRes.load('user', force: force);
  }

  static final marksRes = Resource<Marks>(Marks.parse);
  static Marks? get marks => marksRes.data['marks'];
  static Future<void> loadMarks({bool force = false}) {
    return marksRes.load('marks', force: force);
  }

  static void clear() {
    userRes.clear();
    marksRes.clear();
  }
}
