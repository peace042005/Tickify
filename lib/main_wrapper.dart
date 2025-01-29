import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupe03_application/navigation/home_nav.dart';
import 'package:groupe03_application/navigation/profil_nav.dart';
import 'package:groupe03_application/navigation/search_nav.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});
  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;
  final homeNavigatorKey = GlobalKey<NavigatorState>();
  final profilNavigatorKey = GlobalKey<NavigatorState>();
  final searchNavigatorKey = GlobalKey<NavigatorState>();
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [];

  @override
  void initState() {
    super.initState();
    // ! NOTE: L'ordre ici est important
    // Même ordre que celui spécifiés dans les destinations
    _navigatorKeys.addAll([
      homeNavigatorKey,
      searchNavigatorKey,
      profilNavigatorKey,
    ]);
  }

  // Gérer le fait que l'utilisateur appuis sur le bouton de retour
  // en arrière sur Android
  Future<bool> _onPopPage() async {
    final NavigatorState? currentNavigator =
        _navigatorKeys[_selectedIndex].currentState;

    if (currentNavigator == null) return true;

    if (currentNavigator.canPop()) {
      currentNavigator.pop();
      return false; // Prevent default back action
    }

    // If already on the home tab, check if Home has a back stack
    if (_selectedIndex == 0) {
      final homeNavigator = _navigatorKeys[0].currentState;
      if (homeNavigator != null && homeNavigator.canPop()) {
        homeNavigator.pop(); // Pop Home tab stack first
        return false;
      }
      return true; // Nothing left to pop, allow app to close
    }

    // Otherwise, switch to Home tab
    setState(() {
      _selectedIndex = 0;
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.surface,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
        systemNavigationBarContrastEnforced: false,
      ),
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;

          final shouldPop = await _onPopPage();
          if (shouldPop && context.mounted) {
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          bottomNavigationBar: NavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.favorite_border),
                selectedIcon: Icon(Icons.favorite),
                label: "Accueil",
              ),
              NavigationDestination(
                icon: Icon(Icons.search),
                label: "Rechercher",
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: "Profil",
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                HomeNav(navigatorKey: homeNavigatorKey),
                SearchNav(navigatorKey: searchNavigatorKey),
                ProfilNav(navigatorKey: profilNavigatorKey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
