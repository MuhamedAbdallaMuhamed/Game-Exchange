import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/repository/firebase_manager/database_manager.dart';

abstract class UserManager implements DatabaseManager {
  Future<DataModel> getWithGmail(String gmail);
  Future<void> resetPassword(String gmail);
}
