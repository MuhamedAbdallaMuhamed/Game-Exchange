class ArithmaticException implements Exception {
  String message;

  ArithmaticException([String info = ""]) {
    message = "Arithmatic error occur, $info";
  }

  String toString() => "ArithmaticException: $message";
}
