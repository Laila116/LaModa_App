import 'package:flutter/material.dart';

import '../Widgets/arrow_back.dart';
import 'reviews.dart';
<<<<<<< HEAD
=======
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


>>>>>>> 99c221c (my_orders-Seite mit Firestore)

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: arrowBackAppBar(context, title: 'My Orders'),

        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Items(
                      key: Key("a"),
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

  @override
  void initState() {
    super.initState();
    saveOrderToFirestore(
      title: "title",
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

    await ordersCollection.add({
      'title': title,
      'size': size,
      'qty': qty,
      'price': price,
      'imageLink': imageLink,
      'timestamp': FieldValue.serverTimestamp(),
    });

}
}

class Items extends StatelessWidget {
  final String title;
  final String size;
  final int qty;
  final double price;
  final String imageLink;

  const Items({
    super.key,
    required this.title,
    required this.size,
    required this.qty,
    required this.price,
    required this.imageLink,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: AssetImage(imageLink),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title),
                  Text(
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
                    "Size: $size | | Qty: $qty pcs",
                  ),
                  Text(
                    style: TextStyle(fontWeight: FontWeight.w600),
                    "$price\$",
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Reviews(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                    ),
                    child: Text(
                      style: TextStyle(color: Colors.white),
                      "Leave Review",
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}

