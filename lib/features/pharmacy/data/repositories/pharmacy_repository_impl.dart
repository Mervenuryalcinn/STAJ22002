import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../models/pharmacy_model.dart';
import '../../domain/entities/pharmacy_entity.dart';
import '../../domain/repositories/pharmacy_repository.dart';

class PharmacyRepositoryImpl implements PharmacyRepository {
  // Eczaneler için doğrudan CollectAPI adresini ve kendi API Key'ini kullanıyoruz
  final Dio _collectApiDio = Dio(
    BaseOptions(
      baseUrl: 'https://api.collectapi.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {
        'content-type': 'application/json',
        'authorization': 'apikey 2cJPQQQC788RYZlWF5BTV3:5dNl8BSA48vpPzKujNGb8H', // Kendi CollectAPI anahtarınızı buraya ekleyin
      },
    ),
  );

  @override
  Future<Either<Failure, List<PharmacyEntity>>> getNearbyPharmacies({
    String? city,
    String? district,
    double? lat,
    double? lng,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {};

      queryParameters['il'] = city ?? 'Hatay';
      if (district != null && district.isNotEmpty) {
        queryParameters['ilce'] = district;
      }

      // İstek artık doğrudan CollectAPI'ye gidiyor (Lokal sunucuya uğramaz)
      final response = await _collectApiDio.get(
        '/health/dutyPharmacy',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['result'];
        final pharmacies = data.map((json) {
          return PharmacyModel(
            id: json['name'] ?? '',
            name: json['name'] ?? 'Bilinmeyen Eczane',
            address: json['address'] ?? 'Adres belirtilmemiş',
            phone: json['phone'] ?? 'Telefon yok',
            latitude: 36.49,
            longitude: 36.35,
            isOpenOnDuty: true,
          );
        }).toList();

        return Right(pharmacies);
      } else {
        return const Left(ServerFailure('Nöbetçi eczaneler alınamadı.'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PharmacyEntity>> getPharmacyDetail(String id) async {
    try {
      const pharmacy = PharmacyModel(
        id: '1',
        name: 'Neşe Eczanesi',
        address: 'Kırıkhan / Hatay',
        phone: '0326 344 00 00',
        latitude: 36.49,
        longitude: 36.35,
        isOpenOnDuty: true,
      );
      return const Right(pharmacy);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}