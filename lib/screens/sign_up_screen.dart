import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  bool _obscurePassword = true; // ← hier
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const SizedBox(), // kein Zurück-Button
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Fill your information below or register with your social account.",
                ),
                const SizedBox(height: 30),

                // E-Mail-Feld
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Name", style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "John Doe",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.brown),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // E-Mail-Feld
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("E-Mail", style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "maxman@gmail.com",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.brown),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte E-Mail eingeben';
                    }
                    if (!EmailValidator.validate(value)) {
                      return 'Ungültiges E-Mail-Format';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value,
                ),

                const SizedBox(height: 15),

                // Passwort-Feld
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Password", style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  obscureText: !this._obscurePassword,
                  decoration: InputDecoration(
                    hintText: "Enter your Password",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.brown,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          this._obscurePassword = !this._obscurePassword;
                        });
                      },
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte Passwort eingeben';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    // Checkbox mit dynamischer Farbe
                    Checkbox(
                      value: isChecked, // dein bool aus dem State
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith<Color>((
                        Set<MaterialState> states,
                      ) {
                        // wenn ausgewählt, blau, sonst rot
                        if (states.contains(MaterialState.selected)) {
                          return Colors.brown;
                        }
                        return Colors.white;
                      }),
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    // Text daneben
                    Expanded(
                      child: Row(
                        children: [
                          const Text('Agree with '),
                          Text(
                            'Terms & Condition',
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.brown,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // Sign-Up-Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Hier Login-Logik oder API-Call
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 70),

                // Sign-Up-Hinweis
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("have already an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.brown,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
