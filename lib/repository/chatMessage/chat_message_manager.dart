import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/repository/firebase_manager/database_manager.dart';

abstract class ChatMessageManager implements DatabaseManager {
  Future<DataModel> getLastMessage(String firstID, String secondID);
  Future<List<DataModel>> getAllChats(String firstID);
  Future<void> init();
}
