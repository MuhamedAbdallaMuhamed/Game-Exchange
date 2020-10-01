import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/repository/firebase_manager/database_manager.dart';

abstract class UserVoteManager implements DatabaseManager {
  Future<void> rateUser(DataModel vote);
  Future<bool> isVoteExist(String firstID, String secondID);
}
