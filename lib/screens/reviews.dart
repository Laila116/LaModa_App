import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'my_orders.dart'; // Für OrderItem Klasse

class Reviews extends StatefulWidget {
  final OrderItem item;
  final String orderId;

  const Reviews({super.key, required this.item, required this.orderId});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  double _rating = 0.0;
  final TextEditingController _reviewController = TextEditingController();

  Future<void> submitReview() async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .collection('reviews')
          .add({
            'rating': _rating,
            'comment': _reviewController.text.trim(),
            'timestamp': FieldValue.serverTimestamp(),
            'name': widget.item.name,
            'size': widget.item.size,
            'quantity': widget.item.quantity,
            'price': widget.item.price,
            'image': widget.item.image,
          });

      // 2. Zusätzlich zentral speichern unter /reviews
      await FirebaseFirestore.instance.collection('reviews').add({
        'productName': widget.item.name,
        'rating': _rating,
        'comment': _reviewController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Review submitted successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      print("Fehler beim Senden der Bewertung: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to submit review")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,

        title: const Text(
          'Review',
          style: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 28,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Image.asset(widget.item.image, width: 80),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.item.name),
                      Text(
                        "Size: ${widget.item.size} | Qty: ${widget.item.quantity}",
                      ),
                      Text("€${widget.item.price}"),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 10),

              const Text(
                "How is your order?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              const Divider(height: 30),
              const Text(
                "Your overall rating",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 10),
              RatingBar.builder(
                itemBuilder:
                    (context, _) => const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
              ),

              const Divider(),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Add detailed review",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _reviewController,
                maxLines: 4,

                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Write something about your order...",
                ),
              ),
              const Divider(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      fixedSize: const Size(180, 50),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      fixedSize: const Size(180, 50),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
