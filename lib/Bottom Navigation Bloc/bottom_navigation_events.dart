
import 'package:flutter/cupertino.dart';

@immutable
abstract class BottomBarEvent {}

class IndexChange extends BottomBarEvent{
  final int currentIndex;

  IndexChange({required this.currentIndex});
}