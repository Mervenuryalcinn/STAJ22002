import 'package:equatable/equatable.dart';

class PharmacyStockEntity extends Equatable {
  final String pharmacyId;
  final String pharmacyName;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;
  final String city;
  final String district;

  // Ürün ID -> stok miktarı
  final Map<String, int> productStocks;

  // Sepetteki kaç farklı ürün mevcut
  final int matchedProducts;

  // Kullanıcıya uzaklık
  final double distanceKm;

  const PharmacyStockEntity({
    required this.pharmacyId,
    required this.pharmacyName,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.district,
    required this.productStocks,
    required this.matchedProducts,
    required this.distanceKm,
  });

  @override
  List<Object?> get props => [
    pharmacyId,
    pharmacyName,
    address,
    phone,
    latitude,
    longitude,
    city,
    district,
    productStocks,
    matchedProducts,
    distanceKm,
  ];
}