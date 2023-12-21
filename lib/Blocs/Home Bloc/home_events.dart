abstract class HomeEvents {}

class UpdateIsSearching extends HomeEvents {
  final bool isSearching;

  UpdateIsSearching(this.isSearching);
}

class UpdateMatchedIndex extends HomeEvents {
  final List matchedIndex;

  UpdateMatchedIndex(this.matchedIndex);
}