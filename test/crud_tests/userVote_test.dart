import 'package:GM_Nav/model/User.dart';
import 'package:GM_Nav/repository/user/user_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import '../firebase_mock/dependency_injection_mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Post CRUD Operations Tests: ', () {
    build();

    test('Checking Basic Operation Tests', () async {
      //Construct
      UserManager userManager = container<UserManager>();

      User user1 = new User(
        "1",
        name: "beso",
        email: "medomnyka@Hussin.com",
        password: "noob master 69",
        userRateSum: 1.0,
        nOfVotes: 0,
      );
      User user2 = new User(
        "2",
        name: "beso",
        email: "medomnyka@Hussin.com",
        password: "noob master 69",
        userRateSum: 1.0,
        nOfVotes: 0,
      );
      // Act 1
      await userManager.insert(user1);
      await userManager.insert(user2);

      user2 = await userManager.get(user2.id);

      expect(user2.nOfVotes, equals(1));
    });
  });
}
