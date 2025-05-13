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
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "My Orders",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 50,
              ),

              Items(title: "Item1", size: "XL", qty: "3", price: "11",),
              Items(title: "Item2", size: "XL", qty: "2", price: "22",),
              Items(title: "Item3", size: "XL", qty: "1", price: "33",),
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
final String qty;
final String price;

  const Items(
    {super.key, required this.title, required this.size, required this.qty, required this.price}
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
            Icon(Icons.image),
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
                  price
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
            )
                ],
                ),
                Divider(),
          ],
          
        )
        
              
            );
  }
}