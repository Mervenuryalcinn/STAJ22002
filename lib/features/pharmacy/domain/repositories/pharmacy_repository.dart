import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/pharmacy_entity.dart';
import '../entities/pharmacy_stock_entity.dart';

abstract class PharmacyRepository {

  // ============================================================
  // YAKIN / NÖBETÇİ ECZANELER
  // ============================================================

  Future<Either<Failure, List<PharmacyEntity>>>
  getNearbyPharmacies({
    String? city,
    String? district,
    double? lat,
    double? lng,
    bool? isDuty,
  });

  // ============================================================
  // TÜM ECZANELER
  // ============================================================

  Future<Either<Failure, List<PharmacyEntity>>>
  getAllPharmacies({
    String? city,
    String? district,
  });

  // ============================================================
  // ECZANE DETAY
  // ============================================================

  Future<Either<Failure, PharmacyEntity>>
  getPharmacyDetail(
      String id,
      );

  // ============================================================
  // SEPETE UYGUN ECZANELER
  // ============================================================

  Future<Either<Failure, List<PharmacyStockEntity>>>
  getPharmaciesForCart({
    required double lat,
    required double lng,
    required List<int> productIds,
    required List<int> quantities,
  });
}