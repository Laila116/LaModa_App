import 'package:flutter/material.dart';

import 'screens/Product_details_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/new_password_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/Cart_screen.dart';
import 'screens/my_orders.dart';

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
        '/': (ctx) => const SplashScreen(),

        '/login': (ctx) => const LoginScreen(),
        '/profile': (ctx) => const ProfileScreen(),
        '/newPassword': (ctx) => const NewPassword(),
        '/signUp': (ctx) => const SignUpScreen(),
        '/home': (ctx) => const HomeScreen(),
        '/cartScreen': (ctx) => const CartScreen(),
        '/myOrder': (ctx) => const MyOrders(),

        '/ProducktDetails': (ctx) {
          // hier holen wir uns die übergebenen Daten:
          final args =
              ModalRoute.of(ctx)!.settings.arguments as Map<String, dynamic>;
          return ProductDetails(
            title: args['title'],
            price: args['price'],
            rating: args['rating'],
            imagePath: args['imagePath'],
          );
        },
      },
    );
  }
}
