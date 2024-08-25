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
    apiKey: 'AIzaSyBwV8Un8UKcMqa5Bye1bVFc6TjZqmdDxXU',
    appId: '1:833025637450:web:7eadc238a033923da2bab3',
    messagingSenderId: '833025637450',
    projectId: 'foodgao-ca9a2',
    authDomain: 'foodgao-ca9a2.firebaseapp.com',
    storageBucket: 'foodgao-ca9a2.appspot.com',
    measurementId: 'G-MML39Q9KHY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDuCdbiEDNBXrt224_ZarpSyoV6MYRhpX4',
    appId: '1:833025637450:android:7cc7378b8c544b9fa2bab3',
    messagingSenderId: '833025637450',
    projectId: 'foodgao-ca9a2',
    storageBucket: 'foodgao-ca9a2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCpCLNIsCRvW_URgw7XoIxImCCM1nuC_8k',
    appId: '1:833025637450:ios:4146b1312cd9948ca2bab3',
    messagingSenderId: '833025637450',
    projectId: 'foodgao-ca9a2',
    storageBucket: 'foodgao-ca9a2.appspot.com',
    androidClientId: '833025637450-2jss00315u266jjvuj28ei73uj9n2jtp.apps.googleusercontent.com',
    iosClientId: '833025637450-l74b76ek5c0ep29mrksfq2jnhk4oa5bj.apps.googleusercontent.com',
    iosBundleId: 'com.example.foodgeoPartner',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCpCLNIsCRvW_URgw7XoIxImCCM1nuC_8k',
    appId: '1:833025637450:ios:4146b1312cd9948ca2bab3',
    messagingSenderId: '833025637450',
    projectId: 'foodgao-ca9a2',
    storageBucket: 'foodgao-ca9a2.appspot.com',
    androidClientId: '833025637450-2jss00315u266jjvuj28ei73uj9n2jtp.apps.googleusercontent.com',
    iosClientId: '833025637450-l74b76ek5c0ep29mrksfq2jnhk4oa5bj.apps.googleusercontent.com',
    iosBundleId: 'com.example.foodgeoPartner',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBwV8Un8UKcMqa5Bye1bVFc6TjZqmdDxXU',
    appId: '1:833025637450:web:3d25891be9d4ac85a2bab3',
    messagingSenderId: '833025637450',
    projectId: 'foodgao-ca9a2',
    authDomain: 'foodgao-ca9a2.firebaseapp.com',
    storageBucket: 'foodgao-ca9a2.appspot.com',
    measurementId: 'G-37JGE9L19H',
  );
}
