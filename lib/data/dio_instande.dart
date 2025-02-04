import 'package:dio/dio.dart';

Dio configureDio() {
  final options = BaseOptions(
    baseUrl: 'https://f067-41-138-91-172.ngrok-free.app/api/v1/',
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
