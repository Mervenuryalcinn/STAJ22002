import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  // Arama ve sayfalama parametreleri eklendi
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    int page = 1,
    int limit = 10,
    String? query,
  });

  Future<Either<Failure, ProductEntity>> getProductDetail(String id);
}