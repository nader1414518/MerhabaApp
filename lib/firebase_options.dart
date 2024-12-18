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
        return windows;
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
    apiKey: 'AIzaSyBeezApN01XNzDuJME6xp9nrTTuYtm1pE0',
    appId: '1:88705650469:web:06f8db51d953996e5254cc',
    messagingSenderId: '88705650469',
    projectId: 'merhabaapp-2ab80',
    authDomain: 'merhabaapp-2ab80.firebaseapp.com',
    storageBucket: 'merhabaapp-2ab80.firebasestorage.app',
    measurementId: 'G-Q8985EH522',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB2uvhfDEoZvbfVBH2_6RdCIYPFPtYC-_8',
    appId: '1:88705650469:android:2ff25ed32135b7fd5254cc',
    messagingSenderId: '88705650469',
    projectId: 'merhabaapp-2ab80',
    storageBucket: 'merhabaapp-2ab80.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBXj3f7mFugQ1gwf5kxjGqGm4wmzNLsr4I',
    appId: '1:88705650469:ios:49decc25f87f89f15254cc',
    messagingSenderId: '88705650469',
    projectId: 'merhabaapp-2ab80',
    storageBucket: 'merhabaapp-2ab80.firebasestorage.app',
    iosBundleId: 'com.yt.merhabaApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBXj3f7mFugQ1gwf5kxjGqGm4wmzNLsr4I',
    appId: '1:88705650469:ios:49decc25f87f89f15254cc',
    messagingSenderId: '88705650469',
    projectId: 'merhabaapp-2ab80',
    storageBucket: 'merhabaapp-2ab80.firebasestorage.app',
    iosBundleId: 'com.yt.merhabaApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBeezApN01XNzDuJME6xp9nrTTuYtm1pE0',
    appId: '1:88705650469:web:5d75f4b09dfcce765254cc',
    messagingSenderId: '88705650469',
    projectId: 'merhabaapp-2ab80',
    authDomain: 'merhabaapp-2ab80.firebaseapp.com',
    storageBucket: 'merhabaapp-2ab80.firebasestorage.app',
    measurementId: 'G-NSWHH313SR',
  );
}
