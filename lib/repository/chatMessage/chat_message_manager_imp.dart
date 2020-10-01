import 'package:GM_Nav/config/database_constants.dart';
import 'package:GM_Nav/config/game_constants.dart';
import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/model/chatRoom.dart';
import 'package:GM_Nav/repository/chatMessage/chat_message_manager.dart';
import 'package:GM_Nav/repository/firebase_manager/condition.dart';
import 'package:GM_Nav/repository/firebase_manager/firebase_query.dart';
import 'package:GM_Nav/repository/firebase_manager/query.dart';
import 'package:GM_Nav/repository/secure_file/secure_file.dart';
import 'package:GM_Nav/repository/services/security/security_manager.dart';

class IChatMessageManager implements ChatMessageManager {
  FirebaseOperation _firebaseOperation;
  SecureFileManager _secureFileManager;
  SecurityManager _securityManager;

  IChatMessageManager(
    FirebaseOperation firebaseOperation,
    SecureFileManager secureFileManager,
    SecurityManager securityManager,
  ) {
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
          GameConstants.CHAT_ROOM_COLLECTION_ENTRY,
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
          GameConstants.CHAT_ROOM_COLLECTION_ENTRY,
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
          GameConstants.CHAT_ROOM_COLLECTION_ENTRY,
          model.id,
        ],
      ),
    );
  }

  @override
  Future<DataModel> get(String id) async {
    return fromJson(
      await _firebaseOperation.get(
        QueryManager(
          path: [
            GameConstants.CHAT_ROOM_COLLECTION_ENTRY,
            id,
          ],
          conditions: [],
        ),
      ),
    );
  }

  @override
  Future<DataModel> getLastMessage(String firstID, String secondID) async {
    List<Map<String, dynamic>> chats =
        await _firebaseOperation.getWithConditions(
      QueryManager(
        path: [GameConstants.CHAT_ROOM_COLLECTION_ENTRY],
        conditions: [
          ConditionManager(
            field: GameConstants.CHAT_ROOM_FIRST_ID_ENTRY,
            methods: DatabaseQueryConstants.EQUALS,
            value: firstID,
          ),
          ConditionManager(
            field: GameConstants.CHAT_ROOM_SECOND_ID_ENTRY,
            methods: DatabaseQueryConstants.EQUALS,
            value: secondID,
          ),
        ],
        model: null,
      ),
    );
    if (chats != null && chats.isNotEmpty) {
      return fromJson(
        chats[0],
      );
    }
    return new ChatRoom("");
  }

  @override
  Future<List<DataModel>> getAllChats(String firstID) async {
    List<ConditionManager> conditions = new List<ConditionManager>();
    String currentDocID = _securityManager.decrypt(
      await _secureFileManager.read(
        _securityManager.encrypt(GameConstants.CHAT_KEY),
      ),
    );
    conditions.add(
      ConditionManager(
        field: GameConstants.CHAT_ROOM_LAST_TIME_ENTRY,
        methods: DatabaseQueryConstants.ORDER_BY,
        desc: true,
      ),
    );
    conditions.add(
      ConditionManager(
        field: GameConstants.CHAT_ROOM_FIRST_ID_ENTRY,
        methods: DatabaseQueryConstants.EQUALS,
        value: firstID,
      ),
    );
    conditions.add(
      ConditionManager(
        methods: DatabaseQueryConstants.LIMIT,
        value: GameConstants.MAX_CHAT,
      ),
    );
    if (currentDocID != null && currentDocID != "") {
      conditions.add(
        ConditionManager(
          methods: DatabaseQueryConstants.START_AFTER_DOCUMENT,
          value: [
            GameConstants.CHAT_ROOM_COLLECTION_ENTRY,
            currentDocID,
          ],
        ),
      );
    }
    List<Map<String, dynamic>> chats =
        await _firebaseOperation.getWithConditions(
      QueryManager(
        path: [GameConstants.CHAT_ROOM_COLLECTION_ENTRY],
        conditions: conditions,
        model: null,
      ),
    );
    if (chats != null && chats.isNotEmpty) {
      List<DataModel> retChats = [];
      for (int i = 0; i < chats.length; i++) {
        retChats.add(fromJson(chats[i]));
      }
      await _secureFileManager.write(
        _securityManager.encrypt(
          GameConstants.CHAT_KEY,
        ),
        _securityManager.encrypt(retChats.last.id),
      );
      return retChats;
    }
    return [];
  }

  @override
  Map<String, dynamic> toJson(DataModel databaseModel) {
    Map<String, dynamic> json = new Map<String, dynamic>();
    ChatRoom currentChat = databaseModel;
    json[GameConstants.CHAT_ROOM_ID_ENTRY] = currentChat.id;
    json[GameConstants.CHAT_ROOM_FIRST_ID_ENTRY] = currentChat.firstID;
    json[GameConstants.CHAT_ROOM_SECOND_ID_ENTRY] = currentChat.secondID;
    json[GameConstants.CHAT_ROOM_MESSAGE_ID_ENTRY] = currentChat.messagesID;
    json[GameConstants.CHAT_ROOM_LAST_MESSAGE_ENTRY] = currentChat.lastMessage;
    json[GameConstants.CHAT_ROOM_LAST_TIME_ENTRY] = currentChat.messageTime;
    return json;
  }

  @override
  DataModel fromJson(Map<String, dynamic> json) {
    if (json == null) return new ChatRoom("");
    ChatRoom databaseModel = new ChatRoom(
      json[GameConstants.CHAT_ROOM_ID_ENTRY],
      firstID: json[GameConstants.CHAT_ROOM_FIRST_ID_ENTRY],
      secondID: json[GameConstants.CHAT_ROOM_SECOND_ID_ENTRY],
      messagesID: json[GameConstants.CHAT_ROOM_MESSAGE_ID_ENTRY],
      lastMessage: json[GameConstants.CHAT_ROOM_LAST_MESSAGE_ENTRY],
      messageTime: json[GameConstants.CHAT_ROOM_LAST_TIME_ENTRY],
    );
    return databaseModel;
  }
}
