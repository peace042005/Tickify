import 'package:dio/dio.dart';

Dio configureDio() {
  final options = BaseOptions(
    // baseUrl: 'https://8eea-156-0-213-12.ngrok-free.app/api/v1/',
    baseUrl: 'http://127.0.0.1:8000/api/v1/',
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
