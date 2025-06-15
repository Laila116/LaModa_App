import 'package:flutter/material.dart';

class BuildCategory extends StatelessWidget {
  const BuildCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = <Map<String, String>>[
      {'asset': 'assets/icons/Category_icons/mann.png', 'label': 'Männer'},
      {'asset': 'assets/icons/Category_icons/frau(1).png', 'label': 'Frauen'},
      {'asset': 'assets/icons/Category_icons/kind.png', 'label': 'Kinder'},
      {'asset': 'assets/icons/Category_icons/kleid.png', 'label': 'Kleider'},
      {'asset': 'assets/icons/Category_icons/jacke(2).png', 'label': 'Jacken'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ...categories.map((cat) {
            return Padding(
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
            );
          }).toList(),
        ],
      ),
    );
  }
}
