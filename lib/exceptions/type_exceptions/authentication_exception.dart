class AuthenticationException implements Exception {
  String message;

  AuthenticationException([String info = ""]) {
    message = "Authentication Failed, $info";
  }

  String toString() => "AuthenticationException: $message";
}
