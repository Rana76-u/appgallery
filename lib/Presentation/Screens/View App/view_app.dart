import 'package:appgallery/Models/download.dart';
import 'package:appgallery/Models/open_photo.dart';
import 'package:appgallery/ViewApp%20Bloc/viewapp_bloc.dart';
import 'package:appgallery/ViewApp%20Bloc/viewapp_events.dart';
import 'package:appgallery/ViewApp%20Bloc/viewapp_states.dart';
import 'package:device_apps/device_apps.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file_plus/open_file_plus.dart';

// ignore: must_be_immutable
class ViewApp extends StatefulWidget {
  String name;
  String about;
  String icon;
  String size;
  String fileLink;
  String packageName;
  String versionName;
  int downloadCount;
  List<dynamic> screenshots;
  List<dynamic> comments;

  ViewApp({
    super.key,
    required this.name,
    required this.about,
    required this.icon,
    required this.size,
    required this.fileLink,
    required this.packageName,
    required this.versionName,
    required this.downloadCount,
    required this.screenshots,
    required this.comments,
  });

  @override
  State<ViewApp> createState() => _ViewAppState();
}

class _ViewAppState extends State<ViewApp> {

  late ViewAppBloc viewAppBlocProvider;

  //Useless
  bool isPermission = false;
  //

  late CancelToken cancelToken;

  @override
  void initState() {
    checkAppIsInstalled();
    super.initState();
    viewAppBlocProvider = BlocProvider.of<ViewAppBloc>(context);
  }

  void checkAppIsInstalled() async {

    bool tempIsInstalled =  await DeviceApps.isAppInstalled(widget.packageName);
    viewAppBlocProvider.add(UpdateIsInstalledEvent(tempIsInstalled));

    if(tempIsInstalled){
      Application? app = await DeviceApps.getApp(widget.packageName);
      if(app!.versionName != widget.versionName){
        viewAppBlocProvider.add(UpdateIsUpdateAvailableEvent(true));
      }
    }
  }

  //Useless
  /*var checkAllPermissions = CheckPermission();
  checkPermission() async {
    var permission = await checkAllPermissions.isStoragePermission();
    if (permission) {
      setState(() {
        isPermission = true;
      });
      startDownload();
    }
  }*/

/*  startDownload() async {
    cancelToken = CancelToken();

    setState(() {
      filePath = '/storage/emulated/0/Download/${widget.name} ${widget.versionName}.apk';
      state.downloading = true;
      progress = 0;
    });

    try {
      await Dio().download(widget.fileLink, filePath,
          onReceiveProgress: (count, total) {
            setState(() {
              progress = (count / total);
            });
          }, cancelToken: cancelToken);
      setState(() {
        downloading = false;
        fileExists = true;
      });
      openFile();
    } catch (e) {
      print(e);
      setState(() {
        downloading = false;
      });
    }
  }

  openFile() {
    OpenFile.open(filePath);
    print(filePath);
  }

  cancelDownload() {
    cancelToken.cancel();
    setState(() {
      downloading = false;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ViewAppBloc, ViewAppState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  topAppInfo(state),

                  //space
                  space(20),

                  state.downloading ?
                  cancelButtons()
                      :
                  //open btn
                  state.isUpdateAvailable
                      ?
                  buttons('update')
                      : state.isInstalled ?
                  buttons('open')
                      :
                  buttons('download'),

                  space(25),

                  screenShotsWidget(),

                  space(25),

                  aboutThisApp(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget topAppInfo(ViewAppState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //icon - image
        Stack(
          alignment: Alignment.center,
          children: [
            Visibility(
              visible: state.downloading ? true : false,
              child: SizedBox(
                height: 65,
                width: 65,
                child: CircularProgressIndicator(
                  value: state.progress,
                  strokeWidth: 1.5,
                  //backgroundColor: Colors.grey,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue)
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(state.downloading ? 15 : 0),
              child: SizedBox(
                height: state.downloading ? 40 : 80,
                width: state.downloading ? 40 :  80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.icon,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),

        //Texts
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //name
              Text(
                widget.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
              //Progress
              Visibility(
                visible: state.downloading ? true : false,
                child: Text(
                  '${(state.progress*100).toStringAsFixed(1)}% of ${widget.size}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    color: Colors.blue.shade200
                  ),
                ),
              ),
              /*SizedBox(
                          width: MediaQuery.of(context).size.width*0.5 - 55,
                          child: Text(
                            about,
                            maxLines: null,
                            style: const TextStyle(
                                fontSize: 11,
                                overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),*/
              const SizedBox(height: 10,),
              Row(
                children: [
                  Column(
                    children: [
                      const Icon(
                        Icons.download_rounded,
                        size: 19,
                      ),
                      Text(
                        widget.size,
                        style: const TextStyle(
                            fontSize: 10
                        ),
                      ),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '|',
                      style: TextStyle(
                          fontSize: 30
                      ),
                    ),
                  ),

                  Column(
                    children: [
                      Text(
                        widget.downloadCount.toString(),
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      const Text(
                        'Downloads',
                        style: TextStyle(
                            fontSize: 10
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buttons(String action) {
    return Row(
      children: [
        //Uninstall button
        action != 'download' ?
        Expanded(
          child: Container(
            //width: MediaQuery.of(context).size.width*0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey.shade400),
              color: Colors.transparent,
            ),
            child:  Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    DeviceApps.uninstallApp(widget.packageName);

                    //print(await File(filePath).exists());
                    //print('/storage/emulated/0/Android/data/com.appgallery.appgallery/files/files/SplitShare.apk');
                    //print('/storage/emulated/0/Download/SplitShare.apk');
                    OpenFile.open('/storage/emulated/0/Download/s.png');
                  },
                  child: Text(
                    'Uninstall',
                    style: TextStyle(color: Colors.blue.shade200, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        )
            :
        const SizedBox(),

        action != 'download' ?
        const SizedBox(width: 10,) : const SizedBox(),

        //Update/open button
        Expanded(
          child: Container(
            //width: MediaQuery.of(context).size.width*0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.blue.shade200,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: action == 'update' ?
                GestureDetector(
                  onTap: () {
                    //_downloadAndOpenFile(context);
                    Download(viewAppBlocProvider).startDownload(
                        widget.name,
                        widget.versionName,
                        widget.fileLink,
                    );
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.black),
                  ),
                )
                    :
                action == 'open' ?
                GestureDetector(
                  onTap: () {
                    DeviceApps.openApp(widget.packageName);
                  },
                  child: const Text(
                    'Open',
                    style: TextStyle(color: Colors.black),
                  ),
                )
                :
                GestureDetector(
                  onTap: () {
                    Download(viewAppBlocProvider).startDownload(widget.name, widget.versionName, widget.fileLink);
                  },
                  child: const Text(
                    'Download',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget cancelButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            //width: MediaQuery.of(context).size.width*0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey.shade400),
              color: Colors.transparent,
            ),
            child:  Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Download(viewAppBlocProvider).cancelDownload();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.blue.shade200, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget space(double size) {
    return SizedBox(height: size,);
  }

  Widget screenShotsWidget() {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: widget.screenshots.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
              height: 170,
              width: 95,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GestureDetector(
                  onTap: () {
                    /*Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ImageViewer(imageUrl: widget.screenshots[index],),)
                    );*/

                    OpenPhoto().openPhotoGallery(context, index, widget.screenshots);
                  },
                  child: Image.network(
                    widget.screenshots[index],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget aboutThisApp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
            'About this app',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14
          ),
        ),

        space(10),

        Text(
          widget.about,
          style: const TextStyle(
              fontSize: 12
          ),
        ),
      ],
    );
  }

}
