import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import '../Widgets/arrow_back.dart'; // Nicht mehr gebraucht
import 'reviews.dart'; // Entfernen, falls nicht benötigt

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
    if (user == null) {
      setState(() {
        orders = [];
        isLoading = false;
      });
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .get();

      final fetchedOrders = snapshot.docs.map((doc) {
        final data = doc.data();

        // Absichern, dass 'items' existiert und eine Liste ist
        final itemsRaw = data['items'];
        if (itemsRaw == null || itemsRaw is! List) {
          return Order(items: []);
        }

        final items = itemsRaw.map<OrderItem?>((item) {
          if (item is Map<String, dynamic>) {
            try {
              return OrderItem(
                name: item['name'] ?? 'Unknown',
                size: item['size'] ?? 'N/A',
                quantity: (item['quantity'] is int)
                    ? item['quantity'] as int
                    : int.tryParse(item['quantity'].toString()) ?? 1,
                price: (item['price'] is num)
                    ? (item['price'] as num).toDouble()
                    : double.tryParse(item['price'].toString()) ?? 0.0,
                image: item['image'] ?? '',
              );
            } catch (e) {
              return null;
            }
          }
          return null;
        }).whereType<OrderItem>().toList();

        return Order(items: items);
      }).toList();

      setState(() {
        orders = fetchedOrders;
        isLoading = false;
      });
    } catch (e) {
      // Fehler abfangen
      setState(() {
        orders = [];
        isLoading = false;
      });
      print('Fehler beim Laden der Bestellungen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'My Orders',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: isLoading
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            OrderTile(item: item),
                                            const Divider(),
                                          ],
                                        ))
                                    .toList(),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
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
      leading: item.image.isNotEmpty
          ? Image.asset(
              item.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            )
          : const SizedBox(
              width: 60,
              height: 60,
              child: Icon(Icons.image_not_supported),
            ),
      title: Text(item.name),
      subtitle: Text('Size: ${item.size} | Qty: ${item.quantity}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('€${item.price.toStringAsFixed(2)}'),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
            ),
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
