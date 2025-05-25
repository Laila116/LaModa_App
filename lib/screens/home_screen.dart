import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'NavigationsBar.dart';
import 'Product_card.dart';
import 'clothing_categories_screen.dart';
import 'my_orders.dart';
import 'profile_screen.dart';
import 'reviews.dart';
import 'wish_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
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
        body = Reviews();
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
      appBar: AppBar(backgroundColor: Colors.white),
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
        'title': 'Brown Suite',
        'price': '\$120.00',
        'rating': 5.0,
        'image': 'assets/images/home_bild7.jpg',
      },
      {
        'title': 'Brown Suite',
        'price': '\$120.00',
        'rating': 5.0,
        'image': 'assets/images/home_bild5.jpg',
      },
      {
        'title': 'Brown Suite',
        'price': '\$120.00',
        'rating': 5.0,
        'image': 'assets/images/home_bild5.jpg',
      },
      {
        'title': 'Brown Suite',
        'price': '\$120.00',
        'rating': 5.0,
        'image': 'assets/images/home_bild9.jpg',
      },
    ];

    return ListView(
      padding: const EdgeInsets.only(top: 1),
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
        const BuildCategory(),
        Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            // wichtig, damit der GridView in ListView funktioniert
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
      ],
    );
  }
}
