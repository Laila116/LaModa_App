import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main(){
  runApp(const AddMoney());
}
class AddMoney extends StatelessWidget{
  const AddMoney({super.key});

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [Text("Add Money to your account",
            style: TextStyle(
              fontSize: 20
            ),
          ),
          TextFormField(
            ),
          ]
        ) 
      )
    );
  }
}