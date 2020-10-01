import 'package:GM_Nav/config/database_constants.dart';

class ConditionManager {
  DatabaseQueryConstants methods;
  String field;
  bool desc;
  dynamic value;

  ConditionManager({
    this.methods,
    this.field,
    this.desc,
    this.value,
  });
}
