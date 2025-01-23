import 'package:dio/dio.dart';

Dio configureDio() {
  final options = BaseOptions(
<<<<<<< HEAD
    // baseUrl: 'http://192.168.18.196:3030/',
    // baseUrl: 'http://192.168.64.196:8000/api/v1/',
    baseUrl: 'http://127.0.0.1:8000/api/v1/',
    // baseUrl: 'http://10.0.0.2:8000/api/v1/',
    // baseUrl: 'http://localhost:8000/api/v1/',
=======
    baseUrl: 'https://8eea-156-0-213-12.ngrok-free.app/api/v1/',
>>>>>>> 752b4152485293a2977ed255057f402bdff71f78
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
