import 'package:flutter/material.dart';
import '../Widgets/product_card.dart';
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Wishlist',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: wishlist.isEmpty
                    ? const Center(
                        child: Text(
                          'Your wishlist is empty.',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: wishlist.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
