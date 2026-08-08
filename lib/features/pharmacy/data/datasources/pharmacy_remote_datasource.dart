import 'dart:async';
import 'package:lideatech_pharmacy_app/core/network/dio_client.dart';
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
        throw Exception('Nöbetçi eczaneler yüklenemedi.');
      }
    } catch (e) {
      throw Exception('Ağ bağlantı hatası: ${e.toString()}');
    }
  }

  @override
  Future<List<PharmacyModel>> getAllPharmacies(String il, String? ilce) async {
    try {
      // Tüm eczaneler için de il ve ilçe filtresini /pharmacies/city endpoint'ine gönderiyoruz
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
        throw Exception('Tüm eczaneler alınamadı.');
      }
    } catch (e) {
      throw Exception('Tüm eczaneler yüklenemedi: $e');
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
        throw Exception('Konuma göre eczaneler yüklenemedi.');
      }
    } catch (e) {
      throw Exception('Ağ hatası: $e');
    }
  }
}