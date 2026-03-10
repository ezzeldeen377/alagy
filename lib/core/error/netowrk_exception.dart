class NoInternetException implements Exception {
  final String message;

  NoInternetException([this.message = "No Internet Connection"]);

  @override
  String toString() => message;
}
