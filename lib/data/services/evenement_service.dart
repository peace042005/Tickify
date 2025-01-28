import 'package:dio/dio.dart';
import 'package:groupe03_application/data/dio_instande.dart';
import 'package:groupe03_application/data/models/evenement.dart';

class EvenementService {
  Dio api = configureDio();

  Future<Evenement> getEvenements({bool includeType = false}) async {
    final response = await api.get(
      'evenements',
      queryParameters: includeType ? {'includeType': true} : null,
    );

    return Evenement.fromJson(response.data);
  }
}
