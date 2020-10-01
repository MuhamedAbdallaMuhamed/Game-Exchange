import 'package:GM_Nav/repository/firebase_manager/query.dart';

abstract class FirebaseOperation {
  Future<void> insert(QueryManager query);

  Future<void> update(QueryManager query);

  Future<void> delete(QueryManager query);

  Future<Map<String, dynamic>> get(QueryManager query);

  Future<List<Map<String, dynamic>>> getWithConditions(QueryManager query);

  Future<void> sendResetMessage(String email);

  Future<void> createAuth(String email);
}
