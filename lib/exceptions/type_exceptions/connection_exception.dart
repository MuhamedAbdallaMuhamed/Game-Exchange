class ConnectionException implements Exception {
  String message;

  ConnectionException([String info = ""]) {
    message = "Connection fails and makes $info";
  }

  String toString() => "ConnectionException: $message";
}
