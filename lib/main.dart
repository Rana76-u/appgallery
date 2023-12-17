import 'package:appgallery/Bottom%20Navigation%20Bloc/bottom_navigation_bloc.dart';
import 'package:appgallery/ViewApp%20Bloc/viewapp_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'Presentation/Widgets/navigation_bar.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl: true // option: set to false to disable working with http links (default: false)
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => BottomBarBloc(),),
          BlocProvider(create: (context) => ViewAppBloc(),),
        ],
        child: MaterialApp(
          title: 'App Gallery',
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.blue,
                  brightness: Brightness.dark
              ),
              useMaterial3: true,
              fontFamily: 'Urbanist'
          ),
          home: const BottomBar(),
          debugShowCheckedModeBanner: false,
        )
    );
  }
}
