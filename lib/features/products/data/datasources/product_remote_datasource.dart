import 'package:dio/dio.dart';
import 'package:lideatech_pharmacy_app/core/network/dio_client.dart';
import 'package:lideatech_pharmacy_app/core/error/exceptions.dart';
import '../../domain/entities/product_entity.dart'; // 1. Entity import edildi
import '../models/product_model.dart';
import '../models/product_mapper.dart'; // 2. Mapper import edildi

abstract class ProductRemoteDatasource {
  // Artık dışarıya Model değil Entity listesi veriyoruz
  Future<List<ProductEntity>> getProducts({int page = 1, int limit = 10, String? query});
  Future<ProductEntity> getProductDetail(String id);
}

class ProductRemoteDatasourceImpl implements ProductRemoteDatasource {
  final DioClient dioClient;

  ProductRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<List<ProductEntity>> getProducts({int page = 1, int limit = 10, String? query}) async {
    try {
      final response = await dioClient.get(
        '/products',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (query != null && query.isNotEmpty) 'search': query,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['result'] as List<dynamic>;

        // Model listesini .toEntity() kullanarak saf Entity listesine dönüştürüyoruz
        return data
            .map((json) => ProductModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw const ServerException('Ürünler yüklenirken bir hata oluştu.');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Ağ bağlantı hatası');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProductEntity> getProductDetail(String id) async {
    try {
      final response = await dioClient.get('/products/$id');

      if (response.statusCode == 200) {
        final jsonData = response.data['result'];

        // Tekil modeli .toEntity() ile Entity'ye çeviriyoruz
        return ProductModel.fromJson(jsonData).toEntity();
      } else {
        throw const ServerException('Ürün detayı getirilemedi.');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Ağ bağlantı hatası');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}