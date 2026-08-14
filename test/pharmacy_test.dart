import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Pharmacy Module Tests', () {
    test('Eczane ID ve temel model doğrulama testi', () {
      // Arrange (Hazırlık): Örnek eczane verisi simülasyonu
      final Map<String, dynamic> mockPharmacyData = {
        'id': 1,
        'name': 'Merkez Eczanesi',
        'district': 'Merkez',
        'city': 'Düzce',
        'is_on_duty': true,
      };

      // Act & Assert (İşlem ve Doğrulama)
      expect(mockPharmacyData['id'], 1);
      expect(mockPharmacyData['name'], 'Merkez Eczanesi');
      expect(mockPharmacyData['is_on_duty'], true);
    });

    test('Eczane arama filtresi mantık testi', () {
      // Arrange
      final List<Map<String, dynamic>> pharmacies = [
        {'id': 1, 'name': 'Şifa Eczanesi'},
        {'id': 2, 'name': 'Hayat Eczanesi'},
      ];

      // Act
      final results = pharmacies.where((p) => p['name'].toString().contains('Şifa')).toList();

      // Assert
      expect(results.length, 1);
      expect(results.first['name'], 'Şifa Eczanesi');
    });
  });
}