import 'package:equatable/equatable.dart';

class HomeStates extends Equatable {

  final bool isSearching;
  final List matchedIndex;

  const HomeStates({required this.isSearching, required this.matchedIndex});

  @override
  List<Object?> get props => [isSearching, matchedIndex];

  HomeStates copyWith({
    bool? isSearching,
    List? matchedIndex
}){
    return HomeStates(
        isSearching: isSearching ?? this.isSearching,
        matchedIndex: matchedIndex ?? this.matchedIndex
    );
  }
}

class HomeInitStates extends HomeStates {
  HomeInitStates() : super(
    isSearching: false,
    matchedIndex: []
  );
}