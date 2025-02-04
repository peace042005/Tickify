import 'package:dio/dio.dart';

Dio configureDio() {
  final options = BaseOptions(
    baseUrl: 'https://9ca7-197-234-221-217.ngrok-free.app/api/v1/',
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
