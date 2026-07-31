import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import 'package:lideatech_pharmacy_app/core/network/dio_client.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({int page = 1, int limit = 10, String? query}) async {
    try {
      final productModels = await remoteDataSource.getProducts(page: page, limit: limit, query: query);
      return Right(productModels); // ProductModel zaten ProductEntity'den türediği için doğrudan dönebilir
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Sunucu bağlantı hatası oluştu.'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductDetail(String id) async {
    try {
      final productModel = await remoteDataSource.getProductDetail(id);
      return Right(productModel);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Ürün detayı alınamadı.'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}