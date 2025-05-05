import 'dart:async';

import 'package:flutter/material.dart';

import 'ProfileScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // zentriert Row horizontal & vertikal
        child: Row(
          mainAxisSize: MainAxisSize.min, // Row nur so breit wie nötig
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Logo/android-chrome-512x512.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(width: 16), // Abstand zwischen Bild und Text
            const Text(
              'aModa',
              style: TextStyle(
                color: Colors.brown,
                fontSize: 60,
                fontFamily: 'laila',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
