import '../../domain/entities/pharmacy_entity.dart';

class PharmacyModel extends PharmacyEntity {
  final int? stock;

  const PharmacyModel({
    required super.id,
    required super.name,
    required super.address,
    required super.phone,
    required super.latitude,
    required super.longitude,
    required super.isOpenOnDuty,
    this.stock,
  });

  factory PharmacyModel.fromJson(Map<String, dynamic> json) {
    return PharmacyModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      isOpenOnDuty:
      json['isOpenOnDuty'] == true ||
          json['isOpenOnDuty'] == 1 ||
          json['is_duty'] == true ||
          json['is_duty'] == 1,
      stock: json['stock'] != null
          ? int.tryParse(json['stock'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'isOpenOnDuty': isOpenOnDuty,
      'stock': stock,
    };
  }
}