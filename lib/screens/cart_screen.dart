import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Color primaryColor = const Color(0xFF5C3A1A);
  List<CartItem> cartItems = [];
  double kontostand = 0.0;

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('carts')
            .doc(user.uid)
            .collection('items')
            //.orderBy('timestamp', descending: true)
            .get();

    final items =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return CartItem(
            name: data['name'],
            price: (data['price'] as num).toDouble(),
            size: data['size'],
            quantity: data['quantity'],
            image: data['image'],
          );
        }).toList();

    final userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    if (userDoc.exists && userDoc.data()!.containsKey('kontostand')) {
      setState(() {
        cartItems = items;
        kontostand = (userDoc['kontostand'] as num).toDouble();
      });
    }
  }

  void updateQuantity(int index, int change) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final item = cartItems[index];
    final newQuantity = item.quantity + change;
    if (newQuantity < 1) return;

    setState(() {
      cartItems[index].quantity = newQuantity;
    });

    final snapshot =
        await FirebaseFirestore.instance
            .collection('carts')
            .doc(user.uid)
            .collection('items')
            .where('name', isEqualTo: item.name)
            .where('size', isEqualTo: item.size)
            .get();

    for (var doc in snapshot.docs) {
      doc.reference.update({'quantity': newQuantity});
    }
  }

  Future<void> removeItem(int index) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final item = cartItems[index];

    final snapshot =
        await FirebaseFirestore.instance
            .collection('carts')
            .doc(user.uid)
            .collection('items')
            .where('name', isEqualTo: item.name)
            .where('size', isEqualTo: item.size)
            .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    double deliveryFee = 25.0;
    //double discount = 35.0;
    double total = subtotal + deliveryFee /*- discount */;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,

        title: const Text(
          'My Cart',
          style: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 28,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (_, index) {
                final item = cartItems[index];
                return Dismissible(
                  key: Key('${item.name}_${item.size}_${item.image}'),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => removeItem(index),
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.brown.shade100,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.brown),
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      item.image,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(Icons.broken_image),
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Size: ${item.size} | €${item.price.toStringAsFixed(2)}',
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
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.brown),
                          tooltip: 'Löschen',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (_) => AlertDialog(
                                    backgroundColor: Colors.brown[50],
                                    title: const Text(
                                      'Wirklich löschen?',
                                      style: TextStyle(
                                        color: Colors.brown, // Titel-Farbe
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: const Text(
                                      'Willst du dieses Produkt aus dem Warenkorb entfernen?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.of(context).pop(),
                                        child: const Text(
                                          'Abbrechen',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          removeItem(index);
                                        },
                                        child: const Text(
                                          'Löschen',
                                          style: TextStyle(
                                            color: Colors.red, // Löschen-Farbe
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            );
                          },
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
                summaryRow('Sub-Total', subtotal),
                summaryRow('Delivery ', deliveryFee),
                //summaryRow('Discount', -discount),
                const Divider(),
                summaryRow('Total Cost', total, bold: true),
                summaryRow('Your Credit', kontostand, bold: true),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) return;

                      if (kontostand >= total) {
                        final neuerStand = kontostand - total;
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .update({'kontostand': neuerStand});

                        // Bestellung speichern
                        final ordersCollection = FirebaseFirestore.instance
                            .collection('orders');
                        await ordersCollection.add({
                          'userId': user.uid,
                          'timestamp': FieldValue.serverTimestamp(),
                          'total': total,
                          'items':
                              cartItems
                                  .map(
                                    (item) => {
                                      'name': item.name,
                                      'price': item.price,
                                      'size': item.size,
                                      'quantity': item.quantity,
                                      'image': item.image,
                                    },
                                  )
                                  .toList(),
                        });

                        // Warenkorb leeren
                        final itemsSnapshot =
                            await FirebaseFirestore.instance
                                .collection('carts')
                                .doc(user.uid)
                                .collection('items')
                                .get();

                        for (var doc in itemsSnapshot.docs) {
                          await doc.reference.delete();
                        }

                        setState(() {
                          cartItems.clear();
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Checkout erfolgreich!'),
                          ),
                        );

                        await showDialog(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                title: const Text('Erfolg!'),
                                content: const Text(
                                  'Deine Bestellung wurde erfolgreich aufgegeben.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Nicht genug Guthaben: €${kontostand.toStringAsFixed(2)}',
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Proceed to Checkout',
                      style: TextStyle(color: Colors.white, fontSize: 20),
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
            '€${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: label == 'Your Credit' ? Colors.green : null,
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
