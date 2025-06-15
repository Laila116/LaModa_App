import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({Key? key}) : super(key: key);

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  String? _email;
  String? _errorMessage;
  bool _success = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade400, width: 2),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.arrow_back, size: 25, color: Colors.grey),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Passwort zurücksetzen',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Gib deine registrierte E-Mail-Adresse ein. Du erhältst eine E-Mail mit einem Link, um dein Passwort zurückzusetzen.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
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

                // Fehlermeldung oder Erfolg
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (_success)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      "E-Mail zum Zurücksetzen wurde gesendet!",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _errorMessage = null;
                        _success = false;
                      });

                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: _email!,
                          );
                          setState(() => _success = true);
                        } on FirebaseAuthException catch (e) {
                          String msg = "Fehler: ${e.message}";
                          if (e.code == "user-not-found") {
                            msg = "Diese E-Mail ist nicht registriert.";
                          }
                          setState(() => _errorMessage = msg);
                        } catch (e) {
                          setState(() => _errorMessage = "Fehler: $e");
                        }
                      }
                    },
                    child: const Text(
                      "Passwort zurücksetzen",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
