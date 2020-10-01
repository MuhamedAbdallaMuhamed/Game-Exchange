import 'package:GM_Nav/config/game_constants.dart';
import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/model/Product.dart';
import 'package:GM_Nav/repository/firebase_manager/firebase_query.dart';
import 'package:GM_Nav/repository/firebase_manager/query.dart';
import 'package:GM_Nav/repository/product/product_manager.dart';

class IProductManager implements ProductManager {
  FirebaseOperation _firebaseOperation;

  IProductManager(FirebaseOperation firebaseOperation) {
    _firebaseOperation = firebaseOperation;
  }

  @override
  Future<void> insert(DataModel product) async {
    await _firebaseOperation.insert(
      QueryManager(
        path: [GameConstants.PRODUCT_COLLECTION_ENTRY, product.id],
        conditions: [],
        model: toJson(product),
      ),
    );
  }

  @override
  Future<void> update(DataModel product) async {
    await _firebaseOperation.update(
      QueryManager(
        path: [GameConstants.PRODUCT_COLLECTION_ENTRY, product.id],
        conditions: [],
        model: toJson(product),
      ),
    );
  }

  @override
  Future<void> delete(DataModel product) async {
    await _firebaseOperation.delete(
      QueryManager(
        path: [GameConstants.PRODUCT_COLLECTION_ENTRY, product.id],
        conditions: [],
        model: toJson(product),
      ),
    );
  }

  @override
  Future<DataModel> get(String id) async {
    return fromJson(
      await _firebaseOperation.get(
        QueryManager(
          path: [GameConstants.PRODUCT_COLLECTION_ENTRY, id],
          conditions: [],
          model: null,
        ),
      ),
    );
  }

  @override
  DataModel fromJson(Map<String, dynamic> json) {
    if (json == null) return new Product("");
    Product databaseModel = new Product(
      json[GameConstants.PRODUCT_ID_ENTRY],
      description: json[GameConstants.PRODUCT_DESC_ENTRY],
    );
    return databaseModel;
  }

  @override
  Map<String, dynamic> toJson(DataModel databaseModel) {
    Map<String, dynamic> json = new Map<String, dynamic>();
    Product currentproduct = databaseModel;
    json[GameConstants.PRODUCT_ID_ENTRY] = currentproduct.id;
    json[GameConstants.PRODUCT_DESC_ENTRY] = currentproduct.description;
    return json;
  }
}
