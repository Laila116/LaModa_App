import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/arrow_back.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Color primaryColor = const Color(0xFF5C3A1A);

  List<CartItem> cartItems = [];

  void updateQuantity(int index, int change) {
    setState(() {
      cartItems[index].quantity += change;
      if (cartItems[index].quantity < 1) cartItems[index].quantity = 1;
    });
  }

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  Future<void> removeItem(int index) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final item = cartItems[index];

    await FirebaseFirestore.instance
        .collection('carts')
        .doc(user.uid)
        .collection('items')
        .where('name', isEqualTo: item.name) // oder nutze itemId wenn du hast
        .get()
        .then((snapshot) {
          for (var doc in snapshot.docs) {
            doc.reference.delete();
          }
        });

    setState(() {
      cartItems.removeAt(index);
    });

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
                      'assets/images/Jackets/jacket_brown_man2.jpg',
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

  Future<void> loadCartItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('carts')
            .doc(user.uid)
            .collection('items')
            .get();

    final items =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return CartItem(
            name: data['name'],
            price: data['price'].toDouble(),
            size: data['size'],
            quantity: data['quantity'],
            image: data['image'],
          );
        }).toList();

    setState(() {
      cartItems = items;
    });
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
