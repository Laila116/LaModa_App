import 'package:flutter/material.dart';

class NavigationsBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const NavigationsBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onTap,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      elevation: 8,
      backgroundColor: Colors.transparent, // oder transparent, je nach Wunsch
      indicatorColor: Colors.white,
      indicatorShape: const CircleBorder(),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined, size: 34.0, color: Colors.grey),
          selectedIcon: Icon(Icons.home, size: 34.0, color: Colors.brown),
          label: '',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.shopping_cart_outlined,
            size: 34.0,
            color: Colors.grey,
          ),
          selectedIcon: Icon(
            Icons.shopping_cart,
            size: 34.0,
            color: Colors.brown,
          ),
          label: '',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_border, size: 34.0, color: Colors.grey),
          selectedIcon: Icon(Icons.favorite, size: 34.0, color: Colors.brown),
          label: '',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.shopping_bag_outlined,
            size: 34.0,
            color: Colors.grey,
          ),
          selectedIcon: Icon(
            Icons.shopping_bag,
            size: 34.0,
            color: Colors.brown,
          ),
          label: '',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline, size: 34.0, color: Colors.grey),
          selectedIcon: Icon(Icons.person, size: 34.0, color: Colors.brown),
          label: '',
        ),
      ],
    );
  }
}
