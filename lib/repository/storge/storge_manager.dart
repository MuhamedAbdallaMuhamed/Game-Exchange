import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'storage_manager_imp.dart';

class FirebaseStorageManager implements StorageFirebaseManager {
  @override
  Future<String> upload(File file, String path) async {
    var storageReference = FirebaseStorage.instance.ref().child(
          path,
        );

    var downloadUrl = (await storageReference.putFile(file).onComplete);
    var url = await downloadUrl.ref.getDownloadURL();

    return url;
  }
}
