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
  double kontostand = 0.0;

  @override
  void initState() {
    super.initState();
    loadKontostand();
  }

  Future<void> loadKontostand() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    if (userDoc.exists && userDoc.data()!.containsKey('kontostand')) {
      setState(() {
        kontostand = (userDoc['kontostand'] as num).toDouble();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: arrowBackAppBar(context, title: 'My Cart'),
        body: const Center(child: Text('Bitte einloggen')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: arrowBackAppBar(context, title: 'My Cart'),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('carts')
                      .doc(user.uid)
                      .collection('items')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Warenkorb ist leer.'));
                }

                final cartItems =
                    snapshot.data!.docs.map((doc) {
                      final data = doc.data()! as Map<String, dynamic>;
                      return CartItem(
                        name: data['name'],
                        price: (data['price'] as num).toDouble(),
                        size: data['size'],
                        quantity: data['quantity'],
                        image: data['image'],
                        docId: doc.id, // wichtig zum Aktualisieren/Löschen
                      );
                    }).toList();

                double subtotal = cartItems.fold(
                  0,
                  (sum, item) => sum + (item.price * item.quantity),
                );
                double deliveryFee = 25.0;
                //double discount = 35.0;
                double total = subtotal + deliveryFee /*- discount*/;

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (_, index) {
                          final item = cartItems[index];
                          return Dismissible(
                            key: Key(item.name + item.size),
                            direction: DismissDirection.endToStart,
                            onDismissed:
                                (_) => removeItem(user.uid, item.docId),
                            background: Container(
                              alignment: Alignment.centerRight,
                              color: Colors.red.shade100,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            child: ListTile(
                              leading: Image.asset(
                                item.image,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) =>
                                        const Icon(Icons.broken_image),
                              ),
                              title: Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Size: ${item.size} | €${item.price.toStringAsFixed(2)}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed:
                                        () => updateQuantity(
                                          user.uid,
                                          item.docId,
                                          item.quantity - 1,
                                        ),
                                    color: Colors.white,
                                  ),
                                  Text('${item.quantity}'),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed:
                                        () => updateQuantity(
                                          user.uid,
                                          item.docId,
                                          item.quantity + 1,
                                        ),
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.brown,
                                    ),
                                    tooltip: 'Löschen',
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (_) => AlertDialog(
                                              title: const Text(
                                                'Wirklich löschen?',
                                              ),
                                              content: const Text(
                                                'Willst du dieses Produkt aus dem Warenkorb entfernen?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () =>
                                                          Navigator.of(
                                                            context,
                                                          ).pop(),
                                                  child: const Text(
                                                    'Abbrechen',
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    removeItem(
                                                      user.uid,
                                                      item.docId,
                                                    );
                                                  },
                                                  child: const Text(
                                                    'Löschen',
                                                    style: TextStyle(
                                                      color: Colors.brown,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                          // summaryRow('Discount', -discount),
                          const Divider(),
                          summaryRow('Total Cost', total, bold: true),
                          summaryRow('Guthaben', kontostand, bold: true),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => checkout(user.uid, total),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Proceed to Checkout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateQuantity(
    String userId,
    String docId,
    int newQuantity,
  ) async {
    if (newQuantity < 1) return;
    await FirebaseFirestore.instance
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(docId)
        .update({'quantity': newQuantity});
  }

  Future<void> removeItem(String userId, String docId) async {
    await FirebaseFirestore.instance
        .collection('carts')
        .doc(userId)
        .collection('items')
        .doc(docId)
        .delete();
  }

  Future<void> checkout(String userId, double total) async {
    if (kontostand < total) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Nicht genug Guthaben: €${kontostand.toStringAsFixed(2)}',
          ),
        ),
      );
      return;
    }

    final neuerStand = kontostand - total;
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'kontostand': neuerStand,
    });

    final snapshot =
        await FirebaseFirestore.instance
            .collection('carts')
            .doc(userId)
            .collection('items')
            .get();

    final cartItems =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'name': data['name'],
            'price': data['price'],
            'size': data['size'],
            'quantity': data['quantity'],
            'image': data['image'],
          };
        }).toList();

    await FirebaseFirestore.instance.collection('orders').add({
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
      'total': total,
      'items': cartItems,
    });

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    setState(() {
      kontostand = neuerStand;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Checkout erfolgreich!')));
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
              color: label == 'Guthaben' ? Colors.green : null,
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
  String docId; // Zum schnellen Updaten/Löschen in Firestore

  CartItem({
    required this.name,
    required this.price,
    required this.size,
    required this.quantity,
    required this.image,
    required this.docId,
  });
}
