import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/pharmacy_entity.dart';

abstract class PharmacyRepository {
  Future<Either<Failure, List<PharmacyEntity>>> getNearbyPharmacies({
    String? city,
    String? district,
    double? lat,
    double? lng,
  });

  Future<Either<Failure, PharmacyEntity>> getPharmacyDetail(String id);
}