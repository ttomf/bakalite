import 'dart:convert';

import 'package:bakalite/utils.dart';

class User({
  required final String fullName,
  required final String userTypeText,
}) {
  factory User.parse(String string) {
    final data = jsonDecode(string);
    return User(
      fullName: safeString(data['FullName']),
      userTypeText: safeString(data['UserTypeText']),
    );
  }
}
