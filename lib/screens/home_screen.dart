import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../Widgets/clothing_categories_screen.dart';
import '../Widgets/navigationsBar.dart';
import '../Widgets/product_card.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';
import 'cart_screen.dart';
import 'login_screen.dart';
import 'my_orders.dart';
import 'profile_screen.dart';
import 'wish_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final AuthService authService = AuthService();
  final ProductService productService = ProductService();

  int _currentImageIndex = 0;
  int _currentIndex = 0;
  String query = '';
  String selectedCategory = ''; // '' = alle

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_currentIndex) {
      case 0:
        body = _buildHomeContent();
        break;
      case 1:
        body = CartScreen();
        break;
      case 2:
        body = WishlistPage();
        break;
      case 3:
        body = MyOrders();
        break;
      default:
        body = ProfileScreen();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Logo LINKS
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            child: Image.asset('assets/Logo/favicon3-32x32.png', height: 38),
          ),
        ),
        // (Optional:) Titel in die Mitte
        title: const Text('LaModa', style: TextStyle(color: Colors.brown)),
        // oder null
        centerTitle: true,
        // Icons RECHTS
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.brown),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
          IconButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.brown),
            ),
            icon: Icon(Icons.logout, color: Colors.brown),
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Abmelden?'),
                      content: const Text(
                        'Möchtest du dich wirklich abmelden?',
                      ),
                      actions: [
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.brown,
                            ),
                            foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white,
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Nein'),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.brown,
                            ),
                            foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white,
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Ja'),
                        ),
                      ],
                    ),
              );
              if (shouldLogout == true) {
                await authService.signOut(); // <-- Deine Methode!
                Navigator.of(context).pushReplacementNamed('/home');
              }
            },
          ),
        ],
      ),

      body: body,
      bottomNavigationBar: NavigationsBar(
        selectedIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
      ),
    );
  }

  // Ausgelagerter Home-Content für Übersichtlichkeit:
  Widget _buildHomeContent() {
    final sliderImages = [
      'assets/images/home_bild1.jpg',
      'assets/images/home_bild2.jpg',
    ];

    return ListView(
      padding: const EdgeInsets.only(top: 8),
      children: [
        TextField(
          onChanged: (value) => setState(() => query = value),
          decoration: InputDecoration(
            hintText: 'Search...',
            prefixIcon: Icon(Iconsax.search_normal_copy, color: Colors.brown),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.brown, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.brown, width: 1.4),
              borderRadius: BorderRadius.circular(40),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 15),
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 150,
            autoPlay: false,
            autoPlayInterval: Duration(seconds: 5),
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            onPageChanged: (idx, _) {
              setState(() => _currentImageIndex = idx);
            },
          ),
          items:
              sliderImages.map((path) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      path,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                );
              }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              sliderImages.asMap().entries.map((entry) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentImageIndex == entry.key
                            ? Colors.brown
                            : Colors.grey.shade300,
                  ),
                );
              }).toList(),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 0, 8),
          child: Text(
            'Category',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
        BuildCategory(
          onCategorySelected: (category) {
            setState(() {
              selectedCategory = category;
            });
          },
        ),

        Padding(
          padding: const EdgeInsets.all(12),
          child: StreamBuilder(
            stream: productService.getProductsStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Fehler: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final products = snapshot.data!.docs;

              final filteredProducts =
                  products.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    // Sicherheitsprüfung
                    if (!data.containsKey('name') ||
                        !data.containsKey('category'))
                      return false;

                    final name = doc['name'].toString().toLowerCase();
                    final categories = List<String>.from(data['category']);
                    final matchesSearch = name.contains(query.toLowerCase());
                    final matchesCategory =
                        selectedCategory.isEmpty ||
                        categories.contains(selectedCategory);
                    if (kDebugMode) {
                      print('Kategorie: $selectedCategory | Suche: $query');
                    }

                    return matchesSearch && matchesCategory;
                  }).toList();

              if (filteredProducts.isEmpty) {
                return Center(
                  child: Text(
                    'Keine Produkte gefunden',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                );
              }

              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product =
                      filteredProducts[index].data() as Map<String, dynamic>;
                  return ProductCard(
                    name: product['name'],
                    price: '${product['price']} €',
                    rating: product['rating'].toDouble(),
                    imagePath: product['image'],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
