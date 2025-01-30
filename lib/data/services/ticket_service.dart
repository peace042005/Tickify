import 'package:dio/dio.dart';
import 'package:groupe03_application/data/dio_instande.dart';
import 'package:groupe03_application/data/models/ticket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketService {
  Dio api = configureDio(); // ← configureDio() doit être accessible ici

  Future<List<Ticket>> all() async {
    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token.isNotEmpty) {
      api.options.headers['Authorization'] = 'Bearer $token';
    }

    final response = await api.get('tickets');

    List<dynamic> data = response.data;
    return data.map((json) => Ticket.fromJson(json)).toList();
  }
}
