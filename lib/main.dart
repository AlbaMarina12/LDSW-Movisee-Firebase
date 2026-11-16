import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

import 'screens/home_screen.dart';
import 'theme.dart';

Future<void> main() async {
  // Conexión con Firebase antes de arrancar la app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movisee',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: AppColors.rojo, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
