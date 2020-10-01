import 'condition.dart';

class QueryManager {
  List<String> path;
  Map<String, dynamic> model;
  List<ConditionManager> conditions;

  QueryManager({
    this.path,
    this.conditions,
    this.model,
  });
}
