import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/evenement.dart';

class EventService {
  final String apiUrl = "https://7199-156-0-212-25.ngrok-free.app/api/v1/";

  Future<List<Data>> fetchEvents() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final evenement = Evenement.fromJson(jsonDecode(response.body));
      return evenement.data ?? [];
    } else {
      throw Exception("Échec du chargement des événements");
    }
  }
}
