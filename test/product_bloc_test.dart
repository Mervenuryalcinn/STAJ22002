import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Temel Unit Test Örneği', () {
    test('Matematiksel ve mantıksal işlem testi', () {
      // Arrange (Hazırlık)
      final int expectedValue = 10;

      // Act (İşlem)
      final int result = 5 + 5;

      // Assert (Doğrulama)
      expect(result, expectedValue);
    });
  });
}