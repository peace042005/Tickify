import 'package:dio/dio.dart';
import 'package:groupe03_application/data/dio_instande.dart';
import 'package:groupe03_application/data/models/ticket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketService {
  Dio api = configureDio();

  Future<Ticket> all() async {

    final pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    if (token != "") {
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    }

    final response = await api.get('tickets');

    return Ticket.fromJson(response.data);
  }
}