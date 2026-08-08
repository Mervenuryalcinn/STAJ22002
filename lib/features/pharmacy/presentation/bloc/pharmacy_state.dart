import '../../domain/entities/pharmacy_entity.dart';
import '../../domain/entities/pharmacy_stock_entity.dart';

abstract class PharmacyState {}

class PharmacyInitial extends PharmacyState {}

class PharmacyLoading extends PharmacyState {}

class PharmacyLoaded extends PharmacyState {
  final List<PharmacyEntity> pharmacies;

  PharmacyLoaded(this.pharmacies);
}

class PharmacyCartLoaded extends PharmacyState {
  final List<PharmacyStockEntity> pharmacies;

  PharmacyCartLoaded(this.pharmacies);
}

class PharmacyError extends PharmacyState {
  final String message;

  PharmacyError(this.message);
}