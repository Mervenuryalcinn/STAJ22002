import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lideatech_pharmacy_app/main.dart';

void main() {
  testWidgets('Pharmacy e-commerce app smoke test', (WidgetTester tester) async {
    // Uygulamamızı ayağa kaldırıyoruz
    await tester.pumpWidget(const MyApp());

    // 500 milisaniyelik gecikmenin ve animasyonların tamamlanmasını bekliyoruz
    await tester.pumpAndSettle();

    // Uygulama açıldığında başlığın göründüğünü doğruluyoruz
    expect(find.text('Eczane Ürünleri'), findsOneWidget);
  });
}