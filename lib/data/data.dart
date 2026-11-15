import 'package:bakalite/data/models/homework.dart';
import 'package:bakalite/data/models/marks.dart';
import 'package:bakalite/data/models/timetable.dart';
import 'package:bakalite/data/models/user.dart';
import 'package:bakalite/data/resource.dart';
import 'package:bakalite/utils.dart';
import 'package:intl/intl.dart';

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

  static final homeworkRes = Resource<Homework>(Homework.parse);
  static Homework? get homework =>
      homeworkRes.data['homeworks?from=2000-01-01'];
  static Future<void> loadHomework({bool force = false}) {
    return homeworkRes.load('homeworks?from=2000-01-01', force: force);
  }

  static final timetableRes = Resource<Timetable>(Timetable.parse);
  static DateTime timetableDate = weekStart(DateTime.now());
  static Timetable? get timetable => timetableRes
      .data['timetable/actual?date=${DateFormat('yyyy-MM-dd').format(timetableDate)}'];
  static Future<void> loadTimetable({bool force = false}) {
    return timetableRes.load(
      'timetable/actual?date=${DateFormat('yyyy-MM-dd').format(timetableDate)}',
      force: force,
    );
  }

  static final timetablePermRes = Resource<Timetable>(Timetable.parse);
  static Timetable? get timetablePerm =>
      timetablePermRes.data['timetable/permanent'];
  static Future<void> loadTimetablePerm({bool force = false}) {
    return timetablePermRes.load('timetable/permanent', force: force);
  }

  static void clear() {
    userRes.clear();
    marksRes.clear();
    homeworkRes.clear();
    timetableRes.clear();
    timetablePermRes.clear();
  }
}
