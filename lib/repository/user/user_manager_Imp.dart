import 'package:GM_Nav/config/database_constants.dart';
import 'package:GM_Nav/config/game_constants.dart';
import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/repository/firebase_manager/condition.dart';
import 'package:GM_Nav/repository/firebase_manager/firebase_query.dart';
import 'package:GM_Nav/repository/firebase_manager/query.dart';
import 'package:GM_Nav/repository/user/user_manager.dart';
import '../../model/User.dart';

class IUserManager implements UserManager {
  FirebaseOperation _firebaseOperation;

  IUserManager(FirebaseOperation firebaseOperation) {
    _firebaseOperation = firebaseOperation;
  }

  @override
  Future<void> insert(DataModel user) async {
    await _firebaseOperation.createAuth((user as User).email);
    await _firebaseOperation.insert(
      QueryManager(
        path: [GameConstants.USER_COLLECTION_ENTRY, user.id],
        conditions: [],
        model: toJson(user),
      ),
    );
  }

  @override
  Future<void> update(DataModel user) async {
    await _firebaseOperation.update(
      QueryManager(
        path: [GameConstants.USER_COLLECTION_ENTRY, user.id],
        conditions: [],
        model: toJson(user),
      ),
    );
  }

  @override
  Future<void> delete(DataModel user) async {
    await _firebaseOperation.delete(
      QueryManager(
        path: [GameConstants.USER_COLLECTION_ENTRY, user.id],
        conditions: [],
        model: toJson(user),
      ),
    );
  }

  @override
  Future<DataModel> get(String id) async {
    return fromJson(
      await _firebaseOperation.get(
        QueryManager(
          path: [GameConstants.USER_COLLECTION_ENTRY, id],
          conditions: [],
          model: null,
        ),
      ),
    );
  }

  @override
  Future<DataModel> getWithGmail(String gmail) async {
    List<Map<String, dynamic>> user =
        await _firebaseOperation.getWithConditions(
      QueryManager(
        path: [GameConstants.USER_COLLECTION_ENTRY],
        conditions: [
          ConditionManager(
            field: GameConstants.USER_MAIL_ENTRY,
            methods: DatabaseQueryConstants.EQUALS,
            value: gmail,
          ),
        ],
        model: null,
      ),
    );
    if (user.isEmpty) return fromJson(null);
    return fromJson(
      user[0],
    );
  }

  @override
  Future<void> resetPassword(String email) async {
    await _firebaseOperation.sendResetMessage(email);
  }

  @override
  DataModel fromJson(Map<String, dynamic> json) {
    if (json == null) return new User("");
    User databaseModel = new User(
      json[GameConstants.USER_ID_ENTRY],
      name: json[GameConstants.USER_NAME_ENTRY],
      email: json[GameConstants.USER_MAIL_ENTRY],
      userRateSum: json[GameConstants.USER_RATE_SUM_ENTRY],
      nOfVotes: json[GameConstants.USER_VOTES_NUMBER_ENTRY],
      password: json[GameConstants.USER_PASSWORD_ENTRY],
      imageUrl: json[GameConstants.USER_IMAGE_ENTRY],
    );
    return databaseModel;
  }

  @override
  Map<String, dynamic> toJson(DataModel databaseModel) {
    Map<String, dynamic> json = new Map<String, dynamic>();
    User currentuser = databaseModel;
    json[GameConstants.USER_ID_ENTRY] = currentuser.id;
    json[GameConstants.USER_NAME_ENTRY] = currentuser.name;
    json[GameConstants.USER_MAIL_ENTRY] = currentuser.email;
    json[GameConstants.USER_PASSWORD_ENTRY] = currentuser.password;
    json[GameConstants.USER_RATE_SUM_ENTRY] = currentuser.userRateSum;
    json[GameConstants.USER_IMAGE_ENTRY] = currentuser.imageUrl;
    json[GameConstants.USER_VOTES_NUMBER_ENTRY] = currentuser.nOfVotes;
    return json;
  }
}
