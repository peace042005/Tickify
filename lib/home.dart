import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:groupe03_application/data/models/evenement.dart';
import 'package:groupe03_application/data/services/evenement_service.dart';
import 'package:groupe03_application/components/evenement_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final EvenementService _evenementService = EvenementService();
  bool _isLoading = true;
  List<Data> _events = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final response = await _evenementService.getEvenements(includeType: true);
      setState(() {
        _events = response.data ?? [];
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

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Date non définie';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year} à '
          '${date.hour.toString().padLeft(2, '0')}:'
          '${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Date invalide';
    }
  }

  String _handleDioError(DioException e) {
    return switch (e.response?.statusCode) {
      404 => 'La ressource demandée n\'existe pas',
      500 => 'Erreur serveur interne',
      null => 'Impossible de se connecter au serveur',
      _ => 'Une erreur est survenue (${e.response?.statusCode})',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Événements',
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.1), // Thickness of the border
          child: Container(
            color: Theme.of(context).colorScheme.onSurface,
            height: 0.1, // Thickness
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEvents,
          ),
        ],
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        onRefresh: _loadEvents,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    // Afficher un indicateur de chargement lorsque les évènements ne sont pas chargés
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      );
    }

    // Si une erreur s'est produite, afficher un message d'erreur
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
              ElevatedButton.icon(
                onPressed: _loadEvents,
                icon: Icon(
                  Icons.refresh,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                label: Text(
                  'Réessayer',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .secondary, // Background color
                  foregroundColor: Theme.of(context)
                      .colorScheme
                      .onSecondary, // Text & icon color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    side: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface, // Border color
                      width: 0.7, // Border thickness
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Afficher une indication si aucun événement n'est disponible
    if (_events.isEmpty) {
      return const Center(
        child: Text('Aucun événement disponible'),
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
