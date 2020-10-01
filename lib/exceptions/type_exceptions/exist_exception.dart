class AlreadyExistException implements Exception {
  String message;

  AlreadyExistException([String info = ""]) {
    message = "Data already exists, $info";
  }

  String toString() => "AlreadyExistException: $message";
}
