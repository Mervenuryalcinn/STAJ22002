import 'package:flutter_test/flutter_test.dart';
// Projendeki gerçek import yolları:

// Not: ProductBloc'un çalışması için bir repository gerekiyorsa buraya mock veya gerçek repository eklenebilir.

void main() {
  test('ProductBloc initial state test', () {
    // 1. BLoC nesnesini oluşturuyoruz (repository gerektiriyorsa mock verilir)
    // Örnek: final bloc = ProductBloc(productRepository: MockProductRepository());

    // 2. İlk açılış durumunun (Initial State) doğru olduğunu test ediyoruz
    // expect(bloc.state, isA<ProductInitial>());

    // 3. İşimiz bitince BLoC'u kapatıyoruz
    // bloc.close();
  });
}