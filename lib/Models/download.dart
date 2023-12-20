import 'package:appgallery/ViewApp%20Bloc/viewapp_events.dart';
import 'package:dio/dio.dart';
import 'package:open_file_plus/open_file_plus.dart';

import '../ViewApp Bloc/viewapp_bloc.dart';

class Download {

  final ViewAppBloc viewAppBloc;
  late CancelToken cancelToken;

  Download(this.viewAppBloc);

  startDownload(
      String appName,
      String appVersion,
      String fileLink,
      ) async {
    cancelToken = CancelToken();

    String filePath = '/storage/emulated/0/Download/$appName ($appVersion).apk';
    viewAppBloc.add(UpdateDownloadingEvent(true));

    try {
      await Dio().download(fileLink, filePath,
          onReceiveProgress: (count, total) {
            viewAppBloc.add(UpdateProgressEvent((count / total)));
          }, cancelToken: cancelToken);
      viewAppBloc.add(UpdateDownloadingEvent(false));
      viewAppBloc.add(UpdateFileExistsEvent(true));
      openFile(filePath);
    } catch (e) {
      print(e);
      viewAppBloc.add(UpdateDownloadingEvent(false));
    }
  }

  openFile(String filePath) {
    OpenFile.open(filePath);
    print(filePath);
  }

  cancelDownload() {
    cancelToken.cancel();
    viewAppBloc.add(UpdateDownloadingEvent(false));
  }

}