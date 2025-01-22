import 'package:dio/dio.dart';

Dio configureDio() {
  final options = BaseOptions(
    baseUrl: 'https://939e-197-234-219-36.ngrok-free.app/api/v1/',
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
