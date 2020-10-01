import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/repository/firebase_manager/database_manager.dart';
import 'package:GM_Nav/repository/services/search/search_query.dart';

abstract class PostManager implements DatabaseManager {
  Future<void> init();
  Future<List<DataModel>> getPosts(SearchQuery searchQuery);
}
