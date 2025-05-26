// file: product_card.dart
import 'package:flutter/material.dart';

import 'Product_details_screen.dart';

class ProductCard extends StatelessWidget {
  /// Titel des Produkts
  final String title;

  /// Preis als String
  final String price;

  /// Stern-Rating, z.B. 4.5
  final double rating;

  /// Pfad zum lokalen Asset oder Netzbild-URL
  final String imagePath;

  /// Farbe für das Herz-Icon
  final Color favoriteColor;

  const ProductCard({
    Key? key,
    required this.title,
    required this.price,
    required this.rating,
    required this.imagePath,
    this.favoriteColor = const Color(0xFF5C3A1A),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Entscheide automatisch, ob Asset oder Netz-Bild
    final bool isNetwork = imagePath.startsWith('http');
    final Widget imageWidget =
        isNetwork
            ? Image.network(
              imagePath,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            )
            : Image.asset(
              imagePath,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            );

    return GestureDetector(
      onTap: () {
        // Navigation zum Detail-Screen mit allen Produkt-Daten
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ProductDetails(
                  title: title,
                  price: price,
                  rating: rating,
                  imagePath: imagePath,
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
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite_border, color: favoriteColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(price, style: const TextStyle(fontWeight: FontWeight.w500)),
              const Spacer(),
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(rating.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
