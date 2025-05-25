import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'arrow_back.dart';
import 'my_orders.dart';

class Reviews extends StatelessWidget {
  const Reviews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: arrowBackAppBar(context, title: 'Reviews '),
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
