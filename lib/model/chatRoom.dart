import 'package:GM_Nav/model/DataModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom extends DataModel {
  String firstID;
  String secondID;
  String messagesID;
  String lastMessage;
  Timestamp messageTime;

  ChatRoom(
    String id, {
    this.firstID,
    this.lastMessage,
    this.messageTime,
    this.secondID,
    this.messagesID,
  }) {
    this.id = id;
  }

  List<Object> get props => [
        this.id,
        this.firstID,
        this.secondID,
        this.messagesID,
        this.lastMessage,
        this.messageTime,
      ];
}
