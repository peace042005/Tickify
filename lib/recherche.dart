import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:groupe03_application/components/evenement_card.dart';
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

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _events = [];
      _error = null;
    });
  }

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
            params["$key[gt]"] =
                value; // Par défaut, supérieur pour les nombres et dates
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

      setState(() {
        if (response.data is Map<String, dynamic> &&
            response.data["data"] is List) {
          _events = (response.data["data"] as List)
              .map((e) => Data.fromJson(e))
              .toList();
        } else {
          _events = [];
        }
        _isLoading = false;
      });
    } on DioException catch (e) {
      // print('Error fetching events: ${e.message}');
      setState(() {
        _error = _handleDioError(e);
        _isLoading = false;
      });
    } catch (e) {
      // print('Unexpected error: $e');
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Rechercher"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.1),
          child: Container(
            color: Theme.of(context).colorScheme.onSurface,
            height: 0.1,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 16.0), // Marge gauche
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Rechercher...',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7)),
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .onSecondary
                              .withOpacity(0.2),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 16.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                            borderSide: BorderSide.none, // No border
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  ),
                                  onPressed: _clearSearch,
                                )
                              : null,
                        ),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                        cursorColor: Theme.of(context).colorScheme.onSurface,
                        onSubmitted: (_) => _searchEvents(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context)
                          .colorScheme
                          .onSecondary, // Couleur de l'icône
                    ),
                    onPressed: _searchEvents,
                  ),
                ],
              ),
              const SizedBox(height: 5.0), // Espacement entre les deux lignes
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
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.onSecondary,
                              width: 0.5,
                            ),
                          ),
                        ),
                        onPressed: () =>
                            _selectDate(context), // Afficher le calendrier
                        child: Text(
                          'date',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
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
            side: BorderSide(
              color: Theme.of(context).colorScheme.onSecondary,
              width: 0.5,
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            _searchController.text += '|$filter: ';
          });
        },
        child: Text(
          filter,
          style: Theme.of(context).textTheme.bodySmall,
        ),
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
      String formattedDate =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

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

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _events.length,
      itemBuilder: (context, index) => EvenementCard(
        event: _events[index],
        formatDate: _formatDate,
        onTap: () => Navigator.pushNamed(
          context,
          '/details',
          arguments: _events[index].id,
        ),
      ),
    );
  }
}
