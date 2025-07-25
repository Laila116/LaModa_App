import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/arrow_back.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? selectedGender;

  // Neue TextEditingController für Adressfelder
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  @override
  void dispose() {
    _streetController.dispose();
    _houseNumberController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

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
              const SizedBox(height: 30),
              GeldHinzufuegenWidget(),
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

  // Textfelder und Dropdown inklusive Adressfelder
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

          // NEU: Straße
          const Text('Straße', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _streetController,
            decoration: _inputDecoration('Straße', 'Musterstraße'),
            onChanged: (value) {
              print('Straße geändert: $value');
            },
          ),
          const SizedBox(height: 25),

          // NEU: Hausnummer
          const Text('Hausnummer', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _houseNumberController,
            decoration: _inputDecoration('Hausnummer', '12A'),
            onChanged: (value) {
              print('Hausnummer geändert: $value');
            },
          ),
          const SizedBox(height: 25),

          // NEU: Postleitzahl
          const Text('Postleitzahl', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            keyboardType: TextInputType.number,
            controller: _postalCodeController,
            decoration: _inputDecoration('Postleitzahl', '12345'),
            onChanged: (value) {
              print('Postleitzahl geändert: $value');
            },
          ),
          const SizedBox(height: 25),

          // NEU: Land
          const Text('Land', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _countryController,
            decoration: _inputDecoration('Land', 'Deutschland'),
            onChanged: (value) {
              print('Land geändert: $value');
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
          // Hier kannst du z.B. speichern implementieren
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

class GeldHinzufuegenWidget extends StatefulWidget {
  @override
  _GeldHinzufuegenWidgetState createState() => _GeldHinzufuegenWidgetState();
}

class _GeldHinzufuegenWidgetState extends State<GeldHinzufuegenWidget> {
  final TextEditingController _controller = TextEditingController();
  double _kontostand = 0.0;

  @override
  void initState() {
    super.initState();
    _ladeKontostand();
  }

  Future<void> _ladeKontostand() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    if (snapshot.exists && snapshot.data()!.containsKey('kontostand')) {
      setState(() {
        _kontostand = (snapshot.data()!['kontostand'] as num).toDouble();
      });
    }
  }

  void _geldHinzufuegen() async {
    final eingabe = _controller.text.replaceAll(',', '.');
    final betrag = double.tryParse(eingabe);
    final user = FirebaseAuth.instance.currentUser;

    if (betrag != null && betrag > 0 && user != null) {
      setState(() {
        _kontostand += betrag;
        _controller.clear();
      });

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'kontostand': _kontostand,
      }, SetOptions(merge: true));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte gib einen gültigen Betrag ein.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Kontostand: ${_kontostand.toStringAsFixed(2)} €',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 100,
              child: TextField(
                controller: _controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Betrag',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _geldHinzufuegen,
              child: const Text('Hinzufügen'),
            ),
          ],
        ),
      ],
    );
  }
}
