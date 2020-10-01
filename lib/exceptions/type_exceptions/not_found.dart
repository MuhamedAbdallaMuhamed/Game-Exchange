class NotFoundException implements Exception {
  String message;

  NotFoundException([String info = ""]) {
    message = "$info, Data not found in my data";
  }

  String toString() => "NotFoundException: $message";
}
