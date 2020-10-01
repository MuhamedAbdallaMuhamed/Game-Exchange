import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/repository/firebase_manager/database_manager.dart';

abstract class RoomManager implements DatabaseManager {
  Future<void> init();
  Future<List<DataModel>> getMessages(String roomID);
}
