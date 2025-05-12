import 'package:flutter/material.dart';

void main() {
  runApp(ECommmerceApp());
}

class ECommmerceApp extends StatelessWidget{
  const ECommmerceApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    home: LoginScreen(),
  );

}
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        body: Padding(
        padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(40)),
              Text(
                "Login Page",
              style: TextStyle(fontSize: 40,
              fontWeight: FontWeight.w600
              ),
              ),
              SizedBox(height: 10,),
              Text("Hi! Welcome back, you've been missed"),
              Padding(padding: EdgeInsets.all(20)),
              Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [Text("E-Mail")],
              ),
              SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  
                  hintText: "Enter your E-Mail",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(40)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown),
                    borderRadius: BorderRadius.circular(40)
                  )
                ),
              ),
              Padding(padding: EdgeInsets.all(20)),
              Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [Text("Password")],
              ),
              SizedBox(height: 10,),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () => null,
                  ),
                  hintText: "Enter your Password",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(40)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown),
                    borderRadius: BorderRadius.circular(40)
                  )
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Text("Forgot Password?",
                style: TextStyle(color: Colors.brown),
                )],
              ),
              Padding(padding: EdgeInsets.all(10)),
              Container(
                height: 50,
                width: double.infinity,
                child:  ElevatedButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NewPassword()));
              }, 
              child: Text("Log in", style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown
                ),
                ),
              ),
                SizedBox(height: 150),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Don't have an account? "), Text("Sign up", style: TextStyle(color: Colors.brown),)],) ],
          ),
        ),
      ),
    );
  }
}

class NewPassword extends StatelessWidget{
  const NewPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Text(
                "New Password",
                style: TextStyle(fontSize: 40,
                fontWeight: FontWeight.w600
                ),
              ),
              Text(
                "Your new password must be different from previously used passwords.",
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Password")
                ],
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () => null,
                  ),
                  hintText: "Enter your new password",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(40)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown),
                    borderRadius: BorderRadius.circular(40)
                  )
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Confirm your new password")
                ],
              ),

                TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () => null,
                  ),
                  hintText: "Confirm password",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(40)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown),
                    borderRadius: BorderRadius.circular(40)
                  )
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(onPressed: () => null,
              child: Text("Create new password",
              style: TextStyle(
                color: Colors.white,
              ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
              ),
              ),
              )
          ]
          ),
          ),
      ),
    );
  }
}
