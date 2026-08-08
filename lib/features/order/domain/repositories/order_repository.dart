import '../entities/order_entity.dart';

abstract class OrderRepository {
Future<List<OrderEntity>> getOrders(String userId);

Future<OrderEntity> getOrderById(String orderId);

Future<void> createOrder({
required String userId,
required int eczaneId,
required double totalAmount,
required List<Map<String, dynamic>> items,
});
}

