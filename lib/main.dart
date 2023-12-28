import 'package:appgallery/Blocs/Home%20Bloc/home_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Blocs/Bottom Navigation Bloc/bottom_navigation_bloc.dart';
import 'Blocs/ViewApp Bloc/viewapp_bloc.dart';
import 'Models/firebase_api.dart';
import 'Presentation/Widgets/navigation_bar.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
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
          BlocProvider(create: (context) => HomeBloc(),)
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
