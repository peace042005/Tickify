import 'package:dio/dio.dart';

Dio configureDio() {
  final options = BaseOptions(
    baseUrl: 'https://groupe03-api-2b03b8ee066a.herokuapp.com/api/v1/',
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
