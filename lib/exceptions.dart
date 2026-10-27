enum BakaLiteError {
  network,
  http,
  invalidCredentials,
  invalidResponse,
  invalidInput,
  noInternet,
}

class BakaLiteException implements Exception {
  const BakaLiteException(this.error, [this.info]);

  final BakaLiteError error;
  final String? info;

  @override
  String toString() => '$error${info == null ? '' : ' $info'}';
}
