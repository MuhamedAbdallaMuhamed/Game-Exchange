import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GM_Nav/model/DataModel.dart';

class ChatMessages extends DataModel {
  Timestamp date;
  String message;
  String senderID;
  String pathID;
  String receiverID;
  String chatID;

  ChatMessages(
    String id, {
    this.date,
    this.pathID,
    this.senderID,
    this.receiverID,
    this.message,
    this.chatID,
  }) {
    this.id = id;
  }

  List<Object> get props => [
        this.id,
        this.senderID,
        this.pathID,
        this.chatID,
        this.date,
        this.message,
        this.receiverID,
      ];
}
