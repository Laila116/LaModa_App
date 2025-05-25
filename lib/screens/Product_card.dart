// file: product_card.dart
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  /// Titel des Produkts
  final String title;

  /// Preis als String, z.B. "€19.99" oder "$120.00"
  final String price;

  /// Stern-Rating, z.B. 4.5
  final double rating;

  /// Pfad zum lokalen Asset (oder URL)
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
            Text(rating.toString()),
          ],
        ),
      ],
    );
  }
}
