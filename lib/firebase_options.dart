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
        return macos;
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
    apiKey: 'AIzaSyDKmOJyb24zDLRUWKJx1Weh7xFMj0JPkaY',
    appId: '1:201453965604:web:df23d2663fd78121be23b1',
    messagingSenderId: '201453965604',
    projectId: 'parkease-58fcc',
    authDomain: 'parkease-58fcc.firebaseapp.com',
    databaseURL: 'https://parkease-58fcc-default-rtdb.firebaseio.com',
    storageBucket: 'parkease-58fcc.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDwEyKgYrvghatv1Xqnpv4O2kWTdDPrUDs',
    appId: '1:201453965604:android:481373ab36e13ebbbe23b1',
    messagingSenderId: '201453965604',
    projectId: 'parkease-58fcc',
    databaseURL: 'https://parkease-58fcc-default-rtdb.firebaseio.com',
    storageBucket: 'parkease-58fcc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCzyM-O2y6mNuQnvZHZOd8wLeK7rxGvcAg',
    appId: '1:201453965604:ios:66f64fe408736316be23b1',
    messagingSenderId: '201453965604',
    projectId: 'parkease-58fcc',
    databaseURL: 'https://parkease-58fcc-default-rtdb.firebaseio.com',
    storageBucket: 'parkease-58fcc.appspot.com',
    iosClientId: '201453965604-blgetdn44862f4oc17n8hvdo6o2q0kjo.apps.googleusercontent.com',
    iosBundleId: 'com.example.zxc',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCzyM-O2y6mNuQnvZHZOd8wLeK7rxGvcAg',
    appId: '1:201453965604:ios:8f5588f2bded6521be23b1',
    messagingSenderId: '201453965604',
    projectId: 'parkease-58fcc',
    databaseURL: 'https://parkease-58fcc-default-rtdb.firebaseio.com',
    storageBucket: 'parkease-58fcc.appspot.com',
    iosClientId: '201453965604-4kvqmr6j2kbah28s19ti59r86uqf9l8g.apps.googleusercontent.com',
    iosBundleId: 'com.example.zxc.RunnerTests',
  );
}