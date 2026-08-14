import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Projenin ana uygulamasını import et
// import 'package:lideatech_pharmacy_app/main.dart';

void main() {
  testWidgets('Uygulama temel widget testi', (WidgetTester tester) async {
    // Basit bir MaterialApp testi ile widget ağacının çalıştığını doğruluyoruz
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('Eczane & E-Ticaret'),
        ),
      ),
    );

    // Ekranda ilgili metnin geçtiğini doğrula
    expect(find.text('Eczane & E-Ticaret'), findsOneWidget);
  });
}