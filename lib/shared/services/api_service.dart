import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider =
Provider<ApiService>((ref) {

  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:5000',

      connectTimeout:
      const Duration(seconds: 30),

      receiveTimeout:
      const Duration(seconds: 30),

      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
    ),
  );

  return ApiService(dio);
});

class ApiService {

  final Dio _dio;

  ApiService(this._dio);

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw Exception(
        e.message,
      );
    }
  }

  Future<Response> post(
      String path, {
        dynamic data,
      }) async {

    try {

      return await _dio.post(
        path,
        data: data,
      );

    } on DioException catch (e) {

      throw Exception(
        e.message,
      );
    }
  }
}