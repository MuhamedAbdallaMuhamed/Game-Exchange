import 'dart:io';

abstract class StorageFirebaseManager {
  Future<String> upload(File file, String path);
}
