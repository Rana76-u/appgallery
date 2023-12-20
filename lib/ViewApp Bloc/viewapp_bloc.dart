import 'package:appgallery/ViewApp%20Bloc/viewapp_events.dart';
import 'package:appgallery/ViewApp%20Bloc/viewapp_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewAppBloc extends Bloc<ViewAppEvents, ViewAppState>{
  ViewAppBloc() : super(const ViewAppInitState()){
    on<ViewAppEvents>((event, emit) {
      if(event is UpdateIsInstalledEvent){
        emit(state.copyWith(isInstalled: event.isInstalled));
      }
      else if(event is UpdateIsUpdateAvailableEvent){
        emit(state.copyWith(isUpdateAvailable: event.isUpdateAvailable));
      }
      else if(event is UpdateDownloadingEvent){
        emit(state.copyWith(downloading: event.downloading));
      }
      else if(event is UpdateFileExistsEvent){
        emit(state.copyWith(fileExists: event.fileExists));
      }
      else if(event is UpdateProgressEvent){
        emit(state.copyWith(progress: event.progress));
      }
    });
  }
}