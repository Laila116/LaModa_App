import 'package:flutter/material.dart';
import '../Widgets/product_card.dart';
import '../Widgets/arrow_back.dart';
import '../services/wishlist_service.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final WishlistService _wishlistService = WishlistService();

  @override
  Widget build(BuildContext context) {
    final wishlist = _wishlistService.wishlist.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: arrowBackAppBar(context, title: 'Wishlist'),
      body: wishlist.isEmpty
          ? const Center(
              child: Text(
                'Deine Wunschliste ist leer',
                style: TextStyle(fontSize: 20),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: wishlist.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 18,
                crossAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                final item = wishlist[index];
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
