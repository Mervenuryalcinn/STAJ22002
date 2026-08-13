import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  // page, limit ve query parametrelerini opsiyonel
  Future<Either<Failure, List<ProductEntity>>> call({
    int page = 1,
    int limit = 10,
    String? query,
  }) async {
    return await repository.getProducts(
      page: page,
      limit: limit,
      query: query,
    );
  }
}