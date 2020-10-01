import 'package:GM_Nav/config/game_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GM_Nav/config/database_constants.dart';
import 'package:GM_Nav/repository/firebase_manager/query.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_query.dart';

class IFirebaseOperation implements FirebaseOperation {
  @override
  Future<void> insert(QueryManager query) async {
    return (await _getDocument(query.path).setData(query.model));
  }

  @override
  Future<void> update(QueryManager query) async {
    return (await _getDocument(query.path).updateData(query.model));
  }

  @override
  Future<void> delete(QueryManager query) async {
    return (await _getDocument(query.path).delete());
  }

  @override
  Future<Map<String, dynamic>> get(QueryManager query) async {
    return (await _getDocument(query.path).get()).data;
  }

  @override
  Future<List<Map<String, dynamic>>> getWithConditions(
      QueryManager query) async {
    var currentCollection = _getCollection(query.path);
    try {
      for (int i = 0; i < query.conditions.length; i++) {
        switch (query.conditions[i].methods) {
          case DatabaseQueryConstants.CONTAINS:
            currentCollection = currentCollection.where(
                query.conditions[i].field,
                arrayContains: query.conditions[i].value);
            break;
          case DatabaseQueryConstants.CONTAINS_ANY:
            currentCollection = currentCollection.where(
                query.conditions[i].field,
                arrayContainsAny: query.conditions[i].value);
            break;
          case DatabaseQueryConstants.EQUALS:
            currentCollection = currentCollection.where(
                query.conditions[i].field,
                isEqualTo: query.conditions[i].value);
            break;
          case DatabaseQueryConstants.GREATER_THAN:
            currentCollection = currentCollection.where(
                query.conditions[i].field,
                isGreaterThan: query.conditions[i].value);
            break;
          case DatabaseQueryConstants.GREATER_THAN_OR_EQUAL:
            currentCollection = currentCollection.where(
                query.conditions[i].field,
                isGreaterThanOrEqualTo: query.conditions[i].value);
            break;
          case DatabaseQueryConstants.LESS_THAN:
            currentCollection = currentCollection.where(
                query.conditions[i].field,
                isLessThan: query.conditions[i].value);
            break;
          case DatabaseQueryConstants.LESS_THAN_OR_EQUAL:
            currentCollection = currentCollection.where(
                query.conditions[i].field,
                isLessThanOrEqualTo: query.conditions[i].value);
            break;
          case DatabaseQueryConstants.START_AFTER_DOCUMENT:
            currentCollection = currentCollection.startAfterDocument(
              await _getDocument(query.conditions[i].value).get(),
            );
            break;
          case DatabaseQueryConstants.ORDER_BY:
            currentCollection = currentCollection.orderBy(
              query.conditions[i].field,
              descending: query.conditions[i].desc,
            );
            break;
          case DatabaseQueryConstants.LIMIT:
            currentCollection =
                currentCollection.limit(query.conditions[i].value);
            break;
        }
      }
    } catch (onError) {
      throw onError;
    }
    var docs = (await currentCollection.getDocuments()).documents;

    return docs.map((e) => e.data).toList();
  }

  Query _getCollection(List<String> path) {
    var firestore = Firestore.instance;

    var currentCollection = firestore.collection(path[0]);
    for (int i = 1; i + 1 < path.length; i += 2) {
      currentCollection.document(path[i]).collection(path[i + 1]);
    }

    return currentCollection;
  }

  DocumentReference _getDocument(List<String> path) {
    return (_getCollection(path) as CollectionReference).document(path.last);
  }

  @override
  Future<void> sendResetMessage(String email) async {
    var firestore = FirebaseAuth.instance;
    await firestore.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> createAuth(String email) async {
    var firestore = FirebaseAuth.instance;
    await firestore.createUserWithEmailAndPassword(
      email: email,
      password: GameConstants.STATIC_PASSWORD,
    );
  }
}
