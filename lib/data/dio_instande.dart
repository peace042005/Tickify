import 'package:dio/dio.dart';

Dio configureDio() {
  final options = BaseOptions(
    baseUrl: 'https://40cf-156-0-214-14.ngrok-free.app/api/v1/',
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
