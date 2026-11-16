// Configuración de Firebase para el proyecto "movisee" (movisee-8fe53).
// Datos tomados de: Firebase console > Configuración del proyecto > Tus apps > Movisee Web.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      default:
        throw UnsupportedError(
          'Por ahora Movisee solo tiene configurado Firebase para Web. '
          'Ejecuta la app con: flutter run -d chrome',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBHsb-P_l4PTRt3S1OKuGZgqe1CXBAlk8w',
    appId: '1:1098792325295:web:1ec93f4fdc77f53092045a',
    messagingSenderId: '1098792325295',
    projectId: 'movisee-8fe53',
    authDomain: 'movisee-8fe53.firebaseapp.com',
    storageBucket: 'movisee-8fe53.firebasestorage.app',
  );
}
