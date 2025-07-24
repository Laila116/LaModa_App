import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'my_orders.dart'; // Für OrderItem Klasse

class Reviews extends StatefulWidget {
  final OrderItem item;

  const Reviews({super.key, required this.item});

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
        'name': widget.item.name,
        'size': widget.item.size,
        'quantity': widget.item.quantity,
        'price': widget.item.price,
        'image': widget.item.image,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Review submitted successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Fehler beim Senden der Bewertung: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit review")),
      );
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
              ReviewItemTile(
                name: widget.item.name,
                size: widget.item.size,
                quantity: widget.item.quantity,
                price: widget.item.price,
                image: widget.item.image,
              ),
              const SizedBox(height: 10),
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
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
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
                child: Text("Add detailed review"),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _reviewController,
                maxLines: 4,
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

class ReviewItemTile extends StatelessWidget {
  final String name;
  final String size;
  final int quantity;
  final double price;
  final String image;

  const ReviewItemTile({
    super.key,
    required this.name,
    required this.size,
    required this.quantity,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          image,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(name),
      subtitle: Text('Size: $size | Qty: $quantity'),
      trailing: Text('€${price.toStringAsFixed(2)}'),
    );
  }
}
