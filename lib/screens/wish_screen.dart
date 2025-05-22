import 'package:flutter/material.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  static const Color primaryColor = Color(0xFF5C3A1A);
  static const Color bottomBarColor = Color(0xFF1E1E1E);

  final List<String> filters = ['All', 'Jacket', 'Shirt', 'Pant', 'T-Shirt'];
  String selectedFilter = 'Jacket';

  final List<Map<String, dynamic>> items = [
    {
      'title': 'Brown Jacket',
      'price': '\$83.97',
      'rating': 4.9,
      'image': 'https://via.placeholder.com/300x400.png?text=Brown+Jacket'
    },
    {
      'title': 'Brown Suite',
      'price': '\$120.00',
      'rating': 5.0,
      'image': 'https://via.placeholder.com/300x400.png?text=Brown+Suite'
    },
    {
      'title': 'Brown Jacket',
      'price': '\$83.97',
      'rating': 4.9,
      'image': 'https://via.placeholder.com/300x400.png?text=Brown+Jacket+2'
    },
    {
      'title': 'Yellow Shirt',
      'price': '\$120.00',
      'rating': 5.0,
      'image': 'https://via.placeholder.com/300x400.png?text=Yellow+Shirt'
    },
    {
      'title': 'Brown Hoodie',
      'price': '\$83.97',
      'rating': 4.9,
      'image': 'https://via.placeholder.com/300x400.png?text=Brown+Hoodie'
    },
    {
      'title': 'Fur Jacket',
      'price': '\$120.00',
      'rating': 5.0,
      'image': 'https://via.placeholder.com/300x400.png?text=Fur+Jacket'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(child: _buildProductGrid()),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: const BackButton(color: Colors.black),
      centerTitle: true,
      title: const Text(
        'My Wishlist',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = filters[index] == selectedFilter;
          return ChoiceChip(
            label: Text(filters[index]),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
            selectedColor: primaryColor,
            backgroundColor: Colors.grey[200],
            selected: isSelected,
            onSelected: (_) {
              setState(() => selectedFilter = filters[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 18,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildProductCard(item);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item['image'],
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: Icon(Icons.favorite_border, color: primaryColor),
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        Text(
          item['title'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              item['price'],
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            const Icon(Icons.star, size: 16, color: Colors.amber),
            Text(item['rating'].toString()),
          ],
        )
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: bottomBarColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.shopping_bag_outlined, color: Colors.white),
          Icon(Icons.favorite, color: Colors.white),
          Icon(Icons.chat_bubble_outline, color: Colors.white),
          Icon(Icons.person_outline, color: Colors.white),
        ],
      ),
    );
  }
}
