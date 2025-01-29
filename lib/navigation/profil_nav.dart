import 'package:flutter/material.dart';
import 'package:groupe03_application/about.dart';
import 'package:groupe03_application/login.dart';
import 'package:groupe03_application/my_ticket.dart';
import 'package:groupe03_application/profil.dart';

class ProfilNav extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const ProfilNav({super.key, required this.navigatorKey});

  @override
  State<ProfilNav> createState() => _ProfilNavState();
}

class _ProfilNavState extends State<ProfilNav> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) => switch (settings.name) {
            "/myTickets" => const MyTicket(),
            "/login" => const Login(),
            "/about" => const About(),
            _ => const Profil(), // Default case
          },
        );
      },
    );
  }
}
