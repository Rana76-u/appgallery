import 'package:appgallery/Blocs/Home%20Bloc/home_bloc.dart';
import 'package:appgallery/Blocs/Home%20Bloc/home_events.dart';
import 'package:appgallery/Blocs/Home%20Bloc/home_states.dart';
import 'package:appgallery/Presentation/Screens/View%20App/view_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Application> _installedApps = [];
  List<String> packageNames = [];
  List<String> versionNames = [];
  List<String> appNames = [];

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

  void performSearch(String searchItem) {
    //matchedIndex.clear();
    BlocProvider.of<HomeBloc>(context).add(UpdateMatchedIndex([]));

    List<int> tempMatchedIndex = [];
    for(int i=0; i<appNames.length; i++){
      if(appNames[i].toLowerCase().contains(searchItem.toLowerCase())){
        tempMatchedIndex.add(i);
      }
    }

    BlocProvider.of<HomeBloc>(context).add(UpdateMatchedIndex(tempMatchedIndex));

  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeStates>(
        listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  //const SearchWidget(),
                  searchBar(state),

                  loadAllApps(state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget loadAllApps(HomeStates states) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: FutureBuilder(
        future: FirebaseFirestore.instance.collection('apps').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loading();
          }
          else if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {

                appNames.add(snapshot.data!.docs[index].get('name'));

                String appPackageName = snapshot.data!.docs[index].get('packageName');
                String appVersionName = snapshot.data!.docs[index].get('versionName');
                bool isInstalled = false;
                bool isUpdateAvailable = false;

                if(packageNames.contains(appPackageName)){
                  isInstalled = true;
                  if(appVersionName != versionNames[packageNames.indexOf(appPackageName)]){
                    isUpdateAvailable = true;
                  }
                }

                if(states.isSearching){
                  if(states.matchedIndex.contains(index)){
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => ViewApp(
                                  docID: snapshot.data!.docs[index].id,
                                  isInstalled: isInstalled,
                                  isUpdateAvailable: isUpdateAvailable,
                                  name: snapshot.data!.docs[index].get('name'),
                                  about: snapshot.data!.docs[index].get('about'),
                                  icon: snapshot.data!.docs[index].get('icon'),
                                  size: snapshot.data!.docs[index].get('size'),
                                  fileLink: snapshot.data!.docs[index].get('fileLink'),
                                  packageName: snapshot.data!.docs[index].get('packageName'),
                                  versionName: snapshot.data!.docs[index].get('versionName'),
                                  downloadCount: snapshot.data!.docs[index].get('downloadCount'),
                                  screenshots: snapshot.data!.docs[index].get('screenshots'),
                                  comments: snapshot.data!.docs[index].get('comments')
                              ),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                {
                                  const begin = Offset(0.0, 1.0);
                                  const end = Offset.zero;
                                  const curve = Curves.ease;

                                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                }
                              },
                            )
                        );
                      },
                      child: Row(
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
                                SizedBox(
                                  width: MediaQuery.of(context).size.width*0.5 - 55,
                                  child: Text(
                                    snapshot.data!.docs[index].get('about'),
                                    style: const TextStyle(
                                        fontSize: 11,
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  ),
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
                          isUpdateAvailable
                              ? ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => ViewApp(
                                        docID: snapshot.data!.docs[index].id,
                                        isInstalled: isInstalled,
                                        isUpdateAvailable: isUpdateAvailable,
                                        name: snapshot.data!.docs[index].get('name'),
                                        about: snapshot.data!.docs[index].get('about'),
                                        icon: snapshot.data!.docs[index].get('icon'),
                                        size: snapshot.data!.docs[index].get('size'),
                                        fileLink: snapshot.data!.docs[index].get('fileLink'),
                                        packageName: snapshot.data!.docs[index].get('packageName'),
                                        versionName: snapshot.data!.docs[index].get('versionName'),
                                        downloadCount: snapshot.data!.docs[index].get('downloadCount'),
                                        screenshots: snapshot.data!.docs[index].get('screenshots'),
                                        comments: snapshot.data!.docs[index].get('comments')
                                    ),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      {
                                        const begin = Offset(0.0, 1.0);
                                        const end = Offset.zero;
                                        const curve = Curves.ease;

                                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      }
                                    },
                                  )
                              );
                            },
                            child: const Text(
                              'Update',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                              : isInstalled ?
                          ElevatedButton(
                            onPressed: () {
                              DeviceApps.openApp(snapshot.data!.docs[index].get('packageName'));
                            },
                            child: const Text(
                              'Open',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                              : const SizedBox(),
                        ],
                      ),
                    );
                  }
                  else{
                    return const SizedBox();
                  }
                }
                else{
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ViewApp(
                                docID: snapshot.data!.docs[index].id,
                                isInstalled: isInstalled,
                                isUpdateAvailable: isUpdateAvailable,
                                name: snapshot.data!.docs[index].get('name'),
                                about: snapshot.data!.docs[index].get('about'),
                                icon: snapshot.data!.docs[index].get('icon'),
                                size: snapshot.data!.docs[index].get('size'),
                                fileLink: snapshot.data!.docs[index].get('fileLink'),
                                packageName: snapshot.data!.docs[index].get('packageName'),
                                versionName: snapshot.data!.docs[index].get('versionName'),
                                downloadCount: snapshot.data!.docs[index].get('downloadCount'),
                                screenshots: snapshot.data!.docs[index].get('screenshots'),
                                comments: snapshot.data!.docs[index].get('comments'),
                            ),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              {
                                const begin = Offset(0.0, 1.0);
                                const end = Offset.zero;
                                const curve = Curves.ease;

                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              }
                            },
                          )
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Row(
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
                                SizedBox(
                                  width: MediaQuery.of(context).size.width*0.5 - 55,
                                  child: Text(
                                    snapshot.data!.docs[index].get('about'),
                                    style: const TextStyle(
                                        fontSize: 11,
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  ),
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
                          isUpdateAvailable
                              ? ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => ViewApp(
                                        docID: snapshot.data!.docs[index].id,
                                        isInstalled: isInstalled,
                                        isUpdateAvailable: isUpdateAvailable,
                                        name: snapshot.data!.docs[index].get('name'),
                                        about: snapshot.data!.docs[index].get('about'),
                                        icon: snapshot.data!.docs[index].get('icon'),
                                        size: snapshot.data!.docs[index].get('size'),
                                        fileLink: snapshot.data!.docs[index].get('fileLink'),
                                        packageName: snapshot.data!.docs[index].get('packageName'),
                                        versionName: snapshot.data!.docs[index].get('versionName'),
                                        downloadCount: snapshot.data!.docs[index].get('downloadCount'),
                                        screenshots: snapshot.data!.docs[index].get('screenshots'),
                                        comments: snapshot.data!.docs[index].get('comments')
                                    ),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      {
                                        const begin = Offset(0.0, 1.0);
                                        const end = Offset.zero;
                                        const curve = Curves.ease;

                                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      }
                                    },
                                  )
                              );
                            },
                            child: const Text(
                              'Update',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                              : isInstalled ?
                          ElevatedButton(
                            onPressed: () {
                              DeviceApps.openApp(snapshot.data!.docs[index].get('packageName'));
                            },
                            child: const Text(
                              'Open',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  );
                }

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

  Widget searchBar(HomeStates states) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: SearchAnchor(
          builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              elevation: MaterialStateProperty.all<double>(0),
              controller: controller,
              backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.blue.shade300.withOpacity(0.1)),
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              onTap: () {
                //controller.openView();
              },
              onChanged: (value) {
                if(value == ''){
                  BlocProvider.of<HomeBloc>(context).add(UpdateIsSearching(false));
                }
                else{
                  BlocProvider.of<HomeBloc>(context).add(UpdateIsSearching(true));
                }
                performSearch(value);
              },
              trailing: const [Icon(Icons.search)],
              hintText: 'Search Applications',
            );
          }, suggestionsBuilder:
          (BuildContext context, SearchController controller) {
        return List<ListTile>.generate(5, (int index) {
          final String item = 'item $index';
          return ListTile(
            title: Text(item),
            onTap: () {
              /*setState(() {
                controller.closeView(item);
              });*/
            },
          );
        });
      }),
    );
  }

  Widget loading() {
    return const Center(
      child: LinearProgressIndicator(),
    );
  }
}
