import 'package:GM_Nav/config/game_constants.dart';
import 'package:GM_Nav/config/search_constants.dart';
import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/model/Post.dart';
import 'package:GM_Nav/repository/firebase_manager/condition.dart';
import 'package:GM_Nav/repository/firebase_manager/firebase_query.dart';
import 'package:GM_Nav/repository/firebase_manager/query.dart';
import 'package:GM_Nav/repository/post/post_manage_imp.dart';
import 'package:GM_Nav/repository/secure_file/secure_file.dart';
import 'package:GM_Nav/repository/services/search/search_manager.dart';
import 'package:GM_Nav/repository/services/search/search_query.dart';
import 'package:GM_Nav/repository/services/security/security_manager.dart';

class IPostManager implements PostManager {
  FirebaseOperation _firebaseOperation;
  SecureFileManager _secureFileManager;
  SecurityManager _securityManager;
  SearchManager _searchManager;

  IPostManager(
      FirebaseOperation firebaseOperation,
      SecureFileManager secureFileManager,
      SecurityManager securityManager,
      SearchManager searchManager) {
    _firebaseOperation = firebaseOperation;
    _securityManager = securityManager;
    _secureFileManager = secureFileManager;
    _searchManager = searchManager;
  }

  @override
  Future<void> init() async {
    await _secureFileManager.deleteAll();
  }

  @override
  Future<void> insert(DataModel post) async {
    await _firebaseOperation.insert(
      QueryManager(
        path: [GameConstants.POST_COLLECTION_ENTRY, post.id],
        conditions: [],
        model: toJson(post),
      ),
    );
  }

  @override
  Future<void> update(DataModel post) async {
    await _firebaseOperation.update(
      QueryManager(
        path: [GameConstants.POST_COLLECTION_ENTRY, post.id],
        conditions: [],
        model: toJson(post),
      ),
    );
  }

  @override
  Future<void> delete(DataModel post) async {
    await _firebaseOperation.delete(
      QueryManager(
        path: [GameConstants.POST_COLLECTION_ENTRY, post.id],
        conditions: [],
        model: toJson(post),
      ),
    );
  }

  @override
  Future<DataModel> get(String id) async {
    return fromJson(
      await _firebaseOperation.get(
        QueryManager(
          path: [GameConstants.POST_COLLECTION_ENTRY, id],
          conditions: [],
          model: null,
        ),
      ),
    );
  }

  @override
  Future<List<DataModel>> getPosts(SearchQuery searchQuery) async {
    try {
      List<DataModel> retPosts = new List<DataModel>();
      String currentDocID = _securityManager.decrypt(
        await _secureFileManager.read(
          _securityManager.encrypt(
            GameConstants.POST_SEARCH_KEY[searchQuery.searchOption],
          ),
        ),
      );
      List<ConditionManager> condition = new List<ConditionManager>();
      if (searchQuery.searchOption == SearchOptions.General_Search) {
        condition = _searchManager.getGeneralCondition(currentDocID);
      } else if (searchQuery.searchOption == SearchOptions.OwnSearch) {
        condition = _searchManager.getMyCondition(searchQuery.id, currentDocID);
      } else if (searchQuery.searchOption == SearchOptions.OptionSearch) {
        condition =
            _searchManager.getSearchCondition(searchQuery.option, currentDocID);
      } else {
        condition = _searchManager.getGeneralCondition(currentDocID);
      }
      List<Map<String, dynamic>> postAsJson = new List<Map<String, dynamic>>();
      postAsJson = await _firebaseOperation.getWithConditions(
        QueryManager(
          path: [GameConstants.POST_COLLECTION_ENTRY],
          conditions: condition,
        ),
      );
      for (int i = 0; i < postAsJson.length; i++) {
        retPosts.add(fromJson(postAsJson[i]));
      }
      if (retPosts.isNotEmpty) {
        await _secureFileManager.write(
          _securityManager.encrypt(
            GameConstants.POST_SEARCH_KEY[searchQuery.searchOption],
          ),
          _securityManager.encrypt(retPosts.last.id),
        );
      }
      return retPosts;
    } catch (onError) {
      throw onError;
    }
  }

  @override
  DataModel fromJson(Map<String, dynamic> json) {
    if (json == null) return new Post("");
    Post databaseModel = new Post(
      json[GameConstants.POST_ID_ENTRY],
      image: json[GameConstants.POST_IMAGE_ENTRY],
      name: json[GameConstants.POST_NAME_ENTRY],
      userID: json[GameConstants.POST_USERID_ENTRY],
      date: json[GameConstants.POST_DATE_ENTRY],
      price: json[GameConstants.POST_PRICE_ENTRY],
      productID: json[GameConstants.POST_PRODUCT_ENTRY],
      catergory: List.from(json[GameConstants.POST_CATEGORY_ENTRY]),
      isSold: json[GameConstants.POST_SOLD_ENTRY],
    );
    return databaseModel;
  }

  @override
  Map<String, dynamic> toJson(DataModel databaseModel) {
    Map<String, dynamic> json = new Map<String, dynamic>();
    Post currentpost = databaseModel;
    json[GameConstants.POST_ID_ENTRY] = currentpost.id;
    json[GameConstants.POST_IMAGE_ENTRY] = currentpost.image;
    json[GameConstants.POST_NAME_ENTRY] = currentpost.name;
    json[GameConstants.POST_DATE_ENTRY] = currentpost.date;
    json[GameConstants.POST_CATEGORY_ENTRY] = currentpost.catergory;
    json[GameConstants.POST_PRODUCT_ENTRY] = currentpost.productID;
    json[GameConstants.POST_PRICE_ENTRY] = currentpost.price;
    json[GameConstants.POST_USERID_ENTRY] = currentpost.userID;
    json[GameConstants.POST_SOLD_ENTRY] = currentpost.isSold;
    return json;
  }
}
