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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDongIaLreIlel2TnD8KMmK-eijyrHWUF4',
    appId: '1:216275710869:android:db0c008dd598821494bc9c',
    messagingSenderId: '216275710869',
    projectId: 'billy-527ea',
    storageBucket: 'billy-527ea.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDlgPGO16firPgvjppuoKhMN1QNL01qcCc',
    appId: '1:216275710869:ios:4386029f679197be94bc9c',
    messagingSenderId: '216275710869',
    projectId: 'billy-527ea',
    storageBucket: 'billy-527ea.firebasestorage.app',
    androidClientId: '216275710869-n29auq3rao3k74e71p8fkpglu1mcr3rs.apps.googleusercontent.com',
    iosClientId: '216275710869-pvft7hgmoeoci7p2q5s3o705fescn6nu.apps.googleusercontent.com',
    iosBundleId: 'com.example.billy',
  );

}