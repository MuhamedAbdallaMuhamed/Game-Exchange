import 'package:GM_Nav/config/database_constants.dart';
import 'package:GM_Nav/config/game_constants.dart';
import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/model/User.dart';
import 'package:GM_Nav/model/userVote.dart';
import 'package:GM_Nav/repository/firebase_manager/condition.dart';
import 'package:GM_Nav/repository/firebase_manager/firebase_query.dart';
import 'package:GM_Nav/repository/firebase_manager/query.dart';
import 'package:GM_Nav/repository/services/userVote/userVote_manager.dart';
import 'package:GM_Nav/repository/user/user_manager.dart';

class IUserVoteManager implements UserVoteManager {
  FirebaseOperation _firebaseOperation;
  UserManager _userManager;

  IUserVoteManager(
      FirebaseOperation firebaseOperation, UserManager userManager) {
    _firebaseOperation = firebaseOperation;
    _userManager = userManager;
  }
  @override
  Future<void> insert(DataModel model) async {
    await _firebaseOperation.insert(
      QueryManager(
        path: [GameConstants.VOTE_COLLECTION_ENTRY, model.id],
        conditions: [],
        model: toJson(model),
      ),
    );
  }

  @override
  Future<void> update(DataModel model) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<void> delete(DataModel model) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<DataModel> get(String id) async {
    return fromJson(
      await _firebaseOperation.get(
        QueryManager(
          path: [GameConstants.VOTE_COLLECTION_ENTRY, id],
          conditions: [],
          model: null,
        ),
      ),
    );
  }

  @override
  Future<bool> isVoteExist(String firstID, String secondID) async {
    List<Map<String, dynamic>> votes =
        await _firebaseOperation.getWithConditions(
      QueryManager(
        path: [GameConstants.VOTE_COLLECTION_ENTRY],
        conditions: [
          ConditionManager(
            field: GameConstants.VOTE_FIRST_ID_ENTRY,
            methods: DatabaseQueryConstants.EQUALS,
            value: firstID,
          ),
          ConditionManager(
            field: GameConstants.VOTE_SECOND_ID_ENTRY,
            methods: DatabaseQueryConstants.EQUALS,
            value: secondID,
          ),
        ],
        model: null,
      ),
    );
    return votes.isNotEmpty;
  }

  @override
  Future<void> rateUser(DataModel vote) async {
    await insert(vote);
    User user = await _userManager.get((vote as UserVote).secondID);
    user.nOfVotes++;
    user.userRateSum += (vote as UserVote).rate;
    await _userManager.update(user);
  }

  @override
  DataModel fromJson(Map<String, dynamic> json) {
    if (json == null) return new UserVote("");
    UserVote databaseModel = new UserVote(
      json[GameConstants.VOTE_ID_ENTRY],
      firstID: json[GameConstants.VOTE_FIRST_ID_ENTRY],
      secondID: json[GameConstants.VOTE_SECOND_ID_ENTRY],
      rate: json[GameConstants.VOTE_RATE_ENTRY],
    );
    return databaseModel;
  }

  @override
  Map<String, dynamic> toJson(DataModel databaseModel) {
    Map<String, dynamic> json = new Map<String, dynamic>();
    UserVote vote = databaseModel;
    json[GameConstants.VOTE_ID_ENTRY] = vote.id;
    json[GameConstants.VOTE_FIRST_ID_ENTRY] = vote.firstID;
    json[GameConstants.VOTE_SECOND_ID_ENTRY] = vote.secondID;
    json[GameConstants.VOTE_RATE_ENTRY] = vote.rate;
    return json;
  }
}
