import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio dio; // Veya DioClient

  AuthRemoteDatasourceImpl({required this.dio});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['result']);
      } else {
        throw const ServerException('Giriş yapılamadı.');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Ağ hatası');
    }
  }
}