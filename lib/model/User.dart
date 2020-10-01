import 'package:GM_Nav/model/DataModel.dart';

class User extends DataModel {
  String password;
  String email;
  String name;
  double userRateSum;
  int nOfVotes;
  String imageUrl;

  User(
    String id, {
    this.password,
    this.email,
    this.name,
    this.userRateSum,
    this.nOfVotes,
    this.imageUrl,
  }) {
    this.id = id;
  }

  List<Object> get props => [
        this.id,
        this.password,
        this.email,
        this.name,
        this.userRateSum,
        this.nOfVotes,
        this.imageUrl,
      ];
}
