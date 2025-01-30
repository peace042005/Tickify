import 'package:flutter/material.dart';

class Recherche extends StatefulWidget {
  const Recherche({super.key});

  @override
  State<Recherche> createState() => _RechercheState();
}

class _RechercheState extends State<Recherche> {
  // Constructeur pour chaque option de filtrage
  Widget _buildFilterButton(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(
              color: Theme.of(context).colorScheme.onSurface,
              width: 0.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        ),
        onPressed: () {
          // Action du bouton
        },
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Rechercher"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 16.0), // Marge gauche
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Rechercher...',
                          border: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              // color: Colors.blue,
                              color: Theme.of(context).colorScheme.primary,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      // color: Colors.blue, // Couleur de l'icône
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      // Action de recherche
                    },
                  ),
                ],
              ),
              const SizedBox(height: 5.0), // Espacement entre les deux lignes
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterButton(context, 'id'),
                    _buildFilterButton(context, 'nom'),
                    _buildFilterButton(context, 'description'),
                    _buildFilterButton(context, 'nombre de tickets'),
                    _buildFilterButton(context, 'date'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
