import 'dart:convert';
import 'package:GM_Nav/config/game_constants.dart';
import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/model/chatMessage.dart';
import 'package:GM_Nav/model/chatRoom.dart';
import 'package:GM_Nav/repository/server/server_model/server_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:scoped_model/scoped_model.dart';

class ServerModel extends Model {
  ChatRoom _chatRoom;
  List<ChatMessages> messages = List<ChatMessages>();
  SocketIO socketIO;

  void init(ChatRoom chatRoom) {
    _chatRoom = chatRoom;
    socketIO = SocketIOManager().createSocketIO(
        ServerConstants.SERVER_HERF, '/',
        query: ServerConstants.ROOM_ENTRY + '${_chatRoom.id}');
    socketIO.init();

    socketIO.subscribe(ServerConstants.RECEIVE_MSG, (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      messages.add(
        fromJson(
          data,
        ),
      );
      notifyListeners();
    });

    socketIO.connect();
  }

  void sendMessage(ChatMessages message) {
    messages.add(
      message,
    );
    socketIO.sendMessage(
      ServerConstants.SEND_MSG,
      json.encode(
        toJson(
          message,
        ),
      ),
    );
    notifyListeners();
  }

  List<ChatMessages> getMessagesForChatID(String chatID) {
    List<ChatMessages> retMessages = new List<ChatMessages>();
    for (int i = 0; i < messages.length; i++) {
      retMessages.add(messages[i]);
    }
    messages.clear();
    return retMessages.toList();
  }

  void end() {
    socketIO.destroy();
  }

  Map<String, dynamic> toJson(DataModel databaseModel) {
    Map<String, dynamic> json = new Map<String, dynamic>();
    ChatMessages currentChat = databaseModel;
    json[GameConstants.CHAT_MESSAGE_ID_ENTRY] = currentChat.id;
    json[GameConstants.CHAT_MESSAGE_PATH_ENTRY] = currentChat.pathID;
    json[GameConstants.CHAT_MESSAGE_CONTENT_ENTRY] = currentChat.message;
    json[GameConstants.CHAT_MESSAGE_TIME_ENTRY] =
        currentChat.date.toDate().millisecondsSinceEpoch.toString();
    json[GameConstants.CHAT_MESSAGE_SENDER_ID_ENTRY] = currentChat.senderID;
    json[GameConstants.CHAT_MESSAGE_RECEIVER_ID_ENTRY] = currentChat.receiverID;
    json[GameConstants.CHAT_MESSAGE_ROOM_ID] = currentChat.chatID;
    return json;
  }

  DataModel fromJson(Map<String, dynamic> json) {
    if (json == null) return new ChatMessages("");
    ChatMessages databaseModel = new ChatMessages(
      json[GameConstants.CHAT_MESSAGE_ID_ENTRY],
      message: json[GameConstants.CHAT_MESSAGE_CONTENT_ENTRY],
      pathID: json[GameConstants.CHAT_MESSAGE_PATH_ENTRY],
      date: new Timestamp.fromMillisecondsSinceEpoch(
        int.parse(
          json[GameConstants.CHAT_MESSAGE_TIME_ENTRY],
        ),
      ),
      senderID: json[GameConstants.CHAT_MESSAGE_SENDER_ID_ENTRY],
      receiverID: json[GameConstants.CHAT_MESSAGE_RECEIVER_ID_ENTRY],
      chatID: json[GameConstants.CHAT_MESSAGE_ROOM_ID],
    );
    return databaseModel;
  }
}
