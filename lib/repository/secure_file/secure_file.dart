abstract class SecureFileManager {
  Future<void> write(String key, String value);
  Future<String> read(String key);
  Future<void> deleteAll();
}
