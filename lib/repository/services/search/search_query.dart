import 'package:GM_Nav/config/search_constants.dart';

class SearchQuery {
  String id;
  SearchOptions searchOption;
  List<String> option;

  SearchQuery({
    this.id,
    this.option,
    this.searchOption,
  });
}
