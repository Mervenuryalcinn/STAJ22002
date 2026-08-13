import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<List<CartItemModel>> fetchCartFromServer(String userId);
  Future<void> syncCartToServer(String userId, List<CartItemModel> items);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final DioClient dioClient;

  CartRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<CartItemModel>> fetchCartFromServer(String userId) async {
    try {
      final response = await dioClient.dio.get("/cart/$userId");

      if (response.data["success"] == true) {
        final List data = response.data["result"] ?? [];
        return data.map((json) => CartItemModel.fromJson(json)).toList();
      }
      throw ServerException(response.data["message"] ?? "Sepet yüklenemedi.");
    } on DioException catch (e) {
      throw ServerException(e.response?.data["detail"] ?? "Sunucuya bağlanılamadı.");
    }
  }

  @override
  Future<void> syncCartToServer(String userId, List<CartItemModel> items) async {
    try {
      final response = await dioClient.dio.post(
        "/cart/sync",
        data: {
          "user_id": userId,
          "items": items.map((item) => item.toJson()).toList(),
        },
      );

      if (response.data["success"] != true) {
        throw ServerException(response.data["message"] ?? "Sepet güncellenemedi.");
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data["detail"] ?? "Sunucuya bağlanılamadı.");
    }
  }
}