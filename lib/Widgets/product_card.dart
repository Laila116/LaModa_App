// file: product_card.dart
import 'package:flutter/material.dart';
import '../screens/product_details_screen.dart';
import '../services/wishlist_service.dart';

class ProductCard extends StatefulWidget {
  final String name;
  final String price;
  final double rating;
  final String imagePath;
  final Color favoriteColor;

  const ProductCard({
    Key? key,
    required this.name,
    required this.price,
    required this.rating,
    required this.imagePath,
    this.favoriteColor = const Color(0xFF5C3A1A),
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final WishlistService _wishlistService = WishlistService();

  @override
  Widget build(BuildContext context) {
    final product = {
      'title': widget.name,
      'price': widget.price,
      'rating': widget.rating,
      'image': widget.imagePath,
    };

    final bool isFavorite = _wishlistService.isInWishlist(product);

    final bool isNetwork = widget.imagePath.startsWith('http');
    final Widget imageWidget = isNetwork
        ? Image.network(
            widget.imagePath,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          )
        : Image.asset(
            widget.imagePath,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetails(
              name: widget.name,
              price: widget.price,
              rating: widget.rating,
              imagePath: widget.imagePath,
            ),
          ),
        );
      },
      child: Column(
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
                  radius: 25,
                  backgroundColor: Colors.white70,
                  child: IconButton(
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border_rounded,
                      color: widget.favoriteColor,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isFavorite) {
                          _wishlistService.removeFromWishlist(product);
                        } else {
                          _wishlistService.addToWishlist(product);
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                widget.price,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(widget.rating.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
