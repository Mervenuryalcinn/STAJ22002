import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/favorite_model.dart';

abstract class FavoriteRemoteDataSource {
  Future<List<FavoriteModel>> getFavorites(String userId);
  Future<void> toggleFavorite(String userId, FavoriteModel item);
  Future<bool> isFavorite(String userId, String itemId);
}

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  final DioClient dioClient;

  FavoriteRemoteDataSourceImpl({
    required this.dioClient,
  });

  @override
  Future<List<FavoriteModel>> getFavorites(String userId) async {
    try {
      final response = await dioClient.dio.get("/favorites/$userId");

      if (response.data["success"] == true) {
        final List<dynamic> resultList = response.data["result"];
        return resultList.map((json) => FavoriteModel.fromJson(json)).toList();
      }

      throw ServerException(
        response.data["message"] ?? "Favoriler getirilemedi.",
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
          e.response?.data["detail"] ?? "Favoriler getirilemedi.",
        );
      }
      throw ServerException("Sunucuya bağlanılamadı.");
    }
  }

  @override
  Future<void> toggleFavorite(String userId, FavoriteModel item) async {
    try {
      // FastAPI'nin beklediği model anahtarları ile birebir aynı olmalıdır
      final response = await dioClient.dio.post(
        "/favorites/toggle",
        data: {
          "user_id": userId, // veya "userId" (FastAPI Pydantic modelinde ne yazıyorsa)
          "item_id": item.id, // veya "itemId" / "productId"
        },
      );

      if (response.data['success'] != true) {
        throw ServerException(
          response.data['message'] ?? 'İşlem başarısız.',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Konsola sunucunun tam olarak hangi hatayı verdiğini yazdırır
        print("🔴 FastAPI 422 Hatası Detayı: ${e.response?.data}");

        throw ServerException(
          e.response?.data["detail"]?.toString() ?? "İşlem başarısız.",
        );
      }
      throw ServerException("Sunucuya bağlanılamadı.");
    }
  }
  @override
  Future<bool> isFavorite(String userId, String itemId) async {
    try {
      final favorites = await getFavorites(userId);
      return favorites.any((fav) => fav.id == itemId);
    } catch (_) {
      return false;
    }
  }
}