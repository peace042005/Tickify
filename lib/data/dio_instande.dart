import 'package:dio/dio.dart';

Dio configureDio() {
  final options = BaseOptions(
    // baseUrl: 'http://192.168.18.196:3030/',
    baseUrl: 'http://192.168.64.196:8000/api/v1/',
    // baseUrl: 'http://127.0.0.1:8000/api/v1/',
    // baseUrl: 'http://10.0.0.2:8000/api/v1/',
    // baseUrl: 'http://localhost:8000/api/v1/',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  );
  final dio = Dio(options);

  return dio;
}
