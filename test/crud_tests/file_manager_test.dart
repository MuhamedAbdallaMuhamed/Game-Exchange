import 'package:GM_Nav/repository/file_manager/file_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import '../firebase_mock/dependency_injection_mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Post CRUD Operations Tests: ', () {
    build();

    test('Checking Basic Operation Tests', () async {
      //Construct
      FileManager fileManager = container<FileManager>();
      await fileManager.create();
      String doc = "XXXXXXX";
      await fileManager.write(doc);
      String retDoc = await fileManager.read();
      expect(retDoc, equals(doc));
    });
  });
}
