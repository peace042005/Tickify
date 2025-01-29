import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:groupe03_application/data/models/evenement.dart';
import 'package:groupe03_application/data/services/evenement_service.dart';
import 'package:groupe03_application/my_ticket.dart';
import 'package:groupe03_application/util/navigation_page.dart';
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
  NavigationPage _selectedPage = NavigationPage.events;
  // int _selectedIndex = 0; // Add this line for bottom nav

  // Add this method to handle bottom nav taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = NavigationPage.values[index];
    });
  }

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

  String _handleDioError(DioException e) {
    return switch (e.response?.statusCode) {
      404 => 'La ressource demandée n\'existe pas',
      500 => 'Erreur serveur interne',
      null => 'Impossible de se connecter au serveur',
      _ => 'Une erreur est survenue (${e.response?.statusCode})',
    };
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
        // backgroundColor: Colors.blueAccent,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Événements',
            style:
                TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEvents,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadEvents,
        child: _getPage(_selectedPage),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          items: NavigationPage.values
              .map((page) => BottomNavigationBarItem(
                  icon: Icon(page.icon), label: page.label))
              .toList(),
          currentIndex: _selectedPage.index,
          selectedItemColor:
              Theme.of(context).colorScheme.primary, // Matches theme
          unselectedItemColor: Theme.of(context)
              .colorScheme
              .onSurface
              .withOpacity(0.6), // Softer grey for unselected
          backgroundColor:
              Theme.of(context).colorScheme.surface, // Matches background

          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  // Add this method to handle page switching
  Widget _getPage(NavigationPage page) => switch (page) {
        NavigationPage.events => _buildBody(),
        NavigationPage.search => const Center(child: Text('Page Recherche')),
        NavigationPage.tickets => const MyTicket(),
        NavigationPage.profile => const Center(child: Text('Page Profil')),
      };

  Widget _buildBody() {
    // Afficher un indicateur de chargement lorsque les évènements ne sont pas chargés
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
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
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
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

    // Construire le contenu de la page
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _events.length,
      itemBuilder: (context, index) =>
          EvenementCard(event: _events[index], formatDate: _formatDate),
    );
  }
}
