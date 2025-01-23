import 'package:dio/dio.dart';
import 'package:groupe03_application/data/dio_instande.dart';
import 'package:groupe03_application/data/models/evenement.dart';

class EvenementService {
  Dio api = configureDio();

  Future<Evenement> getEvenements() async {
    final response = await api.get('evenements');
    return Evenement.fromJson(response.data);
  }
}
