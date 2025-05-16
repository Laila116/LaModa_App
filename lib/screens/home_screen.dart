import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String query = '';
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) => setState(() => query = value),
          decoration: InputDecoration(
            hintText: 'Search...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.brown),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.15),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(60),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15)],
          ),

          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected:
                (int idx) => setState(() => _currentIndex = idx),

            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            elevation: 8,
            backgroundColor:
                Colors.transparent, // damit die Container-Farbe durchscheint
            // hier das neue Indicator-Setup:
            indicatorColor: Colors.white,
            indicatorShape: const CircleBorder(),
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, size: 34.0, color: Colors.grey),
                selectedIcon: Icon(Icons.home, size: 34.0, color: Colors.brown),
                label: '',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  size: 32.0,
                  color: Colors.grey,
                ),
                selectedIcon: Icon(
                  Icons.shopping_cart,
                  size: 32.0,
                  color: Colors.brown,
                ),
                label: '',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.favorite_border,
                  size: 32.0,
                  color: Colors.grey,
                ),
                selectedIcon: Icon(
                  Icons.favorite,
                  size: 32.0,
                  color: Colors.brown,
                ),
                label: '',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  size: 32.0,
                  color: Colors.grey,
                ),
                selectedIcon: Icon(
                  Icons.shopping_bag,
                  size: 32.0,
                  color: Colors.brown,
                ),
                label: '',
              ),

              NavigationDestination(
                icon: Icon(
                  Icons.person_outline,
                  size: 32.0,
                  color: Colors.grey,
                ),
                selectedIcon: Icon(
                  Icons.person,
                  size: 32.0,
                  color: Colors.brown,
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
