import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../Widgets/clothing_categories_screen.dart';
import '../Widgets/navigationsBar.dart';
import '../Widgets/product_card.dart';
import '../services/auth_service.dart';
import 'cart_screen.dart';
import 'login_screen.dart';
import 'my_orders.dart';
import 'profile_screen.dart';
import 'wish_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  final AuthService authService = AuthService();
  int _currentImageIndex = 0;
  int _currentIndex = 0;
  String query = '';

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_currentIndex) {
      case 0:
        body = _buildHomeContent();
        break;
      case 1:
        body = const CartScreen();
        break;
      case 2:
        body = const WishlistPage();
        break;
      case 3:
        body = const MyOrders();
        break;
      default:
        body = const ProfileScreen();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset('assets/Logo/favicon3-32x32.png', height: 38),
        ),
        title: const Text(
          'LaModa',
          style: TextStyle(color: Colors.brown),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.brown),
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
            icon: const Icon(Icons.logout, color: Colors.brown),
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Abmelden?'),
                  content: const Text('Möchtest du dich wirklich abmelden?'),
                  actions: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.brown),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Nein'),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.brown),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Ja'),
                    ),
                  ],
                ),
              );
              if (shouldLogout == true) {
                await authService.signOut();
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed('/home');
                }
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

  Widget _buildHomeContent() {
    final sliderImages = [
      'assets/images/home_bild1.jpg',
      'assets/images/home_bild2.jpg',
    ];

    final List<Map<String, dynamic>> products = [
      {
        'title': 'Brown Suite',
        'price': '\$120.00',
        'rating': 5.0,
        'image': 'assets/images/home_bild9.jpg',
      },
      {
        'title': 'Brown Jacket',
        'price': '\$83.97',
        'rating': 4.9,
        'image': 'assets/images/home_bild8.jpg',
      },
      {
        'title': 'Blue Jacket',
        'price': '\$95.00',
        'rating': 4.7,
        'image': 'assets/images/home_bild7.jpg',
      },
      {
        'title': 'Gray Suite',
        'price': '\$110.00',
        'rating': 4.8,
        'image': 'assets/images/home_bild5.jpg',
      },
      {
        'title': 'Black Hoodie',
        'price': '\$75.00',
        'rating': 4.6,
        'image': 'assets/images/home_bild6.jpg',
      },
      {
        'title': 'Winter Coat',
        'price': '\$150.00',
        'rating': 4.9,
        'image': 'assets/images/home_bild4.jpg',
      },
    ];

    return ListView(
      padding: const EdgeInsets.only(top: 8),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            onChanged: (value) => setState(() => query = value),
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Iconsax.search_normal_copy, color: Colors.brown),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.brown, width: 1),
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
        const SizedBox(height: 15),
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 150,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            onPageChanged: (idx, _) {
              setState(() => _currentImageIndex = idx);
            },
          ),
          items: sliderImages.map((path) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  path,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 50),
                    );
                  },
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: sliderImages.asMap().entries.map((entry) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentImageIndex == entry.key
                    ? Colors.brown
                    : Colors.grey.shade300,
              ),
            );
          }).toList(),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const BuildCategory(),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Text(
            'Featured Products',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final item = products[index];
              return ProductCard(
                title: item['title'],
                price: item['price'],
                rating: item['rating'],
                imagePath: item['image'],
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}