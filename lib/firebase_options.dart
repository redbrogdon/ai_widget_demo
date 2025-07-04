// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyAc5n-l2-qrnRipUUjUXWWQf7g8j3fKxgU',
    appId: '1:324453570117:web:77138317b49c87f556352c',
    messagingSenderId: '324453570117',
    projectId: 'agenty-90915',
    authDomain: 'agenty-90915.firebaseapp.com',
    storageBucket: 'agenty-90915.firebasestorage.app',
    measurementId: 'G-WDTHE2JBXL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBORvHXeH_eEnr2HwbHxWPGKSTbAFy8KSc',
    appId: '1:324453570117:android:466814e40caae30656352c',
    messagingSenderId: '324453570117',
    projectId: 'agenty-90915',
    storageBucket: 'agenty-90915.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDSYFwcgvdWXN-ouIFqQ0lTiQyFgJLbqak',
    appId: '1:324453570117:ios:12732f131c786b2356352c',
    messagingSenderId: '324453570117',
    projectId: 'agenty-90915',
    storageBucket: 'agenty-90915.firebasestorage.app',
    iosBundleId: 'com.example.aiWidgetDemo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDSYFwcgvdWXN-ouIFqQ0lTiQyFgJLbqak',
    appId: '1:324453570117:ios:12732f131c786b2356352c',
    messagingSenderId: '324453570117',
    projectId: 'agenty-90915',
    storageBucket: 'agenty-90915.firebasestorage.app',
    iosBundleId: 'com.example.aiWidgetDemo',
  );
}
