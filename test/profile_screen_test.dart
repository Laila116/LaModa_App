import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../lib/screens/profile_screen.dart';

// Ein einfacher Mock für FirebaseAuth
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  // Setup für Firebase vor den Tests
  setUpAll(() async {
    // Firebase initialisieren (muss nicht echt verbunden sein)
    await Firebase.initializeApp();
  });

  testWidgets('Complete Profile button is shown and tappable', (WidgetTester tester) async {
    // Widget bauen
    await tester.pumpWidget(
      const MaterialApp(
        home: ProfileScreen(),
      ),
    );

    // Button finden
    final buttonFinder = find.text('Complete Profile');

    // Prüfen ob Button da ist
    expect(buttonFinder, findsOneWidget);

    // Button antippen
    await tester.tap(buttonFinder);
    await tester.pump();
  });
}
