import 'package:flutter/material.dart';

import '../Widgets/arrow_back.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: arrowBackAppBar(context, title: 'My Profil'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Complete Your Profile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Don't worry only you can see your personal data.\nNo one else will be able to see it.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 25),
              _buildProfileImage(),
              const SizedBox(height: 30),
              _buildFormFields(),
              const SizedBox(height: 40),
              _buildCompleteProfileButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Profilbild mit Edit-Button
  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          const CircleAvatar(
            radius: 65,
            backgroundImage: AssetImage(
              'assets/images/leeren_profilefoto5.png',
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                print('Profilbild ändern');
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.brown,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Textfelder und Dropdown
  Widget _buildFormFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            decoration: _inputDecoration('Name', 'John Doe'),
            onChanged: (value) {
              print('Name geändert: $value');
            },
          ),
          const SizedBox(height: 25),
          const Text(
            'Phone Number',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            keyboardType: TextInputType.phone,
            decoration: _inputDecoration(
              'Telefonnummer',
              '+49 123 4567890',
              icon: Icons.phone,
            ),
            onChanged: (text) {
              print('Telefonnummer geändert: $text');
            },
          ),
          const SizedBox(height: 25),
          const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: _inputDecoration('Select', ''),
            value: selectedGender,
            items:
                ['Männlich', 'Weiblich'].map((gender) {
                  return DropdownMenuItem(value: gender, child: Text(gender));
                }).toList(),
            onChanged: (value) {
              setState(() {
                selectedGender = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // Button "Complete Profile"
  Widget _buildCompleteProfileButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(400, 60),
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: () {
          print('Profil abgeschlossen');
        },
        child: const Text(
          'Complete Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'serif',
          ),
        ),
      ),
    );
  }

  // Helfer für Textfeld-Design
  InputDecoration _inputDecoration(
    String label,
    String hint, {
    IconData? icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.brown, width: 2),
      ),
    );
  }
}
