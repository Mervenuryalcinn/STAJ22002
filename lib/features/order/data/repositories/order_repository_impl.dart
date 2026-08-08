import 'package:dio/dio.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_model.dart'; // <-- Model sınıfını içeri aktarıyoruz

class OrderRepositoryImpl implements OrderRepository {
  final Dio dio;

  OrderRepositoryImpl({required this.dio});

  @override
  Future<List<OrderEntity>> getOrders(String userId) async {
    try {
      print('========================================');
      print('📦 SİPARİŞLER GETİRİLİYOR');
      print('👤 USER ID: $userId');
      print('========================================');

      final response = await dio.get(
        '/orders',
        queryParameters: {
          'user_id': userId,
        },
      );

      print('📦 ORDERS RESPONSE: ${response.data}');

      final List data = response.data['result'] ?? [];

      // OrderModel kullanarak dönüşüm yapıyoruz (items ve createdAt hatası biter)
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      print('❌ SİPARİŞLER GETİRİLEMEDİ: $e');

      throw Exception(
        'Siparişler yüklenirken hata oluştu: $e',
      );
    }
  }

  @override
  Future<OrderEntity> getOrderById(String orderId) async {
    try {
      final response = await dio.get(
        '/orders/$orderId',
      );

      final json = response.data['result'];

      // OrderModel kullanarak detay verisini ve ürünleri eşliyoruz
      return OrderModel.fromJson(json);
    } catch (e) {
      throw Exception(
        'Sipariş detayı alınamadı: $e',
      );
    }
  }

  @override
  Future<void> createOrder({
    required String userId,
    required int eczaneId,
    required double totalAmount,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      print('========================================');
      print('🛒 SİPARİŞ OLUŞTURULUYOR');
      print('👤 USER ID: $userId');
      print('🏥 ECZANE ID: $eczaneId');
      print('💰 TOPLAM: $totalAmount');
      print('💊 ÜRÜNLER: $items');
      print('========================================');

      final response = await dio.post(
        '/orders',
        data: {
          'user_id': userId,
          'eczane_id': eczaneId,
          'total_amount': totalAmount,
          'items': items,
        },
      );

      print('📦 SİPARİŞ RESPONSE: ${response.data}');

      if (response.data['success'] != true) {
        throw Exception(
          response.data['message'] ??
              'Sipariş oluşturulamadı.',
        );
      }
    } catch (e) {
      print('❌ SİPARİŞ OLUŞTURMA HATASI: $e');

      throw Exception(
        'Sipariş oluşturulamadı: $e',
      );
    }
  }
}