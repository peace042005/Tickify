import 'package:flutter/material.dart';
import 'package:groupe03_application/components/team_member_tile.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("À propos"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.1),
          child: Container(
            color: Theme.of(context).colorScheme.onSurface,
            height: 0.1,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Text(
            "Groupe 03 - ENEAM - 2025",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          TeamMemberTile(
            icon: Icons.code,
            chef: true,
            name: "TCHASSOU Léonel",
            role: "Étudiant",
            contributions: [
              "API",
              "Pages d'authentification",
              "Page profil",
              "Navigation"
            ],
            message: "Temporairement vide",
          ),
          TeamMemberTile(
            icon: Icons.storage,
            chef: false,
            name: "ADEGNIKA Bushira",
            role: "Vide",
            contributions: [
              "Page de details événements",
              "Mécanisme d'achat de tickets",
            ],
            message: "Message vide",
          ),
          TeamMemberTile(
            icon: Icons.palette,
            chef: false,
            name: "KOUKPOLOU Miséricorde",
            role: "Étudiant",
            contributions: [
              "Page de recherche",
            ],
            message: "Science sans conscience n'est que ruine de l'âme - François Rabelais",
          ),
          TeamMemberTile(
            icon: Icons.security,
            chef: false,
            name: "CHANHOUN Marcella",
            role: "Étudiante",
            contributions: [
              "Page d'affichage des tickets achetés",
            ],
            message: "Je suis actuellement en fin de formation en Analyse Informatique et Programmation. Travailler sur ce projet avec mes camarades a été une expérience enrichissante et gratifiante, et j'ai été ravie de pouvoir mettre en pratique mes compétences tout en contribuant à notre travail d'équipe.",
          ),
          TeamMemberTile(
            icon: Icons.psychology,
            chef: false,
            name: "TOGBE Isaac",
            role: "Vide",
            contributions: [
              "Page d'affichage des évènements",
            ],
            message: "Message vide",
          ),
        ],
      ),
    );
  }
}
