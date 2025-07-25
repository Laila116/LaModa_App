import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Text changes after tap', (WidgetTester tester) async {
    // Widget in Test-Umgebung einbauen
    await tester.pumpWidget(MaterialApp(home: TapTestWidget()));

    // Anfangszustand prüfen: 'Tap me' ist sichtbar
    expect(find.text('Tap me'), findsOneWidget);
    expect(find.text('Tapped!'), findsNothing);

    // Tap auf das Widget ausführen
    await tester.tap(find.byType(GestureDetector));
    await tester.pump(); // UI-Update erzwingen

    // Jetzt prüfen, ob der Text sich geändert hat
    expect(find.text('Tap me'), findsNothing);
    expect(find.text('Tapped!'), findsOneWidget);
  });
}

class TapTestWidget extends StatefulWidget {
  @override
  _TapTestWidgetState createState() => _TapTestWidgetState();
}

class _TapTestWidgetState extends State<TapTestWidget> {
  bool _tapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _tapped = true),
      child: Container(
        color: Colors.blue,
        child: Center(
          child: Text(_tapped ? 'Tapped!' : 'Tap me'),
        ),
      ),
    );
  }
}
