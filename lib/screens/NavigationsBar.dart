import 'package:flutter/material.dart';

class NavigationsBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const NavigationsBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,

      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      elevation: 8,
      backgroundColor: Colors.transparent,
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
