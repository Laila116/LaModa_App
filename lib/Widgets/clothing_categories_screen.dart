import 'package:flutter/material.dart';

class BuildCategory extends StatelessWidget {
  final Function(String category) onCategorySelected;

  const BuildCategory({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    final categories = <Map<String, String>>[
      {'asset': 'assets/icons/Category_icons/mann.png', 'label': 'man'},
      {'asset': 'assets/icons/Category_icons/frau(1).png', 'label': 'woman'},
      {'asset': 'assets/icons/Category_icons/kind.png', 'label': 'kids'},
      {'asset': 'assets/icons/Category_icons/kleid.png', 'label': 'dress'},
      {'asset': 'assets/icons/Category_icons/jacke(2).png', 'label': 'Jacket'},
      {'asset': 'assets/icons/Category_icons/icon_pant.png', 'label': 'pant'},
      {
        'asset': 'assets/icons/Category_icons/t-shirt_icon-.png',
        'label': 't-shirt',
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ...categories.map((cat) {
            return GestureDetector(
              onTap: () => onCategorySelected(cat['label']!),
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.brown.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          cat['asset']!,
                          width: 42,
                          height: 42,
                          fit: BoxFit.cover,
                          color: Colors.brown,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(cat['label']!, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
