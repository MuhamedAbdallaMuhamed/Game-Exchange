import 'package:GM_Nav/model/DataModel.dart';

class Product extends DataModel {
  String description;

  Product(
    String id, {
    this.description,
  }) {
    this.id = id;
  }

  List<Object> get props => [
        this.id,
        this.description,
      ];
}
