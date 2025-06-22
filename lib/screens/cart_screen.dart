import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Widgets/arrow_back.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Color primaryColor = const Color(0xFF5C3A1A);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<CartItem> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        QuerySnapshot snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .get();

        if (mounted) {
          setState(() {
            cartItems = snapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return CartItem(
                id: doc.id,
                name: data['name'] ?? '',
                price: (data['price'] ?? 0.0).toDouble(),
                size: data['size'] ?? '',
                quantity: data['quantity'] ?? 1,
                image: data['image'] ?? 'assets/images/home_bild8.jpg',
              );
            }).toList();
            isLoading = false;
          });
        }
      } else {
        // Pas d'utilisateur connecté = panier vide
        if (mounted) {
          setState(() {
            cartItems = []; // PANIER VIDE - PLUS DE LIMITE À 2 ARTICLES
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print('Erreur lors du chargement du panier: $e');
    }
  }

  void updateQuantity(int index, int change) {
    if (mounted) {
      setState(() {
        cartItems[index].quantity += change;
        if (cartItems[index].quantity < 1) cartItems[index].quantity = 1;
      });
    }

    _updateQuantityInFirebase(index);
  }

  Future<void> _updateQuantityInFirebase(int index) async {
    User? user = _auth.currentUser;
    if (user != null && cartItems[index].id.isNotEmpty) {
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(cartItems[index].id)
            .update({'quantity': cartItems[index].quantity});
      } catch (e) {
        print('Erreur lors de la mise à jour de la quantité: $e');
      }
    }
  }

  void removeItem(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove from Cart?'),
        content: Text(
          '${cartItems[index].name} - \$${cartItems[index].price.toStringAsFixed(2)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _removeItemFromFirebase(index);
              if (mounted) {
                setState(() {
                  cartItems.removeAt(index);
                });
              }
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: primaryColor),
            child: const Text('Yes, Remove'),
          ),
        ],
      ),
    );
  }

  Future<void> _removeItemFromFirebase(int index) async {
    User? user = _auth.currentUser;
    if (user != null && cartItems[index].id.isNotEmpty) {
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(cartItems[index].id)
            .delete();
      } catch (e) {
        print('Erreur lors de la suppression: $e');
      }
    }
  }

  // Refresh cart when returning to screen
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent == true) {
      _loadCartItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: arrowBackAppBar(context, title: 'My Cart'),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    double subtotal = cartItems.fold(
      0,
          (sum, item) => sum + (item.price * item.quantity),
    );
    double deliveryFee = cartItems.isNotEmpty ? 25.0 : 0.0;
    double discount = cartItems.isNotEmpty ? 35.0 : 0.0;
    double total = subtotal + deliveryFee - discount;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: arrowBackAppBar(context, title: 'My Cart'),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add unlimited products to get started!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
                : RefreshIndicator(
              onRefresh: _loadCartItems,
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (_, index) {
                  final item = cartItems[index];
                  return Dismissible(
                    key: Key(item.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => removeItem(index),
                    background: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.red.shade100,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.red),
                    ),
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      elevation: 2,
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item.image,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 64,
                                height: 64,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported),
                              );
                            },
                          ),
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
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => updateQuantity(index, -1),
                              color: primaryColor,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => updateQuantity(index, 1),
                              color: primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (cartItems.isNotEmpty) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Promo Code',
                      suffixIcon: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Promo code functionality coming soon!')),
                          );
                        },
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
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Proceeding to checkout with ${cartItems.length} items!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
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
  String id;
  String name;
  double price;
  String size;
  int quantity;
  String image;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.size,
    required this.quantity,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'size': size,
      'quantity': quantity,
      'image': image,
    };
  }
}