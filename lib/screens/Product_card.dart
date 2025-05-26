// file: product_card.dart
import 'package:flutter/material.dart';

import 'Product_details_screen.dart';

class ProductCard extends StatefulWidget {
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
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    // Entscheide automatisch, ob Asset oder Netz-Bild
    final bool isNetwork = widget.imagePath.startsWith('http');
    final Widget imageWidget =
        isNetwork
            ? Image.network(
              widget.imagePath,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            )
            : Image.asset(
              widget.imagePath,
              height: 200,
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
                  title: widget.title,
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
                      color: isFavorite ? Colors.brown : Colors.brown,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.title,
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
