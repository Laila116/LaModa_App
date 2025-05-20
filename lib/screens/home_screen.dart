import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'Product_card.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextField(
          onChanged: (value) => setState(() => query = value),
          decoration: InputDecoration(
            hintText: 'Search...',
            prefixIcon: Icon(Iconsax.search_normal_copy, color: Colors.brown),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.brown, width: 1),
            ),

            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.brown, width: 1.4),
              borderRadius: BorderRadius.circular(40),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/images/home_bild1.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 8),
              child: Text(
                'Category',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
            ),
            _buildCategoryRow(), // <-- hier die Kategorien-Leiste
            Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: const [
                  ProductCard(),
                  ProductCard(),
                  ProductCard(),
                  ProductCard(),
                  ProductCard(),
                  ProductCard(),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        child: Container(
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(60),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15)],
          ),

          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected:
                (int idx) => setState(() => _currentIndex = idx),

            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            elevation: 8,
            backgroundColor: Colors.transparent,
            // damit die Container-Farbe durchscheint
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
                icon: Icon(
                  Icons.favorite_border,
                  size: 34.0,
                  color: Colors.grey,
                ),
                selectedIcon: Icon(
                  Icons.favorite,
                  size: 34.0,
                  color: Colors.brown,
                ),
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
                icon: Icon(
                  Icons.person_outline,
                  size: 34.0,
                  color: Colors.grey,
                ),
                selectedIcon: Icon(
                  Icons.person,
                  size: 34.0,
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

  Widget _buildCategoryRow() {
    final categories = <Map<String, String>>[
      {'asset': 'assets/icons/Category_icons/mann.png', 'label': 'Männer'},
      {'asset': 'assets/icons/Category_icons/frau(1).png', 'label': 'Frauen'},
      {'asset': 'assets/icons/Category_icons/kind.png', 'label': 'Kinder'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Spread-Operator sorgt dafür, dass die Widgets einzeln eingefügt werden
          ...categories.map((cat) {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Container korrekt abschließen
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.brown.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        cat['asset'] as String,
                        width: 42,
                        height: 42,
                        fit: BoxFit.cover,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(cat['label']!, style: const TextStyle(fontSize: 12)),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
