import 'package:equatable/equatable.dart';

class PharmacyEntity extends Equatable {
  final String id;
  final String name;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;
  final bool isOpenOnDuty;

  const PharmacyEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.isOpenOnDuty,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    phone,
    latitude,
    longitude,
    isOpenOnDuty,
  ];
}