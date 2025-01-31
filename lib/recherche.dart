import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:groupe03_application/data/models/evenement.dart';
import 'package:groupe03_application/data/services/evenement_service.dart';

class Recherche extends StatefulWidget {
  const Recherche({super.key});

  @override
  State<Recherche> createState() => _RechercheState();
}

class _RechercheState extends State<Recherche> {
  final EvenementService _evenementService = EvenementService();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<Data> _events = [];
  String? _error;

  Map<String, dynamic> _buildQueryParams(String queryText) {
    Map<String, dynamic> params = {};
    bool hasKeyword = false; // Vérifie si un mot-clé a été utilisé

    if (queryText.isNotEmpty) {
      List<String> parts = queryText.split('|');

      for (String part in parts) {
        List<String> keyValue = part.split(': ');
        if (keyValue.length == 2) {
          String key = keyValue[0].trim();
          String value = keyValue[1].trim();
          hasKeyword = true; // Un mot-clé a été trouvé

          // Appliquer les règles :
          if (["id"].contains(key)) {
            params["$key[eq]"] = value; // id = valeur exacte
          } else if (["nom", "description"].contains(key)) {
            params["$key[like]"] = value; // LIKE pour les textes
          } else if (["nombreTickets", "dateDebut"].contains(key)) {
            params["$key[gt]"] = value; // Par défaut, supérieur pour les nombres et dates
          }
        }
      }

      // Si aucun mot-clé n'a été trouvé, considérer le texte comme un nom
      if (!hasKeyword) {
        params["nom[like]"] = queryText.trim();
      }
    }

    return params;
  }

  Future<void> _searchEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      String queryText = _searchController.text.trim();
      Map<String, dynamic> queryParams = _buildQueryParams(queryText);

      // Construire l'URL avec les paramètres
      String queryString = Uri(queryParameters: queryParams).query;
      String url = 'evenements${queryString.isNotEmpty ? '?$queryString' : ''}';

      final response = await _evenementService.api.get(url);
      print(queryParams);
      print(queryString);
      print(response);

      setState(() {
        if (response.data is Map<String, dynamic> && response.data["data"] is List) {
          _events = (response.data["data"] as List)
              .map((e) => Data.fromJson(e))
              .toList();
        } else {
          _events = [];
        }
        _isLoading = false;
      });
    } on DioException catch (e) {
      print('Error fetching events: ${e.message}');
      setState(() {
        _error = _handleDioError(e);
        _isLoading = false;
      });
    } catch (e) {
      print('Unexpected error: $e');
      setState(() {
        _error = 'Une erreur inattendue est survenue';
        _isLoading = false;
      });
    }
  }

  String _handleDioError(DioException e) {
    switch (e.response?.statusCode) {
      case 404:
        return 'La ressource demandée n\'existe pas';
      case 500:
        return 'Erreur serveur interne';
      case null:
        return 'Impossible de se connecter au serveur';
      default:
        return 'Une erreur est survenue (${e.response?.statusCode})';
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Date non définie';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year} '
          '${date.hour.toString().padLeft(2, '0')}:'
          '${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Date invalide';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Rechercher",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 16.0), // Marge gauche
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Rechercher...',
                          border: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.blue, // Couleur de l'icône
                    ),
                    onPressed: _searchEvents,
                  ),
                ],
              ),
              SizedBox(height: 5.0), // Espacement entre les deux lignes
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterButton('nom'),
                    _buildFilterButton('description'),
                    _buildFilterButton('nombreTickets'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(color: Colors.blue, width: 1.5),
                          ),
                        ),
                        onPressed: () => _selectDate(context), // Afficher le calendrier
                        child: Text('date'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: Colors.blue, width: 1.5),
          ),
        ),
        onPressed: () {
          setState(() {
            _searchController.text += '|$filter: ';
          });
        },
        child: Text(filter),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Date minimale
      lastDate: DateTime(2100), // Date maximale
    );

    if (pickedDate != null) {
      String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

      setState(() {
        if (_searchController.text.isEmpty) {
          _searchController.text = "dateDebut: $formattedDate";
        } else {
          _searchController.text += "|dateDebut: $formattedDate";
        }
      });
    }
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              /*ElevatedButton.icon(
                onPressed: _loadEvents,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),*/
            ],
          ),
        ),
      );
    }

    if (_events.isEmpty) {
      return const Center(
        child: Text('Aucun événement'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _events.length,
      itemBuilder: (context, index) {
        final event = _events[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          clipBehavior: Clip.antiAlias,
          elevation: 8, // Ombre autour de la carte
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (event.images != null && event.images!.isNotEmpty)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                    child: Image.network(
                      event.images!.first.url ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.nom ?? 'Sans titre',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.description ?? 'Aucune description',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    if (event.lieu != null) ...[
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text(event.lieu!, style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Du ${_formatDate(event.dateDebut)} au ${_formatDate(event.dateFin)}',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.confirmation_number, size: 16, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text('${event.nombreTickets ?? 0} tickets disponibles'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
