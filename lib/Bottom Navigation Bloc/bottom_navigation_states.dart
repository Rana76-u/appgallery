import 'package:flutter/cupertino.dart';

@immutable
class BottomBarState {
  final int currentIndex;

  const BottomBarState({required this.currentIndex});
}

class BottomBarInitial extends BottomBarState {
  const BottomBarInitial({required super.currentIndex});
}