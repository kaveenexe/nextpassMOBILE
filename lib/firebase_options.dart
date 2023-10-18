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
    apiKey: 'AIzaSyAaNWr8uXAgBKBLDiPcIQxaRhMlBVBA3Hw',
    appId: '1:688015933676:web:ad5730197f9ee9351365c9',
    messagingSenderId: '688015933676',
    projectId: 'nextpass-51ccb',
    authDomain: 'nextpass-51ccb.firebaseapp.com',
    databaseURL: 'https://nextpass-51ccb-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'nextpass-51ccb.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDSdTuGlwpLH5co4uKftyAVScRd3BhYLEc',
    appId: '1:688015933676:android:1c65923a70431b8a1365c9',
    messagingSenderId: '688015933676',
    projectId: 'nextpass-51ccb',
    databaseURL: 'https://nextpass-51ccb-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'nextpass-51ccb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAEo-YWeBs5jsWOkatTercJLLVI-NvOkrE',
    appId: '1:688015933676:ios:51ff9d14a203f6c71365c9',
    messagingSenderId: '688015933676',
    projectId: 'nextpass-51ccb',
    databaseURL: 'https://nextpass-51ccb-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'nextpass-51ccb.appspot.com',
    iosBundleId: 'com.example.nextpass',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAEo-YWeBs5jsWOkatTercJLLVI-NvOkrE',
    appId: '1:688015933676:ios:643bced11a44796b1365c9',
    messagingSenderId: '688015933676',
    projectId: 'nextpass-51ccb',
    databaseURL: 'https://nextpass-51ccb-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'nextpass-51ccb.appspot.com',
    iosBundleId: 'com.example.nextpass.RunnerTests',
  );
}