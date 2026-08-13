import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/pharmacy_entity.dart';
import '../repositories/pharmacy_repository.dart';

class GetNearbyPharmaciesUseCase {
  final PharmacyRepository repository;

  GetNearbyPharmaciesUseCase(this.repository);

  Future<Either<Failure, List<PharmacyEntity>>> call({
    String? city,
    String? district,
    double? lat,
    double? lng,
    bool? isDuty,
  }) async {
    return await repository.getNearbyPharmacies(
      city: city,
      district: district,
      lat: lat,
      lng: lng,
      isDuty: isDuty,
    );
  }
}