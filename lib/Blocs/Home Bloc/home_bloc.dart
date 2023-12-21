import 'package:appgallery/Blocs/Home%20Bloc/home_events.dart';
import 'package:appgallery/Blocs/Home%20Bloc/home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvents, HomeStates>{
  HomeBloc() : super(HomeInitStates()){
    on<HomeEvents>((event, emit) {
      if(event is UpdateIsSearching){
        emit(state.copyWith(isSearching: event.isSearching));
      }
      else if(event is UpdateMatchedIndex){
        emit(state.copyWith(matchedIndex: event.matchedIndex));
      }
    });
  }
}