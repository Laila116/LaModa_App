import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';
import 'new_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  String? _email;
  String? _password;
  String? _errorMessage;
  bool _obscurePassword = true; // ← hier

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const SizedBox(), // kein Zurück-Button
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Sign In',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              const Text("Hi! Welcome back, you've been missed"),
              const SizedBox(height: 30),

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

              const SizedBox(height: 20),

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
                    borderSide: const BorderSide(color: Colors.brown, width: 2),
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

              if (_errorMessage != null) ...[
                SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 5),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NewPassword()),
                    );
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.brown,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Sign-In-Button
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      setState(
                        () => _errorMessage = null,
                      ); // Vorher immer löschen

                      try {
                        await authService.signIn(
                          email: _email!,
                          password: _password!,
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      } on FirebaseAuthException catch (e) {
                        String msg = "falsche Password oder email adreese!";
                        if (e.code == 'user-not-found') {
                          msg = "Kein Nutzer mit dieser E-Mail gefunden.";
                        } else if (e.code == 'wrong-password') {
                          msg = "Falsches Passwort!";
                        }
                        setState(() => _errorMessage = msg);
                      } catch (e) {
                        setState(() => _errorMessage = "Fehler: $e");
                      }
                    }
                  },

                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 120),

              // Sign-Up-Hinweis
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/signUp');
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      "Sign up",
                      style: TextStyle(color: Colors.brown),
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
