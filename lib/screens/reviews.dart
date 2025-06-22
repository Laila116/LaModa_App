import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'my_orders.dart';

class Reviews extends StatefulWidget {
  const Reviews({super.key});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  double _rating = 0.0;
  final TextEditingController _reviewController = TextEditingController();

  Future<void> submitReview() async {
    try {
      await FirebaseFirestore.instance.collection('reviews').add({
        'rating': _rating,
        'reviewText': _reviewController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'size': 'XL',
        'price': 21.7,
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Review submitted successfully")));
      Navigator.pop(context);
    } catch (e) {
      print("Fehler beim Senden der Bewertung: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to submit review")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(1),
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade400, width: 2),
              ),
              padding: const EdgeInsets.all(2),
              child: const Icon(Icons.arrow_back, size: 30, color: Colors.grey),
            ),
          ),
        ),
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
              const Items(
                key: Key("a"),
                title: "Item",
                size: "XL",
                qty: 22,
                price: 21.7,
                imageLink: "assets/images/home_bild6.jpg",
              ),
              const Text(
                "How is your order?",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
              ),
              const Divider(),
              const Text(
                "Your overall rating",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("Add detailed review")],
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _reviewController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter here",
                ),
              ),
              const Divider(),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      fixedSize: const Size(190, 50),
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
                      fixedSize: const Size(190, 50),
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
