import 'package:flutter/material.dart';
import 'package:groupe03_application/evenement_detail.dart';
import 'package:groupe03_application/home.dart';

class HomeNav extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const HomeNav({super.key, required this.navigatorKey});

  @override
  State<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            if (settings.name == "/details") {
              // return Container();
              // return EvenementDetail(evenementId: settings.arguments as int);
              final arguments = settings.arguments;

              if (arguments is int) {
                return EvenementDetail(evenementId: arguments);
              }

              throw ArgumentError('Expected int for evenementId');
            }

            return const Home();
          },
        );
      },
    );
  }
}
