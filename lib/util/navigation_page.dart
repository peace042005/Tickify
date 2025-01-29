import 'package:flutter/material.dart';

enum NavigationPage {
  events,
  search,
  tickets,
  profile;

  String get label {
    return switch (this) {
      NavigationPage.events => 'Événements',
      NavigationPage.search => 'Rechercher',
      NavigationPage.tickets => 'Mes Tickets',
      NavigationPage.profile => 'Profil',
    };
  }

  IconData get icon {
    return switch (this) {
      NavigationPage.events => Icons.event,
      NavigationPage.search => Icons.search,
      NavigationPage.tickets => Icons.bookmark,
      NavigationPage.profile => Icons.person,
    };
  }
}
