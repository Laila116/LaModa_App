import 'package:flutter/material.dart';

import 'arrow_back.dart';

class ProductDetails extends StatefulWidget {
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

  const ProductDetails({
    Key? key,
    required this.title,
    required this.price,
    required this.rating,
    required this.imagePath,
    this.favoriteColor = const Color(0xFF5C3A1A),
  }) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final List<String> sizes = ['S', 'M', 'L', 'XL'];
  String selectedSize = 'M';

  // Available colors and currently selected color
  final List<Color> colors = [
    Colors.brown,
    Colors.black,
    Colors.blueGrey,
    Colors.orange,
  ];
  Color _selectedColor = Colors.brown;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: arrowBackAppBar(context, title: 'Product Details'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child:
                        widget.imagePath.startsWith('http')
                            ? Image.network(widget.imagePath, fit: BoxFit.cover)
                            : Image.asset(widget.imagePath, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 15,
                    right: 15,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.favorite_border, color: Colors.brown),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title & description
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    widget.price,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.star, size: 20, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(widget.rating.toString()),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Here are the details of the brown jacket. It is stylish and comfortable.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 24),

              // Size selector
              const Text('Select Size', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Row(
                children:
                    sizes.map((size) {
                      final bool isSelected = size == selectedSize;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(size),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              selectedSize = size;
                            });
                          },
                          selectedColor: Colors.brown,
                          backgroundColor: Colors.grey.shade200,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 24),

              // Color dropdown
              const Text('Select Color', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              DropdownButton<Color>(
                value: _selectedColor,
                items:
                    colors.map((Color color) {
                      return DropdownMenuItem<Color>(
                        value: color,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (Color? newColor) {
                  if (newColor != null) {
                    setState(() {
                      _selectedColor = newColor;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),

              // Display selections
              Text(
                'Selected Size: $selectedSize',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Selected Color: ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Container(width: 24, height: 24, color: _selectedColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
