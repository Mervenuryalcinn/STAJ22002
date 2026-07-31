import '../../domain/entities/pharmacy_entity.dart';

abstract class PharmacyState {}

class PharmacyInitial extends PharmacyState {}

class PharmacyLoading extends PharmacyState {}

class PharmacyLoaded extends PharmacyState {
  final List<PharmacyEntity> pharmacies;
  PharmacyLoaded(this.pharmacies);
}

class PharmacyError extends PharmacyState {
  final String message;
  PharmacyError(this.message);
}