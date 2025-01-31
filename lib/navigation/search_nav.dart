import 'package:flutter/material.dart';
import 'package:groupe03_application/recherche.dart';

class SearchNav extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const SearchNav({super.key, required this.navigatorKey});

  @override
  State<SearchNav> createState() => _SearchNavState();
}

class _SearchNavState extends State<SearchNav> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) {
          if (settings.name == "") {
            return Container();
          }

          return const Recherche();
        });
      },
    );
  }
}
