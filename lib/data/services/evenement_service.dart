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

  Future<Evenement> selectEvenement({required int id}) async {
    final response = await api.get(
      'evenements/$id',
      queryParameters: {'includeType': true},
    );

    return Evenement.fromJson(response.data);
  }

  // ! Incomplet
  Future<Evenement> searchEvenements(Map<String, dynamic> queryParams) async {
    final queryString = Uri(queryParameters: queryParams).query;
    final url = 'evenements${queryString.isNotEmpty ? '?$queryString' : ''}';

    final response = await api.get(url);
    return Evenement.fromJson(response.data);
  }
}
