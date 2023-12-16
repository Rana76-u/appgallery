import 'package:appgallery/Bottom%20Navigation%20Bloc/bottom_navigation_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Presentation/Widgets/navigation_bar.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return BlocProvider<BottomBarBloc>(
      create: (context) => BottomBarBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
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
      ),
    );
  }
}
