import 'package:GM_Nav/config/database_constants.dart';
import 'package:GM_Nav/config/game_constants.dart';
import 'package:GM_Nav/config/search_constants.dart';
import 'package:GM_Nav/repository/firebase_manager/condition.dart';
import 'package:GM_Nav/repository/services/search/search_manager.dart';

class ISearchManager implements SearchManager {
  List<ConditionManager> getSearchCondition(
    List<String> option,
    String currentDocID,
  ) {
    List<ConditionManager> condition = new List<ConditionManager>();
    List<String> category = new List<String>();
    for (int i = 0; i < option.length; i++) {
      switch (SearchMethods[option[i]]) {
        case SearchType.CONTAIN_TAG:
          category.add(
            option[i],
          );
          break;
        case SearchType.LESS_PRICE:
          condition.add(
            ConditionManager(
              field: GameConstants.POST_PRICE_ENTRY,
              methods: DatabaseQueryConstants.ORDER_BY,
              desc: false,
            ),
          );
          break;
        case SearchType.HIGH_PRICE:
          condition.add(
            ConditionManager(
              field: GameConstants.POST_PRICE_ENTRY,
              methods: DatabaseQueryConstants.ORDER_BY,
              desc: true,
            ),
          );
          break;
      }
    }
    if (category.length > 0) {
      condition.add(
        ConditionManager(
          field: GameConstants.POST_CATEGORY_ENTRY,
          methods: DatabaseQueryConstants.CONTAINS_ANY,
          value: category,
        ),
      );
    }
    if (currentDocID != "" && currentDocID != null) {
      condition.add(
        ConditionManager(
          methods: DatabaseQueryConstants.START_AFTER_DOCUMENT,
          value: [GameConstants.POST_COLLECTION_ENTRY, currentDocID],
        ),
      );
    }
    condition.add(
      ConditionManager(
        field: GameConstants.POST_DATE_ENTRY,
        methods: DatabaseQueryConstants.ORDER_BY,
        desc: true,
      ),
    );
    condition.add(
      ConditionManager(
        field: GameConstants.POST_SOLD_ENTRY,
        methods: DatabaseQueryConstants.EQUALS,
        value: false,
      ),
    );
    condition.add(
      ConditionManager(
        methods: DatabaseQueryConstants.LIMIT,
        value: GameConstants.LIMIT,
      ),
    );
    return condition;
  }

  @override
  List<ConditionManager> getGeneralCondition(
    String currentDocID,
  ) {
    List<ConditionManager> condition = new List<ConditionManager>();
    condition.add(
      ConditionManager(
        field: GameConstants.POST_DATE_ENTRY,
        methods: DatabaseQueryConstants.ORDER_BY,
        desc: true,
      ),
    );
    if (currentDocID != "" && currentDocID != null) {
      condition.add(
        ConditionManager(
          methods: DatabaseQueryConstants.START_AFTER_DOCUMENT,
          value: [GameConstants.POST_COLLECTION_ENTRY, currentDocID],
        ),
      );
    }
    condition.add(
      ConditionManager(
        field: GameConstants.POST_SOLD_ENTRY,
        methods: DatabaseQueryConstants.EQUALS,
        value: false,
      ),
    );
    condition.add(
      ConditionManager(
        methods: DatabaseQueryConstants.LIMIT,
        value: GameConstants.LIMIT,
      ),
    );
    return condition;
  }

  @override
  List<ConditionManager> getMyCondition(
    String id,
    String currentDocID,
  ) {
    List<ConditionManager> condition = new List<ConditionManager>();
    if (currentDocID != "" && currentDocID != null) {
      condition.add(
        ConditionManager(
          methods: DatabaseQueryConstants.START_AFTER_DOCUMENT,
          value: [GameConstants.POST_COLLECTION_ENTRY, currentDocID],
        ),
      );
    }
    condition.add(
      ConditionManager(
        field: GameConstants.POST_USERID_ENTRY,
        methods: DatabaseQueryConstants.EQUALS,
        value: id,
      ),
    );
    condition.add(
      ConditionManager(
        field: GameConstants.POST_DATE_ENTRY,
        methods: DatabaseQueryConstants.ORDER_BY,
        desc: true,
      ),
    );
    condition.add(
      ConditionManager(
        methods: DatabaseQueryConstants.LIMIT,
        value: GameConstants.LIMIT,
      ),
    );
    return condition;
  }
}
