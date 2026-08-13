import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/pharmacy_stock_entity.dart';
import '../repositories/pharmacy_repository.dart';

class GetPharmaciesForCartUseCase {
  final PharmacyRepository repository;

  GetPharmaciesForCartUseCase(this.repository);

  Future<Either<Failure, List<PharmacyStockEntity>>> call({
    required double lat,
    required double lng,
    required List<int> productIds,
    required List<int> quantities,
  }) async {
    return await repository.getPharmaciesForCart(
      lat: lat,
      lng: lng,
      productIds: productIds,
      quantities: quantities,
    );
  }
}