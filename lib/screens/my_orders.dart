import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/arrow_back.dart';
import 'reviews.dart';

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

    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .get();

    final fetchedOrders = snapshot.docs.map((doc) {
      final data = doc.data();
      final items = (data['items'] as List).map((item) {
        return OrderItem(
          name: item['name'],
          size: item['size'],
          quantity: item['quantity'],
          price: (item['price'] as num).toDouble(),
          image: item['image'],
        );
      }).toList();

      return Order(items: items);
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(child: Text("Keine Bestellungen gefunden."))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (_, index) {
                    final order = orders[index];
                    return Column(
                      children: order.items
                          .map((item) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  OrderTile(item: item),
                                  ReviewList(item: item), // Hier Reviews anzeigen
                                  const Divider(),
                                ],
                              ))
                          .toList(),
                    );
                  },
                ),
    );
  }
}

class Order {
  final List<OrderItem> items;
  Order({required this.items});
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
  const OrderTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(item.image, width: 60, height: 60, fit: BoxFit.cover),
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
                  builder: (_) => Reviews(item: item),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ReviewList extends StatelessWidget {
  final OrderItem item;
  const ReviewList({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // StreamBuilder um passende Reviews aus Firestore zu holen
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reviews')
          .where('name', isEqualTo: item.name)
          .where('size', isEqualTo: item.size)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("Keine Bewertungen vorhanden."),
          );
        }
        final reviews = snapshot.data!.docs;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: reviews.map((doc) {
              final data = doc.data()! as Map<String, dynamic>;
              final rating = data['rating'] ?? 0.0;
              final reviewText = data['reviewText'] ?? "";
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Card(
                  color: Colors.grey[100],
                  child: ListTile(
                    leading: Icon(Icons.star, color: Colors.amber),
                    title: Text("Bewertung: ${rating.toString()}"),
                    subtitle: Text(reviewText),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
