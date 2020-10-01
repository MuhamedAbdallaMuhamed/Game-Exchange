import 'package:GM_Nav/repository/firebase_manager/condition.dart';

abstract class SearchManager {
  List<ConditionManager> getSearchCondition(
    List<String> option,
    String currentDocID,
  );
  List<ConditionManager> getMyCondition(
    String id,
    String currentDocID,
  );
  List<ConditionManager> getGeneralCondition(
    String currentDocID,
  );
}
