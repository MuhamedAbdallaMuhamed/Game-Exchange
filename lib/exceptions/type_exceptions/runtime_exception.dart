class RuntimeException implements Exception {
  String message;

  RuntimeException([String info]) {
    message = "Runtime exception occur during work, $info";
  }

  String toString() => "RuntimeException: $message";
}
