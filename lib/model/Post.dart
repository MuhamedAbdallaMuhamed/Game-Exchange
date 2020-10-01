import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GM_Nav/model/DataModel.dart';

class Post extends DataModel {
  Timestamp date;
  String userID;
  String name;
  String image;
  double price;
  String productID;
  bool isSold;
  List<String> catergory;

  Post(
    String id, {
    this.date,
    this.userID,
    this.isSold,
    this.name,
    this.catergory,
    this.price,
    this.image,
    this.productID,
  }) {
    this.id = id;
  }

  List<Object> get props => [
        this.id,
        this.isSold,
        this.catergory,
        this.date,
        this.userID,
        this.price,
        this.name,
        this.image,
        this.productID,
      ];
}
