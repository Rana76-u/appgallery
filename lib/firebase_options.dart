// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCOMI6huLkWMVG00ue3-LR09M-1n5nuQOY',
    appId: '1:711898608881:web:f8bf7b408150e743cda550',
    messagingSenderId: '711898608881',
    projectId: 'rafiqul-app-gallery',
    authDomain: 'rafiqul-app-gallery.firebaseapp.com',
    storageBucket: 'rafiqul-app-gallery.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDU8QGwsgAbZOWz0j6ebSh6SJXb03ceyFs',
    appId: '1:711898608881:android:ed613318abd0d88dcda550',
    messagingSenderId: '711898608881',
    projectId: 'rafiqul-app-gallery',
    storageBucket: 'rafiqul-app-gallery.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyALdC1u89RZdJBs1FzRhdPvLlifApfGlRg',
    appId: '1:711898608881:ios:282808bcc6bb446acda550',
    messagingSenderId: '711898608881',
    projectId: 'rafiqul-app-gallery',
    storageBucket: 'rafiqul-app-gallery.appspot.com',
    iosBundleId: 'com.appgallery.appgallery',
  );
}