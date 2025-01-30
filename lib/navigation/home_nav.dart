import 'package:flutter/material.dart';
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
            if (settings.name == "" /* /eventDetail*/) {
              // return the page that is supposed to display
              // details about an event.
              // on the press of the event in the list just remember to
              // do onPressed: () => Navigator.pushNamed(context, '/eventDetail')
              return Container();
            }

            return const Home();
          },
        );
      },
    );
  }
}
