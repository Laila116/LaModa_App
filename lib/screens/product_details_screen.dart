import 'package:flutter/material.dart';

import '../Widgets/arrow_back.dart';

class ProductDetails extends StatefulWidget {
  /// Titel des Produkts
  final String name;

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
    required this.name,
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
  bool isFavorite = false;

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
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child:
                          widget.imagePath.startsWith('http')
                              ? Image.network(
                                widget.imagePath,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              )
                              : Image.asset(
                                widget.imagePath,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                    ),
                  ),

                  Positioned(
                    top: 12,
                    right: 12,
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
              const SizedBox(height: 16),

              // Title & description
              Text(
                widget.name,
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
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.shopping_bag,
                    size: 28,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
