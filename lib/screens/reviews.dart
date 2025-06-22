import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_core/firebase_core.dart';




import 'my_orders.dart';

class Reviews extends StatelessWidget {
  const Reviews({super.key});

  Future<void> uploadReviewToBb() async {
    try{
      await FirebaseFirestore.instance.collection("review").add({
        "comment": "Dein Kommentar hier",
        "rating": 5,
        "timestamp": FieldValue.serverTimestamp(),
        "userId": "user123",
      });
      print("Review erfolgreich gespeichert!");
    } catch (e) {
      print("Fehler beim Speichern: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(1),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
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
        title: Text(
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
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Items(
                key: Key("a"),
                title: "Item",
                size: "XL",
                qty: 22,
                price: 21.7,
                imageLink: "assets/images/images.jpeg",
              ),
              Text(
                "How is your order?",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
              ),
              Divider(),
              Text(
                "Your overall rating",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
              ),
              SizedBox(height: 10),
              RatingBar.builder(
                itemBuilder:
                    (context, _) => Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (value) => value,
              ),
              Divider(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("Add detailed review")],
              ),
              SizedBox(height: 5),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter here",
                ),
              ),
              Divider(),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      fixedSize: Size(190, 50),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      fixedSize: Size(190, 50),
                    ),
                    child: Text(
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
