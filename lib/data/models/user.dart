import 'dart:convert';

class User({
  required final String fullName,
  required final String userTypeText,
}) {
  factory User.parse(String string) {
    final data = jsonDecode(string);
    return User(
      fullName: data['FullName'] ?? '',
      userTypeText: data['UserTypeText'] ?? '',
    );
  }
}
