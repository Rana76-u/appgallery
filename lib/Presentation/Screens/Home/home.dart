import 'package:appgallery/Presentation/Widgets/searchbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Application> _installedApps = [];
  List<String> packageNames = [];
  List<String> versionNames = [];

  @override
  initState() {
    _loadInstalledApps();
    super.initState();
  }

  Future<void> _loadInstalledApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: true,
      includeSystemApps: true,
    );

    _installedApps = apps;
    //print(apps);
    for (int i = 0; i < _installedApps.length; i++) {
      Application app = _installedApps[i];
      packageNames.add(app.packageName);
      versionNames.add(app.versionName ?? '0.0.0');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SearchWidget(),
              loadAllApps(),
            ],
          ),
        ),
      ),
    );
  }

  Widget loadAllApps() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: FutureBuilder(
        future: FirebaseFirestore.instance.collection('apps').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loading();
          } else if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //icon - image
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                            snapshot.data!.docs[index].get('icon')),
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
                            snapshot.data!.docs[index].get('name'),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            snapshot.data!.docs[index].get('about'),
                            style: const TextStyle(
                                fontSize: 11, overflow: TextOverflow.ellipsis),
                          ),
                          Text(
                            snapshot.data!.docs[index].get('size'),
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ),

                    //free space
                    const Expanded(child: SizedBox()),

                    //open btn
                    packageNames.contains(
                            snapshot.data!.docs[index].get('packageName'))
                        ? ElevatedButton(
                            onPressed: () {},
                            child: const Text(
                              'Open',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        : const SizedBox(),
                  ],
                );
              },
            );
          } else {
            return const Center(
              child: Text('Error Loading Data'),
            );
          }
        },
      ),
    );
  }

  Widget loading() {
    return const Center(
      child: LinearProgressIndicator(),
    );
  }
}
