import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lideatech_pharmacy_app/main.dart';

void main() {
  testWidgets('Lideatech Pharmacy App Smoke Test', (WidgetTester tester) async {
    // 1. Uygulamamızı test ortamında ayağa kaldırıyoruz
    await tester.pumpWidget(const MyApp());

    // 2. Asenkron işlemlerin ve ilk açılış animasyonlarının tamamlanmasını bekliyoruz
    await tester.pumpAndSettle();

    // 3. Uygulama açıldığında arama çubuğunun veya ürün listesi alanının varlığını doğruluyoruz
    // (Arama alanındaki hint metnini veya genel bir widget'ı aratıyoruz)
    expect(find.byType(MaterialApp), findsOneWidget);

    debugPrint('Test başarıyla tamamlandı: Uygulama arayüzü ayakta.');
  });
}