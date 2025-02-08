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
              "API et documentation",
              "Dashboard administrateur",
              "Pages d'authentification",
              "Page profil",
              "Navigation et thèmes",
            ],
            message: "Fier du résultat. Merci à tous pour la collaboration !",
          ),
          TeamMemberTile(
            icon: Icons.storage,
            chef: false,
            name: "ADEGNIKA Bushira",
            role: "Étudiant",
            contributions: [
              "Page de details événements",
              "Mécanisme d'achat de tickets",
            ],
            message:
                "Je suis ravi d'avoir fait partie du groupe 3 pour ce projet "
                "Flutter. Cela m'a permis de mettre en pratique des concepts "
                "que je n'avais pas eu l'occasion d'explorer en profondeur "
                "pendant le cours. De plus, ce projet m'a donné l'opportunité "
                "d'identifier mes lacunes et de mieux comprendre les domaines "
                "dans lesquels je dois progresser.",
          ),
          TeamMemberTile(
            icon: Icons.palette,
            chef: false,
            name: "KOUKPOLOU Miséricorde",
            role: "Étudiant",
            contributions: [
              "Page de recherche",
              "Déploiement de l'API",
            ],
            message:
                "Science sans conscience n'est que ruine de l'âme - François Rabelais",
          ),
          TeamMemberTile(
            icon: Icons.security,
            chef: false,
            name: "CHANHOUN Marcella",
            role: "Étudiante",
            contributions: [
              "Page d'affichage des tickets achetés",
              "Ajout des événements",
            ],
            message:
                "Je suis actuellement en fin de formation en Analyse Informatique"
                " et Programmation. Travailler sur ce projet avec mes camarades a"
                " été une expérience enrichissante et gratifiante, et j'ai été "
                "ravie de pouvoir mettre en pratique mes compétences tout en "
                "contribuant à notre travail d'équipe.",
          ),
          TeamMemberTile(
            icon: Icons.psychology,
            chef: false,
            name: "TOGBE Isaac",
            role: "Étudiant",
            contributions: [
              "Page d'affichage des évènements",
              "Tests de l'application",
            ],
            message: "Je suis développeur web et je viens de me lancer dans le "
                "développement mobile. Travailler sur ce projet en Flutter a "
                "été une expérience extrêmement enrichissante, qui m’a donné "
                "envie d’explorer encore plus cet univers. Mon objectif est "
                "désormais de devenir un développeur d’exception, aussi bien en "
                "web qu’en mobile.",
          ),
        ],
      ),
    );
  }
}
