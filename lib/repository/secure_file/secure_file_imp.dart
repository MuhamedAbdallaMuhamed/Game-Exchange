import 'package:GM_Nav/repository/secure_file/secure_file.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ISecureFileManager implements SecureFileManager {
  FlutterSecureStorage _flutterSecureStorage;

  ISecureFileManager() {
    _flutterSecureStorage = FlutterSecureStorage();
  }

  @override
  Future<String> read(String key) async {
    return (await _flutterSecureStorage.read(key: key));
  }

  @override
  Future<void> write(String key, String value) async {
    try {
      await _flutterSecureStorage.write(key: key, value: value);
    } catch (onError) {
      print(onError.toString());
      throw onError;
    }
  }

  @override
  Future<void> deleteAll() async {
    await _flutterSecureStorage.deleteAll();
  }
}
