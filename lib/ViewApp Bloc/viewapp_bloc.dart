import 'package:appgallery/ViewApp%20Bloc/viewapp_events.dart';
import 'package:appgallery/ViewApp%20Bloc/viewapp_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewAppBloc extends Bloc<ViewAppEvents, ViewAppState>{
  ViewAppBloc() : super(ViewAppState(isInstalled: false, isUpdateAvailable: false)){
    on<ViewAppEvents>((event, emit) {
      if(event is BoolChange){
        emit(ViewAppInitial(isInstalled: event.isInstalled, isUpdateAvailable: event.isUpdateAvailable));
      }
    });
  }
  
}