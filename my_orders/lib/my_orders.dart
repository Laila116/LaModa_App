import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Order(),
    );
  }
}

class Order extends StatelessWidget{
  const Order({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("My Orders"),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(child: ListView(
                children: [
                  Items(title: "Item", size: "XL", qty: 22, price: 21.7, imageLink: "assets/images.jpeg",),
                ],
              ))
            ],
          )
        ),
      )
    );
  } 
}

class Items extends StatelessWidget{
final String title;
final String size;
final int qty;
final double price;
final String imageLink;

  const Items(
    {super.key, required this.title, required this.size, required this.qty, required this.price, required this.imageLink}
    );

  @override
  Widget build(BuildContext context){
    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(image: AssetImage(imageLink),
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
                Text(
                  title
                ),
                Text(
                  style:TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w200
                  ),
                  "Size: $size | | Qty: $qty pcs"
                  ),
                Text(
                  style:TextStyle(
                    fontWeight: FontWeight.w600
                  ),
                  "$price\$"
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                onPressed:() => null, 
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                  ),
                child: Text(
                  style: TextStyle(
                    color: Colors.white
                  ),
                    "Track order"
                  ),
                ),
              ],
            ),
                ],
                ),
                Divider(),
          ],
          
        )
        
              
            );
  }
}

class Review extends StatelessWidget{
  Review({super.key});

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(20),
      
    );
  }
}