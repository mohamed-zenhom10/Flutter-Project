import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBHZ4CHB6mDFR8XDvqrWyzwy7aS9wDHCD8',
    authDomain: 'tabibak-11eb1.firebaseapp.com',
    projectId: 'tabibak-11eb1',
    storageBucket: 'tabibak-11eb1.firebasestorage.app',
    messagingSenderId: '835363193166',
    appId: '1:835363193166:web:32f31fdce8f184e17b9e1f',
    measurementId: 'G-V1NNG1DBNK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBHZ4CHB6mDFR8XDvqrWyzwy7aS9wDHCD8',
    authDomain: 'tabibak-11eb1.firebaseapp.com',
    projectId: 'tabibak-11eb1',
    storageBucket: 'tabibak-11eb1.firebasestorage.app',
    messagingSenderId: '835363193166',
    appId: '1:835363193166:web:32f31fdce8f184e17b9e1f',
  );
}