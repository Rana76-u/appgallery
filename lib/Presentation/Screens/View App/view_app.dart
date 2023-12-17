import 'dart:io';

import 'package:appgallery/Presentation/Widgets/image_viewer_gallery.dart';
import 'package:appgallery/ViewApp%20Bloc/viewapp_bloc.dart';
import 'package:appgallery/ViewApp%20Bloc/viewapp_events.dart';
import 'package:appgallery/ViewApp%20Bloc/viewapp_states.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_file/open_file.dart';

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

  @override
  void initState() {
    checkApp();
    super.initState();
  }

  void checkApp() async {
    final blocProvider = BlocProvider.of<ViewAppBloc>(context);

    bool tempIsInstalled =  await DeviceApps.isAppInstalled(widget.packageName);
    blocProvider.add(BoolChange(isInstalled: tempIsInstalled, isUpdateAvailable: false));

    if(tempIsInstalled){
      Application? app = await DeviceApps.getApp(widget.packageName);
      if(app!.versionName != widget.versionName){
        blocProvider.add(BoolChange(isInstalled: tempIsInstalled, isUpdateAvailable: true));
      }
    }
  }

  void open(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: widget.screenshots,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Future<void> _downloadAndOpenFile(BuildContext context) async {
    // Initialize the downloader
    //await FlutterDownloader.initialize();

    print(widget.fileLink);

    final taskId = await FlutterDownloader.enqueue(
      url: widget.fileLink,
      savedDir: '/storage/emulated/0/Download/', // Change this to the desired directory
      saveInPublicStorage: true,
      showNotification: true,
      openFileFromNotification: true,
    );

    FlutterDownloader.registerCallback((id, status, progress) {
      if (id == taskId && status == DownloadTaskStatus.complete) {
        // The download is complete, open the file
        _openDownloadedFile(context);
      }
    });
  }


  Future<void> _openDownloadedFile(BuildContext context) async {
    // Replace 'your_directory' with the same directory used for downloading
    final filePath = '/storage/emulated/0/Download/${widget.name}.apk';

    if (await File(filePath).exists()) {
      OpenFile.open(filePath);
    } else {
      // Handle the case where the file does not exist
      print('File not found');
    }
  }

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

                  topAppInfo(),

                  //space
                  space(20),

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
                    _downloadAndOpenFile(context);
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

  Widget space(double size) {
    return SizedBox(height: size,);
  }

  Widget topAppInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //icon - image
        SizedBox(
          height: 80,
          width: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              widget.icon,
              fit: BoxFit.cover,
            ),
          ),
        ),

        //Texts
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
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
                    open(context, index);
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
