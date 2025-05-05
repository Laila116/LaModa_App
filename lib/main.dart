import 'package:flutter/material.dart';

import 'screens/ProfileScreen.dart';
import 'screens/SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LaModa App',
      theme: ThemeData(primarySwatch: Colors.blue),

      initialRoute: '/',

      routes: {
        '/': (_) => const SplashScreen(),
        '/profile': (_) => const ProfileScreen(),
      },
    );
  }
}
