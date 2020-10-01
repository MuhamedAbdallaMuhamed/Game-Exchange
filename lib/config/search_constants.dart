enum SearchOptions {
  General_Search,
  OptionSearch,
  OwnSearch,
}

enum SearchType {
  CONTAIN_TAG,
  LESS_PRICE,
  HIGH_PRICE,
}

// ignore: non_constant_identifier_names
final Map SearchMethods = {
  "Battle Royale": SearchType.CONTAIN_TAG,
  "Simulation": SearchType.CONTAIN_TAG,
  "Indie": SearchType.CONTAIN_TAG,
  "Survival": SearchType.CONTAIN_TAG,
  "Strategy": SearchType.CONTAIN_TAG,
  "Shooter": SearchType.CONTAIN_TAG,
  "RPG": SearchType.CONTAIN_TAG,
  "Sports": SearchType.CONTAIN_TAG,
  "Action-adventure": SearchType.CONTAIN_TAG,
  "Racing": SearchType.CONTAIN_TAG,
  "Puzzle": SearchType.CONTAIN_TAG,
  "Adventure": SearchType.CONTAIN_TAG,
  "FPS": SearchType.CONTAIN_TAG,
  "Multiplayer": SearchType.CONTAIN_TAG,
  "Open World": SearchType.CONTAIN_TAG,
  "Multi-Genre": SearchType.CONTAIN_TAG,
  "Less Price": SearchType.LESS_PRICE,
  "High Price": SearchType.HIGH_PRICE,
};
