import 'package:flutter/material.dart';

import '../Widgets/arrow_back.dart';
import '../Widgets/product_card.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  static const Color primaryColor = Color(0xFF5C3A1A);
  static const Color bottomBarColor = Color(0xFF1E1E1E);

  //final List<String> filters = ['All', 'Jacket', 'Shirt', 'Pant', 'T-Shirt'];
  //String selectedFilter = 'Jacket';

  final List<Map<String, dynamic>> items = [
    {
      'title': 'Brown Suite',
      'price': '\$120.00',
      'rating': 5.0,
      'image': 'assets/images/jacket_brown_women.jpg',
    },
    {
      'title': 'Brown Suite',
      'price': '\$120.00',
      'rating': 5.0,
      'image': 'assets/images/jacket_beig_women.jpg',
    },
    {
      'title': 'Brown Jacket',
      'price': '\$83.97',
      'rating': 4.9,
      'image': 'assets/images/home_bild6.jpg',
    },
    {
      'title': 'Yellow Shirt',
      'price': '\$120.00',
      'rating': 5.0,
      'image': 'assets/images/jacket_beig_women.jpg',
    },
    {
      'title': 'Brown Hoodie',
      'price': '\$83.97',
      'rating': 4.9,
      'image': 'assets/images/jacket_beig_man.jpg',
    },
    {
      'title': 'Fur Jacket',
      'price': '\$120.00',
      'rating': 5.0,
      'image': 'assets/images/jacket_brown_man2.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: arrowBackAppBar(context, title: 'Wishlist'),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 18,
          crossAxisSpacing: 16,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return ProductCard(
            name: item['title'],
            price: item['price'],
            rating: item['rating'],
            imagePath: item['image'],
          );
        },
      ),
    );
  }
}
