/*
  Manage Authentication
*/
import 'package:GM_Nav/config/game_constants.dart';
import 'package:GM_Nav/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Authentication {
  Future<User> authenticate();

  static Future<String> getId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userID =
        sharedPreferences.getString(GameConstants.SHARED_PREFERENCES_KEY);
    return userID;
  }

  static Future<void> persistId(String id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(GameConstants.SHARED_PREFERENCES_KEY, id);
    return;
  }

  static Future<void> logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(GameConstants.SHARED_PREFERENCES_KEY);
    return;
  }
}
