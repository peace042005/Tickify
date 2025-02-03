import 'package:dio/dio.dart';
import 'package:groupe03_application/data/dio_instande.dart';
import 'package:groupe03_application/data/models/ticket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketService {
  Dio api = configureDio(); // ← configureDio() doit être accessible ici

  Future<Ticket> all() async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token.isNotEmpty) {
      api.options.headers['Authorization'] = 'Bearer $token';
    }

    final response = await api.get('tickets');

    // List<dynamic> data = response.data;
    // return data.map((json) => Ticket.fromJson(json)).toList();

    return Ticket.fromJson(response.data);
  }

  Future<bool> buy({required int id}) async {
    try {
      final pref = await SharedPreferences.getInstance();
      String token = pref.getString("token") ?? "";

      if (token.isNotEmpty) {
        api.options.headers['Authorization'] = 'Bearer $token';
      }

      final response = await api.post('tickets', data: {"type_ticket_id": id});
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      print('Error buying ticket: $e');
      return false;
    }
  }

  Future<bool> delete({required int id}) async {
    try {
      final pref = await SharedPreferences.getInstance();
      String token = pref.getString("token") ?? "";

      if (token.isNotEmpty) {
        api.options.headers['Authorization'] = 'Bearer $token';
      }

      final response = await api.delete('tickets/$id');
      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Error buying ticket: $e');
      return false;
    }
  }
}
