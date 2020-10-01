import 'package:flutter_test/flutter_test.dart';
import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/model/User.dart';
import 'package:GM_Nav/repository/user/user_manager.dart';
import '../firebase_mock/dependency_injection_mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Post CRUD Operations Tests: ', () {
    build();

    test('Checking Basic Operation Tests', () async {
      //Construct
      User user = new User(
        "X5XXXXXX",
        name: "Hbsheo",
        email: "BeshoTezzKingdom7@Hussin.com",
        password: "A7m3dS2l27",
        userRateSum: 1.0,
        nOfVotes: 5,
      );
      var userManager = container<UserManager>();

      //Action
      await userManager.insert(user);

      //Get Data
      DataModel currentUser = (await userManager.get(user.id));

      //Expect
      expect((currentUser as User).name, equals("Hbsheo"));
    });

    test('Checking the rest of Operations', () async {
      User user = new User(
        "1",
        name: "beso",
        email: "medomnyka@Hussin.com",
        password: "noob master 69",
        userRateSum: 1.0,
        nOfVotes: 5,
      );

      var userManager = container<UserManager>();
      userManager.insert(user);

      DataModel currentUser = (await userManager.get(user.id));

      (currentUser as User).name = "slaye5";
      (currentUser as User).userRateSum = 1.0;

      userManager.update(currentUser);

      currentUser = (await userManager.get(user.id));

      expect((currentUser as User).name, equals("slaye5"));
      expect((currentUser as User).userRateSum, equals(1.0));

      //delete
      DataModel deletedUser = (await userManager.get(user.id));

      userManager.delete(deletedUser);

      currentUser = (await userManager.get(user.id));

      expect((currentUser as User).id, equals(""));
    });
  });
}
