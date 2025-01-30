import 'package:dio/dio.dart';
import 'package:groupe03_application/data/dio_instande.dart';
import 'package:groupe03_application/data/models/authenticated_user.dart';

class UserService {
  Dio api = configureDio();

  Future<AuthenticatedUser> login(Map<String, dynamic> data) async {
    final response = await api.post('login', data: data);

    return AuthenticatedUser.fromJson(response.data);
  }

  Future<void> logout() async {
    await api.post('logout');
  }

  /* Future<User> create (Map<String, dynamic> data) async{

    final response = await api.post('register', data: data);

    return User.fromJson(response.data);
  } */

  Future<AuthenticatedUser> create(Map<String, dynamic> data) async {
    try {
      final response = await api.post(
        'register',
        data: data,
      );
      return AuthenticatedUser.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        // If the server responded with an error message
        throw Exception(e.response?.data['message'] ?? 'Registration failed');
      } else {
        // If the request failed before reaching the server
        throw Exception('Connection error: ${e.message}');
      }
    }
  }
}
