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
    apiKey: 'AIzaSyB-5C_xNrm9k5Kvqjbct1jSUmOJXrwb3hg',
    appId: '1:423348992324:web:39b43aaf6ea0d10678ff11',
    messagingSenderId: '423348992324',
    projectId: 'buffaloes-estrus-detection',
    authDomain: 'buffaloes-estrus-detection.firebaseapp.com',
    storageBucket: 'buffaloes-estrus-detection.appspot.com',
    measurementId: 'G-GVCQ2DGEES',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAGWNq-odpJDT12i9kUh__vSaXRhiibyMo',
    appId: '1:423348992324:android:3f93a3344278752978ff11',
    messagingSenderId: '423348992324',
    projectId: 'buffaloes-estrus-detection',
    storageBucket: 'buffaloes-estrus-detection.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDevLNMjkrFwmd29iXj4S6a7b1AbzKYRRI',
    appId: '1:423348992324:ios:97b28694997b056578ff11',
    messagingSenderId: '423348992324',
    projectId: 'buffaloes-estrus-detection',
    storageBucket: 'buffaloes-estrus-detection.appspot.com',
    androidClientId: '423348992324-uvl7407c5gdid5bprofoba0n6kgdhsdg.apps.googleusercontent.com',
    iosClientId: '423348992324-uebekp12jv1pptltda34sud416mg8fi9.apps.googleusercontent.com',
    iosBundleId: 'com.melondev.buffaloesFarmManagement',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDevLNMjkrFwmd29iXj4S6a7b1AbzKYRRI',
    appId: '1:423348992324:ios:97b28694997b056578ff11',
    messagingSenderId: '423348992324',
    projectId: 'buffaloes-estrus-detection',
    storageBucket: 'buffaloes-estrus-detection.appspot.com',
    androidClientId: '423348992324-uvl7407c5gdid5bprofoba0n6kgdhsdg.apps.googleusercontent.com',
    iosClientId: '423348992324-uebekp12jv1pptltda34sud416mg8fi9.apps.googleusercontent.com',
    iosBundleId: 'com.melondev.buffaloesFarmManagement',
  );
}
