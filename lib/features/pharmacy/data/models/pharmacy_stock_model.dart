import '../../domain/entities/pharmacy_stock_entity.dart';

class PharmacyStockModel extends PharmacyStockEntity {
  const PharmacyStockModel({
    required super.pharmacyId,
    required super.pharmacyName,
    required super.address,
    required super.phone,
    required super.latitude,
    required super.longitude,
    required super.city,
    required super.district,
    required super.productStocks,
    required super.matchedProducts,
    required super.distanceKm,
  });

  factory PharmacyStockModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final Map<String, int> stocks = {};

    final stocksJson = json['stocks'];

    if (stocksJson is Map) {
      stocksJson.forEach((key, value) {
        if (value is num) {
          stocks[key.toString()] = value.toInt();
        } else {
          stocks[key.toString()] =
              int.tryParse(value.toString()) ?? 0;
        }
      });
    }

    return PharmacyStockModel(
      pharmacyId: json['id']?.toString() ?? '',
      pharmacyName: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',

      latitude:
      (json['latitude'] as num?)?.toDouble() ?? 0.0,

      longitude:
      (json['longitude'] as num?)?.toDouble() ?? 0.0,

      city: json['city']?.toString() ?? '',

      district:
      json['district']?.toString() ?? '',

      productStocks: stocks,

      matchedProducts:
      (json['matched_products'] as num?)?.toInt() ?? 0,

      distanceKm:
      (json['distance_km'] as num?)?.toDouble() ?? 0.0,
    );
  }
}