import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/arrow_back.dart';
import 'reviews.dart'; // Kannst du entfernen, wenn du Reviews hier nicht mehr brauchst

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<Order> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadOrders();
  }

  Future<void> loadOrders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .get();

    final fetchedOrders =
        snapshot.docs.map((doc) {
          final data = doc.data();
          final items =
              (data['items'] as List).map((item) {
                return OrderItem(
                  name: item['name'],
                  size: item['size'],
                  quantity: item['quantity'],
                  price: (item['price'] as num).toDouble(),
                  image: item['image'],
                );
              }).toList();

          return Order(orderId: doc.id, items: items);
        }).toList();

    setState(() {
      orders = fetchedOrders;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: arrowBackAppBar(context, title: 'My Orders'),
      backgroundColor: Colors.white,
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : orders.isEmpty
              ? const Center(child: Text("Keine Bestellungen gefunden."))
              : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (_, index) {
                  final order = orders[index];
                  return Column(
                    children:
                        order.items
                            .map(
                              (item) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  OrderTile(item: item, orderId: order.orderId),
                                  // ReviewList entfernt!
                                  const Divider(),
                                ],
                              ),
                            )
                            .toList(),
                  );
                },
              ),
    );
  }
}

class Order {
  final String orderId;
  final List<OrderItem> items;
  Order({required this.orderId, required this.items});
}

class OrderItem {
  final String name;
  final String size;
  final int quantity;
  final double price;
  final String image;

  OrderItem({
    required this.name,
    required this.size,
    required this.quantity,
    required this.price,
    required this.image,
  });
}

class OrderTile extends StatelessWidget {
  final OrderItem item;
  final String orderId;
  const OrderTile({super.key, required this.item, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        item.image,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      ),
      title: Text(item.name),
      subtitle: Text('Size: ${item.size} | Qty: ${item.quantity}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('€${item.price.toStringAsFixed(2)}'),
          const SizedBox(width: 10),
          ElevatedButton(
            child: const Text("Review"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Reviews(item: item, orderId: orderId),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
