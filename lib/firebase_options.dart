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
    apiKey: 'AIzaSyBbMp8CIK3b752_Gv9_PQtLp9TM0n-5LbU',
    appId: '1:202171125123:web:eda8295f04c38ae128bab6',
    messagingSenderId: '202171125123',
    projectId: 'ulam4tonyt',
    authDomain: 'ulam4tonyt.firebaseapp.com',
    storageBucket: 'ulam4tonyt.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCEkIgMWnWpn0MUF2kVNDr_qn2EQUFQuU0',
    appId: '1:202171125123:android:f668d597e977ef5b28bab6',
    messagingSenderId: '202171125123',
    projectId: 'ulam4tonyt',
    storageBucket: 'ulam4tonyt.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBNmicVJevp1qDvVkTDEiYWRJSWcZdDxnI',
    appId: '1:202171125123:ios:80799549134f591128bab6',
    messagingSenderId: '202171125123',
    projectId: 'ulam4tonyt',
    storageBucket: 'ulam4tonyt.appspot.com',
    iosClientId: '202171125123-3djid9hjmh7nd9hn8neqap2k7vvgn6lo.apps.googleusercontent.com',
    iosBundleId: 'com.example.ulam4Tonyt',
  );
}
