import 'dart:convert';

import 'package:bakalite/data/models/events.dart';
import 'package:bakalite/data/models/homework.dart';
import 'package:bakalite/data/models/komens.dart';
import 'package:bakalite/data/models/marks.dart';
import 'package:bakalite/data/models/subjects.dart';
import 'package:bakalite/data/models/themes.dart';
import 'package:bakalite/data/models/timetable.dart';
import 'package:bakalite/data/models/user.dart';
import 'package:bakalite/data/resource.dart';
import 'package:bakalite/utils.dart';
import 'package:intl/intl.dart';

class Data {
  static final userRes = Resource<User>(User.parse);
  static User? get user => userRes.data['user'];

  static final marksRes = Resource<Marks>(Marks.parse);
  static Marks? get marks => marksRes.data['marks'];

  static final homeworkRes = Resource<Homework>(Homework.parse);
  static Homework? get homework =>
      homeworkRes.data['homeworks?from=2000-01-01'];

  static final timetableRes = Resource<Timetable>(Timetable.parse);
  static DateTime timetableDate = weekStart(DateTime.now());
  static ({
    Timetable? actual,
    Timetable? perm,
    Map<DateTime, TimetableDay> byDate,
  })
  get timetable => (
    actual: timetableRes
        .data['timetable/actual?date=${DateFormat('yyyy-MM-dd').format(timetableDate)}'],
    perm: timetableRes.data['timetable/permanent'],
    byDate: Timetable.byDate,
  );

  static final komensRes = (
    komens: Resource<Komens>(Komens.parse),
    messageTypes: Resource<MessageTypes>(MessageTypes.parse),
  );
  static ({
    Map<String, MessageType>? messageTypes,
    List<Message>? noticeboard,
    List<Message>? received,
    List<Message>? sent,
  })
  get komens => (
    received: komensRes.komens.data['komens/messages/received']?.messages,
    sent: komensRes.komens.data['komens/messages/sent']?.messages,
    noticeboard: komensRes.komens.data['komens/messages/noticeboard']?.messages,
    messageTypes: komensRes.messageTypes.data['komens/message-types']?.types,
  );

  static final eventsRes = Resource<Events>(Events.parse);
  static ({List<Event>? all, List<Event>? my, List<Event>? public})
  get events => (
    all: eventsRes.data['events']?.events,
    my: eventsRes.data['events/my']?.events,
    public: eventsRes.data['events/public']?.events,
  );

  static final subjectsRes = Resource<Subjects>(Subjects.parse);
  static Subjects? get subjects => subjectsRes.data['subjects'];

  static final themesRes = Resource<Themes>(Themes.parse);
  static Themes? themes(String subjectId) =>
      themesRes.data['subjects/themes/$subjectId'];

  static Future<void> loadUser({bool force = false}) {
    return userRes.load('user', force: force);
  }

  static Future<void> loadMarks({bool force = false}) {
    return marksRes.load('marks', force: force);
  }

  static Future<void> loadHomework({bool force = false}) {
    return homeworkRes.load('homeworks?from=2000-01-01', force: force);
  }

  static Future<void> loadTimetable({
    bool force = false,
    DateTime? customDate,
  }) {
    return Future.wait([
      timetableRes.load(
        'timetable/actual?date=${DateFormat('yyyy-MM-dd').format(weekStart(customDate ?? timetableDate))}',
        force: force,
      ),
      if (force || timetable.perm == null)
        timetableRes.load('timetable/permanent', force: force),
    ]);
  }

  static Future<void> loadKomens({bool force = false}) {
    return Future.wait([
      komensRes.messageTypes.load('komens/message-types', force: force),
      komensRes.komens.load(
        'komens/messages/received',
        force: force,
        method: 'POST',
        body: jsonEncode({
          'DateFrom': '2000-01-01T00:00:00.000',
          'IncludeHidden': true,
        }),
      ),
      komensRes.komens.load(
        'komens/messages/sent',
        force: force,
        method: 'POST',
        body: jsonEncode({
          'DateFrom': '2000-01-01T00:00:00.000',
          'IncludeHidden': true,
        }),
      ),
      komensRes.komens.load(
        'komens/messages/noticeboard',
        force: force,
        method: 'POST',
        body: jsonEncode({
          'DateFrom': '2000-01-01T00:00:00.000',
          'IncludeHidden': true,
        }),
      ),
    ]);
  }

  static Future<void> loadEvents({bool force = false}) {
    return Future.wait([
      eventsRes.load('events', force: force),
      eventsRes.load('events/my', force: force),
      eventsRes.load('events/public', force: force),
    ]);
  }

  static Future<void> loadSubjects({bool force = false}) {
    return subjectsRes.load('subjects', force: force);
  }

  static Future<void> loadThemes(String subjectId, {bool force = false}) {
    return themesRes.load('subjects/themes/$subjectId');
  }

  static void clear() {
    userRes.clear();
    marksRes.clear();
    homeworkRes.clear();
    timetableRes.clear();
    Timetable.byDate.clear();
    komensRes.komens.clear();
    komensRes.messageTypes.clear();
    eventsRes.clear();
    subjectsRes.clear();
    themesRes.clear();
  }
}
