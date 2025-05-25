import 'package:flutter/material.dart';

import 'arrow_back.dart';
import 'Product_card.dart';

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
      'image': 'assets/images/home_bild3.jpg',
    },
    {
      'title': 'Brown Suite',
      'price': '\$120.00',
      'rating': 5.0,
      'image': 'assets/images/home_bild5.jpg',
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
      'image': 'assets/images/home_bild5.jpg',
    },
    {
      'title': 'Brown Hoodie',
      'price': '\$83.97',
      'rating': 4.9,
      'image': 'assets/images/home_bild7.jpg',
    },
    {
      'title': 'Fur Jacket',
      'price': '\$120.00',
      'rating': 5.0,
      'image': 'assets/images/home_bild8.jpg',
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
            title: item['title'],
            price: item['price'],
            rating: item['rating'],
            imagePath: item['image'],
          );
        },
      ),
    );
  }
}

Widget _buildProductGrid(dynamic items) {
  return GridView.builder(
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
      return _buildProductCard(item);
    },
  );
}

Widget _buildProductCard(Map<String, dynamic> item) {
  final img = item['image'] as String;
  Widget imageWidget;
  if (img.startsWith('http')) {
    imageWidget = Image.network(
      img,
      height: 160,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  } else {
    imageWidget = Image.asset(
      img,
      height: 160,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
  var primaryColor;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageWidget,
          ),
          Positioned(
            top: 8,
            right: 8,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Icon(Icons.favorite_border, color: primaryColor),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Text(item['title'], style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 4),
      Row(
        children: [
          Text(
            item['price'],
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          const Icon(Icons.star, size: 16, color: Colors.amber),
          Text(item['rating'].toString()),
        ],
      ),
    ],
  );
}
