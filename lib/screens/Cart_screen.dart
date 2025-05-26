import 'package:flutter/material.dart';

import 'arrow_back.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Color primaryColor = const Color(0xFF5C3A1A);

  List<CartItem> cartItems = [
    CartItem(
      name: 'Brown Jacket',
      price: 83.97,
      size: 'XL',
      quantity: 1,
      image: 'assets/images/home_bild8.jpg',
    ),
    CartItem(
      name: 'Brown Suite',
      price: 120.00,
      size: 'XL',
      quantity: 1,
      image: 'assets/images/home_bild8.jpg',
    ),
  ];

  void updateQuantity(int index, int change) {
    setState(() {
      cartItems[index].quantity += change;
      if (cartItems[index].quantity < 1) cartItems[index].quantity = 1;
    });
  }

  void removeItem(int index) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Remove from Cart?'),
            content: Text(
              '${cartItems[index].name} - \$${cartItems[index].price}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    cartItems.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(foregroundColor: primaryColor),
                child: const Text('Yes, Remove'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    double deliveryFee = 25.0;
    double discount = 35.0;
    double total = subtotal + deliveryFee - discount;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: arrowBackAppBar(context, title: 'My Cart'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (_, index) {
                final item = cartItems[index];
                return Dismissible(
                  key: Key(item.name),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => removeItem(index),
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red.shade100,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      'assets/images/home_bild8.jpg',
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Size: ${item.size}\n\$${item.price.toStringAsFixed(2)}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => updateQuantity(index, -1),
                          color: primaryColor,
                        ),
                        Text('${item.quantity}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => updateQuantity(index, 1),
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Promo Code',
                    suffixIcon: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Apply',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                summaryRow('Sub-Total', subtotal),
                summaryRow('Delivery Fee', deliveryFee),
                summaryRow('Discount', -discount),
                const Divider(),
                summaryRow('Total Cost', total, bold: true),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Proceed to Checkout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget summaryRow(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  String name;
  double price;
  String size;
  int quantity;
  String image;

  CartItem({
    required this.name,
    required this.price,
    required this.size,
    required this.quantity,
    required this.image,
  });
}
