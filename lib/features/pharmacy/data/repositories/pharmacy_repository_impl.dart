import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';

import '../../domain/entities/pharmacy_entity.dart';
import '../../domain/entities/pharmacy_stock_entity.dart';

import '../models/pharmacy_model.dart';
import '../models/pharmacy_stock_model.dart';

import '../../domain/repositories/pharmacy_repository.dart';

class PharmacyRepositoryImpl implements PharmacyRepository {
  final DioClient dioClient;

  PharmacyRepositoryImpl({
    required this.dioClient,
  });

  // ============================================================
  // 1. YAKIN / NÖBETÇİ ECZANELER
  // ============================================================

  @override
  Future<Either<Failure, List<PharmacyEntity>>> getNearbyPharmacies({
    String? city,
    String? district,
    double? lat,
    double? lng,
    bool? isDuty,
  }) async {
    try {
      Response response;

      // GPS varsa konuma göre arama
      if (lat != null && lng != null) {
        response = await dioClient.get(
          '/pharmacies/by-location',
          queryParameters: {
            'lat': lat,
            'lng': lng,
            'is_duty': isDuty == true ? 1 : 0,
          },
        );
      }

      // İl / ilçe varsa nöbetçi eczane arama
      else if (city != null && city.isNotEmpty) {
        response = await dioClient.get(
          '/pharmacies/duty',
          queryParameters: {
            'city': city,
            'district': district ?? '',
          },
        );
      }

      // Genel eczaneler
      else {
        response = await dioClient.get(
          '/pharmacies',
        );
      }

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        final List<dynamic> data =
            response.data['result'] ?? [];

        final pharmacies = data.map<PharmacyEntity>((json) {
          return PharmacyModel.fromJson(
            Map<String, dynamic>.from(json),
          );
        }).toList();

        return Right(pharmacies);
      }

      return const Left(
        ServerFailure(
          'Nöbetçi eczaneler alınamadı.',
        ),
      );
    } on DioException catch (e) {
      print('========================================');
      print('❌ YAKIN ECZANE DIO HATASI');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      print('MESSAGE: ${e.message}');
      print('========================================');

      return Left(
        ServerFailure(
          e.response?.data?['message']?.toString() ??
              e.response?.data?['detail']?.toString() ??
              e.message ??
              'Ağ bağlantı hatası',
        ),
      );
    } catch (e) {
      print('❌ YAKIN ECZANE HATASI: $e');

      return Left(
        ServerFailure(
          e.toString(),
        ),
      );
    }
  }

  // ============================================================
  // 2. TÜM ECZANELER
  // ============================================================

  @override
  Future<Either<Failure, List<PharmacyEntity>>> getAllPharmacies({
    String? city,
    String? district,
  }) async {
    try {
      print('========================================');
      print('🏥 TÜM ECZANELER');
      print('CITY: $city');
      print('DISTRICT: $district');
      print('========================================');

      final response = await dioClient.get(
        '/pharmacies/city',
        queryParameters: {
          'city': city ?? '',
          'district': district ?? '',
        },
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        final List<dynamic> data =
            response.data['result'] ?? [];

        final pharmacies = data.map<PharmacyEntity>((json) {
          return PharmacyModel.fromJson(
            Map<String, dynamic>.from(json),
          );
        }).toList();

        print(
          '🏥 ECZANE SAYISI: ${pharmacies.length}',
        );

        return Right(pharmacies);
      }

      return const Left(
        ServerFailure(
          'Tüm eczaneler alınamadı.',
        ),
      );
    } on DioException catch (e) {
      print('========================================');
      print('❌ TÜM ECZANELER DIO HATASI');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      print('MESSAGE: ${e.message}');
      print('========================================');

      return Left(
        ServerFailure(
          e.response?.data?['message']?.toString() ??
              e.response?.data?['detail']?.toString() ??
              e.message ??
              'Ağ bağlantı hatası',
        ),
      );
    } catch (e) {
      print('❌ TÜM ECZANELER HATASI: $e');

      return Left(
        ServerFailure(
          e.toString(),
        ),
      );
    }
  }

  // ============================================================
  // 3. ECZANE DETAY
  // ============================================================

  @override
  Future<Either<Failure, PharmacyEntity>> getPharmacyDetail(
      String id,
      ) async {
    try {
      print('========================================');
      print('🏥 ECZANE DETAY');
      print('ID: $id');
      print('========================================');

      final response = await dioClient.get(
        '/pharmacies',
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        final List<dynamic> data =
            response.data['result'] ?? [];

        dynamic pharmacyJson;

        for (final item in data) {
          if (item['id'].toString() == id) {
            pharmacyJson = item;
            break;
          }
        }

        if (pharmacyJson != null) {
          return Right(
            PharmacyModel.fromJson(
              Map<String, dynamic>.from(pharmacyJson),
            ),
          );
        }

        return const Left(
          ServerFailure(
            'Eczane bulunamadı.',
          ),
        );
      }

      return const Left(
        ServerFailure(
          'Eczane detayı alınamadı.',
        ),
      );
    } on DioException catch (e) {
      print('========================================');
      print('❌ ECZANE DETAY DIO HATASI');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      print('MESSAGE: ${e.message}');
      print('========================================');

      return Left(
        ServerFailure(
          e.response?.data?['message']?.toString() ??
              e.response?.data?['detail']?.toString() ??
              e.message ??
              'Ağ bağlantı hatası',
        ),
      );
    } catch (e) {
      print('❌ ECZANE DETAY HATASI: $e');

      return Left(
        ServerFailure(
          e.toString(),
        ),
      );
    }
  }

  // ============================================================
  // 4. SEPETE GÖRE UYGUN ECZANELER
  // ============================================================

  @override
  Future<Either<Failure, List<PharmacyStockEntity>>>
  getPharmaciesForCart({
    required double lat,
    required double lng,
    required List<int> productIds,
    required List<int> quantities,
  }) async {
    try {
      // ========================================================
      // 1. Sepet kontrolü
      // ========================================================

      if (productIds.isEmpty) {
        return const Left(
          ServerFailure(
            'Sepette ürün bulunamadı.',
          ),
        );
      }

      if (quantities.isEmpty) {
        return const Left(
          ServerFailure(
            'Ürün miktarları bulunamadı.',
          ),
        );
      }

      if (productIds.length != quantities.length) {
        return const Left(
          ServerFailure(
            'Ürün ve miktar bilgileri eşleşmiyor.',
          ),
        );
      }

      print('========================================');
      print('🛒 GET PHARMACIES FOR CART');
      print('========================================');
      print('📍 LAT: $lat');
      print('📍 LNG: $lng');
      print('💊 PRODUCT IDS: $productIds');
      print('📦 QUANTITIES: $quantities');
      print('========================================');

      // ========================================================
      // 2. Backend'e istek
      // ========================================================

      final response = await dioClient.get(
        '/pharmacies/for-cart',
        queryParameters: {
          'lat': lat,
          'lng': lng,
          'product_ids': productIds,
          'quantities': quantities,
        },
      );

      // ========================================================
      // 3. Response kontrolü
      // ========================================================

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        final List<dynamic> data =
            response.data['result'] ?? [];

        // ======================================================
        // 4. PharmacyStockModel'e dönüştür
        // ======================================================

        final pharmacies =
        data.map<PharmacyStockEntity>((json) {
          return PharmacyStockModel.fromJson(
            Map<String, dynamic>.from(json),
          );
        }).toList();

        print(
          '🏥 UYGUN ECZANE SAYISI: ${pharmacies.length}',
        );

        // ======================================================
        // 5. Debug
        // ======================================================

        for (final pharmacy in pharmacies) {
          print(
            '🏥 ${pharmacy.pharmacyName} '
                '| ${pharmacy.city}/${pharmacy.district} '
                '| ${pharmacy.distanceKm} km',
          );

          print(
            '   📦 STOKLAR: ${pharmacy.productStocks}',
          );
        }

        return Right(pharmacies);
      }

      return Left(
        ServerFailure(
          response.data['message']?.toString() ??
              'Sepete uygun eczane bulunamadı.',
        ),
      );
    } on DioException catch (e) {
      print('========================================');
      print('❌ GET PHARMACIES FOR CART DIO HATASI');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      print('MESSAGE: ${e.message}');
      print('========================================');

      return Left(
        ServerFailure(
          e.response?.data?['message']?.toString() ??
              e.response?.data?['detail']?.toString() ??
              e.message ??
              'Ağ bağlantı hatası',
        ),
      );
    } catch (e) {
      print(
        '❌ GET PHARMACIES FOR CART HATASI: $e',
      );

      return Left(
        ServerFailure(
          e.toString(),
        ),
      );
    }
  }
}