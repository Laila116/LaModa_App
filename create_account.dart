import 'package:flutter/material.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  static const Color primaryColor = Color(0xFF5C3A1A); // Brun élégant

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 48),
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 32),
                _buildInputField(label: "Name"),
                const SizedBox(height: 16),
                _buildInputField(label: "Email", keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildInputField(label: "Password", obscureText: true),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (_) {}),
                    const Expanded(
                      child: Text(
                        'Agree with Terms & Condition',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // logique à ajouter ici
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // aller vers page de login
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: Colors.black54),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}
