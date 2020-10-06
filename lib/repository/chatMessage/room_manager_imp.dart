import 'package:GM_Nav/config/database_constants.dart';
import 'package:GM_Nav/config/game_constants.dart';
import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/model/chatMessage.dart';
import 'package:GM_Nav/repository/chatMessage/room_manager.dart';
import 'package:GM_Nav/repository/firebase_manager/condition.dart';
import 'package:GM_Nav/repository/firebase_manager/firebase_query.dart';
import 'package:GM_Nav/repository/firebase_manager/query.dart';
import 'package:GM_Nav/repository/secure_file/secure_file.dart';
import 'package:GM_Nav/repository/services/security/security_manager.dart';

class IRoomManager implements RoomManager {
  FirebaseOperation _firebaseOperation;
  SecureFileManager _secureFileManager;
  SecurityManager _securityManager;

  IRoomManager(FirebaseOperation firebaseOperation,
      SecureFileManager secureFileManager, SecurityManager securityManager) {
    _firebaseOperation = firebaseOperation;
    _secureFileManager = secureFileManager;
    _securityManager = securityManager;
  }

  @override
  Future<void> init() async {
    await _secureFileManager.deleteAll();
  }

  @override
  Future<void> insert(DataModel model) async {
    await _firebaseOperation.insert(
      QueryManager(
        path: [
          GameConstants.CHAT_MESSAGE_COLLECTION_ENTRY,
          (model as ChatMessages).pathID,
          GameConstants.CHAT_MESSAGE_PATH_COLLECTION_ENTRY,
          model.id,
        ],
        model: toJson(model),
      ),
    );
  }

  @override
  Future<void> update(DataModel model) async {
    await _firebaseOperation.update(
      QueryManager(
        path: [
          GameConstants.CHAT_MESSAGE_COLLECTION_ENTRY,
          (model as ChatMessages).pathID,
          GameConstants.CHAT_MESSAGE_PATH_COLLECTION_ENTRY,
          model.id,
        ],
        model: toJson(model),
      ),
    );
  }

  @override
  Future<void> delete(DataModel model) async {
    await _firebaseOperation.delete(
      QueryManager(
        path: [
          GameConstants.CHAT_MESSAGE_COLLECTION_ENTRY,
          (model as ChatMessages).pathID,
          GameConstants.CHAT_MESSAGE_PATH_COLLECTION_ENTRY,
          model.id,
        ],
      ),
    );
  }

  @override
  Future<DataModel> get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<DataModel>> getMessages(String roomID) async {
    try {
      List<DataModel> retMessage = new List<DataModel>();
      String currentDocID = _securityManager.decrypt(
        await _secureFileManager.read(
          _securityManager.encrypt(GameConstants.MESSAGE_KEY),
        ),
      );
      List<ConditionManager> condition = new List<ConditionManager>();
      condition.add(
        ConditionManager(
          field: GameConstants.CHAT_MESSAGE_TIME_ENTRY,
          methods: DatabaseQueryConstants.ORDER_BY,
          desc: true,
        ),
      );
      if (currentDocID != null && currentDocID != "") {
        condition.add(
          ConditionManager(
            methods: DatabaseQueryConstants.START_AFTER_DOCUMENT,
            value: [
              GameConstants.CHAT_MESSAGE_COLLECTION_ENTRY,
              roomID,
              GameConstants.CHAT_MESSAGE_PATH_COLLECTION_ENTRY,
              currentDocID,
            ],
          ),
        );
      }
      condition.add(
        ConditionManager(
          methods: DatabaseQueryConstants.LIMIT,
          value: GameConstants.MAX_MESSAGES,
        ),
      );
      List<Map<String, dynamic>> messageAsJson =
          new List<Map<String, dynamic>>();
      messageAsJson = await _firebaseOperation.getWithConditions(
        QueryManager(
          path: [
            GameConstants.CHAT_MESSAGE_COLLECTION_ENTRY,
            roomID,
            GameConstants.CHAT_MESSAGE_PATH_COLLECTION_ENTRY,
          ],
          conditions: condition,
        ),
      );
      for (int i = messageAsJson.length - 1; i >= 0; i--) {
        retMessage.add(fromJson(messageAsJson[i]));
      }
      if (retMessage.isNotEmpty) {
        await _secureFileManager.write(
          _securityManager.encrypt(
            GameConstants.MESSAGE_KEY,
          ),
          _securityManager.encrypt(retMessage.last.id),
        );
      }
      return retMessage;
    } catch (onError) {
      throw onError;
    }
  }

  @override
  Map<String, dynamic> toJson(DataModel databaseModel) {
    Map<String, dynamic> json = new Map<String, dynamic>();
    ChatMessages currentChat = databaseModel;
    json[GameConstants.CHAT_MESSAGE_ID_ENTRY] = currentChat.id;
    json[GameConstants.CHAT_MESSAGE_PATH_ENTRY] = currentChat.pathID;
    json[GameConstants.CHAT_MESSAGE_CONTENT_ENTRY] = currentChat.message;
    json[GameConstants.CHAT_MESSAGE_TIME_ENTRY] = currentChat.date;
    json[GameConstants.CHAT_MESSAGE_SENDER_ID_ENTRY] = currentChat.senderID;
    json[GameConstants.CHAT_MESSAGE_RECEIVER_ID_ENTRY] = currentChat.receiverID;
    json[GameConstants.CHAT_MESSAGE_ROOM_ID] = currentChat.chatID;
    return json;
  }

  @override
  DataModel fromJson(Map<String, dynamic> json) {
    if (json == null) return new ChatMessages("");
    ChatMessages databaseModel = new ChatMessages(
      json[GameConstants.CHAT_MESSAGE_ID_ENTRY],
      message: json[GameConstants.CHAT_MESSAGE_CONTENT_ENTRY],
      pathID: json[GameConstants.CHAT_MESSAGE_PATH_ENTRY],
      date: json[GameConstants.CHAT_MESSAGE_TIME_ENTRY],
      senderID: json[GameConstants.CHAT_MESSAGE_SENDER_ID_ENTRY],
      receiverID: json[GameConstants.CHAT_MESSAGE_RECEIVER_ID_ENTRY],
      chatID: json[GameConstants.CHAT_MESSAGE_ROOM_ID],
    );
    return databaseModel;
  }
}
