import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

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
      default:
        throw UnsupportedError(
          'Firebase is not configured for this platform. Run flutterfire configure.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAF-em63WFDjRUe5MvnQtfC6FMiY3dUt7s',
    appId: '1:492695049068:web:69bd119edc1b9f30881949',
    messagingSenderId: '492695049068',
    projectId: 'flutter-keys-cfffa',
    authDomain: 'flutter-keys-cfffa.firebaseapp.com',
    storageBucket: 'flutter-keys-cfffa.firebasestorage.app',
    measurementId: 'G-D4C8GMQ0LJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAwwQvHy3GM2RRcrGBgw57q7W7nwkNnThA',
    appId: '1:492695049068:android:ae8e6bf2302ec417881949',
    messagingSenderId: '492695049068',
    projectId: 'flutter-keys-cfffa',
    storageBucket: 'flutter-keys-cfffa.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDSj-YJ3MpvpYmwGTc7RqCPt7ojuB133q0',
    appId: '1:492695049068:ios:5a6b6d29742785c6881949',
    messagingSenderId: '492695049068',
    projectId: 'flutter-keys-cfffa',
    storageBucket: 'flutter-keys-cfffa.firebasestorage.app',
    iosBundleId: 'com.example.keys',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDSj-YJ3MpvpYmwGTc7RqCPt7ojuB133q0',
    appId: '1:492695049068:ios:5a6b6d29742785c6881949',
    messagingSenderId: '492695049068',
    projectId: 'flutter-keys-cfffa',
    storageBucket: 'flutter-keys-cfffa.firebasestorage.app',
    iosBundleId: 'com.example.keys',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAF-em63WFDjRUe5MvnQtfC6FMiY3dUt7s',
    appId: '1:492695049068:web:ce3bee7c5d30fa0f881949',
    messagingSenderId: '492695049068',
    projectId: 'flutter-keys-cfffa',
    authDomain: 'flutter-keys-cfffa.firebaseapp.com',
    storageBucket: 'flutter-keys-cfffa.firebasestorage.app',
    measurementId: 'G-ZS57TENMR4',
  );

}
