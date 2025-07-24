import 'package:flutter/material.dart';
import '../Widgets/arrow_back.dart';
import 'reviews.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  String? orderId;

  @override
  void initState() {
    super.initState();
    saveOrderToFirestore(
      title: "Item",
      size: "XL",
      qty: 22,
      price: 21.7,
      imageLink: "assets/images/home_bild6.jpg",
    );
  }

  Future<void> saveOrderToFirestore({
    required String title,
    required String size,
    required int qty,
    required double price,
    required String imageLink,
  }) async {
    final ordersCollection = FirebaseFirestore.instance.collection('orders');

    final docRef = await ordersCollection.add({
      'title': title,
      'size': size,
      'qty': qty,
      'price': price,
      'imageLink': imageLink,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      orderId = docRef.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: arrowBackAppBar(context, title: 'My Orders'),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    if (orderId != null)
                      Items(
                        key: const Key("a"),
                        orderId: orderId!,
                        title: "Item",
                        size: "XL",
                        qty: 22,
                        price: 21.7,
                        imageLink: "assets/images/home_bild6.jpg",
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Items extends StatefulWidget {
  final String orderId;
  final String title;
  final String size;
  final int qty;
  final double price;
  final String imageLink;

  const Items({
    super.key,
    required this.orderId,
    required this.title,
    required this.size,
    required this.qty,
    required this.price,
    required this.imageLink,
  });

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  void _openReviewPage() async {
    // warte auf Rückkehr von Review-Seite, dann neu laden
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Reviews(orderId: widget.orderId),
      ),
    );

    // nach Rückkehr: Neu bauen, um neue Reviews zu zeigen
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: AssetImage(widget.imageLink),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title),
                  Text(
                    "Size: ${widget.size} | | Qty: ${widget.qty} pcs",
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
                  ),
                  Text(
                    "${widget.price}\$",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _openReviewPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                ),
                child: const Text(
                  "Leave Review",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Alle Reviews anzeigen
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .doc(widget.orderId)
                .collection('reviews')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              final reviews = snapshot.data!.docs;

              if (reviews.isEmpty) {
                return const Text("No reviews yet.");
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: reviews.map((doc) {
                  final comment = doc['comment'] ?? '';
                  final rating = doc['rating'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (rating != null)
                          Text("⭐ ${rating.toString()}", style: const TextStyle(fontSize: 14)),
                        if (comment.isNotEmpty)
                          Text("📝 $comment", style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
