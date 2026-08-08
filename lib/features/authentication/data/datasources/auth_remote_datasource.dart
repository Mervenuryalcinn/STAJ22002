import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login(
      String email,
      String password,
      );
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient dioClient;

  AuthRemoteDatasourceImpl({
    required this.dioClient,
  });

  @override
  Future<UserModel> login(
      String email,
      String password,
      ) async {
    try {
      final response = await dioClient.dio.post(
        "/auth/login",
        data: {
          "email": email,
          "password": password,
        },
      );

      if (response.data["success"] == true) {
        print("========================================");
        print("🔐 LOGIN RESPONSE");
        print(response.data["result"]);
        print("========================================");

        return UserModel.fromJson(
          response.data["result"],
        );
      }

      throw ServerException(
        response.data["message"] ?? "Giriş başarısız.",
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
          e.response?.data["detail"] ?? "Giriş başarısız.",
        );
      }

      throw ServerException(
        "Sunucuya bağlanılamadı.",
      );
    }
  }
}