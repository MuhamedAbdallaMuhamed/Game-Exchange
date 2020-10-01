import 'package:GM_Nav/model/DataModel.dart';

class UserVote extends DataModel {
  String firstID;
  String secondID;
  double rate;

  UserVote(
    String id, {
    this.firstID,
    this.secondID,
    this.rate,
  }) {
    this.id = id;
  }

  List<Object> get props => [
        this.id,
        this.firstID,
        this.secondID,
        this.rate,
      ];
}
