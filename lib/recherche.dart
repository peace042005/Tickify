import 'package:flutter/material.dart';

class Recherche extends StatefulWidget {
  const Recherche({super.key});

  @override
  State<Recherche> createState() => _RechercheState();
}

class _RechercheState extends State<Recherche> {
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
                    onPressed: () {
                      // Action de recherche
                    },
                  ),
                ],
              ),
              SizedBox(height: 5.0), // Espacement entre les deux lignes
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0), // Espacement horizontal réduit
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0), // Coins arrondis
                            side: BorderSide(color: Colors.blue, width: 1.5), // Bordure bleue personnalisée
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Padding interne du bouton
                        ),
                        onPressed: () {
                          // Action du bouton 1
                        },
                        child: Text('id'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(color: Colors.blue, width: 1.5),
                          ),
                        ),
                        onPressed: () {
                          // Action du bouton 2
                        },
                        child: Text('nom'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(color: Colors.blue, width: 1.5),
                          ),
                        ),
                        onPressed: () {
                          // Action du bouton 3
                        },
                        child: Text('description'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(color: Colors.blue, width: 1.5),
                          ),
                        ),
                        onPressed: () {
                          // Action du bouton 4
                        },
                        child: Text('nombre de tickets'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(color: Colors.blue, width: 1.5),
                          ),
                        ),
                        onPressed: () {
                          // Action du bouton 5
                        },
                        child: Text('date'),
                      ),
                    ),
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
