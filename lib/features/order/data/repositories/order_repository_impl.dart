import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<OrderEntity>> getOrders(String userId) async {
    return await remoteDataSource.getOrders(userId);
  }

  @override
  Future<OrderEntity> getOrderById(String orderId) async {
    return await remoteDataSource.getOrderById(orderId);
  }

  @override
  Future<void> createOrder({
    required String userId,
    required int eczaneId,
    required double totalAmount,
    required List<Map<String, dynamic>> items,
  }) async {
    await remoteDataSource.createOrder(
      userId: userId,
      eczaneId: eczaneId,
      totalAmount: totalAmount,
      items: items,
    );
  }
}