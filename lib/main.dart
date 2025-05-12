import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/new_password_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/splash_screen.dart';

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
        '/login': (_) => const LoginScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/newPassword': (_) => const NewPassword(),
        '/signUp': (_) => const CreateAccountPage(),
      },
    );
  }
}
