import 'dart:async';
import 'package:lideatech_pharmacy_app/core/network/dio_client.dart';
import 'package:lideatech_pharmacy_app/core/error/exceptions.dart';
import 'package:dio/dio.dart';
import '../models/pharmacy_model.dart';

abstract class PharmacyRemoteDatasource {
  Future<List<PharmacyModel>> getDutyPharmacies(String il, String? ilce);
  Future<List<PharmacyModel>> getAllPharmacies(String il, String? ilce);
  Future<List<PharmacyModel>> getPharmaciesByLocation(double lat, double lng, bool isDuty);
}

class PharmacyRemoteDatasourceImpl implements PharmacyRemoteDatasource {
  final DioClient dioClient;

  PharmacyRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<List<PharmacyModel>> getDutyPharmacies(String il, String? ilce) async {
    try {
      final response = await dioClient.get(
        '/pharmacies/duty',
        queryParameters: {
          'city': il,
          'district': ilce ?? '',
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['result'];
        return data.map((json) => PharmacyModel.fromJson(json)).toList();
      } else {
        throw const ServerException('Nöbetçi eczaneler yüklenemedi.');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Ağ bağlantı hatası');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PharmacyModel>> getAllPharmacies(String il, String? ilce) async {
    try {
      final response = await dioClient.get(
        '/pharmacies/city',
        queryParameters: {
          'city': il,
          'district': ilce ?? '',
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['result'];
        return data.map((json) => PharmacyModel.fromJson(json)).toList();
      } else {
        throw const ServerException('Tüm eczaneler alınamadı.');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Ağ bağlantı hatası');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PharmacyModel>> getPharmaciesByLocation(double lat, double lng, bool isDuty) async {
    try {
      final response = await dioClient.get(
        '/pharmacies/by-location',
        queryParameters: {
          'lat': lat,
          'lng': lng,
          'is_duty': isDuty ? 1 : 0,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['result'];
        return data.map((json) => PharmacyModel.fromJson(json)).toList();
      } else {
        throw const ServerException('Konuma göre eczaneler yüklenemedi.');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Ağ bağlantı hatası');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}