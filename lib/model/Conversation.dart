import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GM_Nav/model/DataModel.dart';

class Conversation extends DataModel {
  List<String> messages;
  List<Timestamp> time;
  String userID;
  bool seen;

  Conversation(
    String id, {
    this.messages,
    this.time,
    this.userID,
    this.seen,
  }) {
    this.id = id;
  }

  List<Object> get props => [
        this.id,
        this.messages,
        this.time,
        this.userID,
        this.seen,
      ];
}
