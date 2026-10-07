import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio dio;

  // Ganti port ke 5001 sesuai dengan file .env backend
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5001/api';
    }
    // Emulator Android mendeteksi host PC sebagai IP 10.0.2.2
    // Jika menggunakan device fisik, ganti IP ini dengan IP Local PC Anda (misal: 192.168.1.X)
    return 'http://10.0.2.2:5001/api';
  }

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-client-platform': 'mobile', // Menandakan request dari mobile agar server mengembalikan token JWT di body
        },
      ),
    );

    // Interceptor untuk menambahkan JWT Token secara otomatis ke Authorization Header
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          if (kDebugMode) {
            print('API Error [${error.response?.statusCode}]: ${error.message}');
            print('Response: ${error.response?.data}');
          }
          return handler.next(error);
        },
      ),
    );
  }

  // Helper GET
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await dio.get(path, queryParameters: queryParameters);
  }

  // Helper POST
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await dio.post(path, data: data, queryParameters: queryParameters);
  }

  // Helper PUT
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await dio.put(path, data: data, queryParameters: queryParameters);
  }

  // Helper DELETE
  Future<Response> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return await dio.delete(path, data: data, queryParameters: queryParameters);
  }
}
