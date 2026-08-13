import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders(String userId);
  Future<OrderModel> getOrderById(String orderId);
  Future<void> createOrder({
    required String userId,
    required int eczaneId,
    required double totalAmount,
    required List<Map<String, dynamic>> items,
  });
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;

  OrderRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<OrderModel>> getOrders(String userId) async {
    try {
      final response = await dio.get(
        '/orders',
        queryParameters: {'user_id': userId},
      );

      final List data = response.data['result'] ?? [];
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data["detail"] ?? "Siparişler yüklenirken hata oluştu.",
      );
    }
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    try {
      final response = await dio.get('/orders/$orderId');
      final json = response.data['result'];
      return OrderModel.fromJson(json);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data["detail"] ?? "Sipariş detayı alınamadı.",
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
      final response = await dio.post(
        '/orders',
        data: {
          'user_id': userId,
          'eczane_id': eczaneId,
          'total_amount': totalAmount,
          'items': items,
        },
      );

      if (response.data['success'] != true) {
        throw ServerException(
          response.data['message'] ?? 'Sipariş oluşturulamadı.',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data["detail"] ?? "Sipariş oluşturulamadı.",
      );
    }
  }
}