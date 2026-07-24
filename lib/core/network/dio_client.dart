import 'package:dio/dio.dart';
import 'app_interceptor.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.ornekeczane.com/v1/', // Mock veya gerçek base url
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Interceptor ekleme
    _dio.interceptors.add(AppInterceptor());
  }

  Dio get dio => _dio;
}