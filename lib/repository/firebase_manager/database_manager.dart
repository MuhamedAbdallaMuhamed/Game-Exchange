import 'package:GM_Nav/model/DataModel.dart';

abstract class DatabaseManager {
  Future<void> insert(DataModel model);

  Future<void> update(DataModel model);

  Future<void> delete(DataModel model);

  Future<DataModel> get(String id);

  DataModel fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(DataModel databaseModel);
}
