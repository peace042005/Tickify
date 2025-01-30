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

  DateTime? _lastBackPressTime; // Track the last back press time

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

    // Si nous ne sommes sur aucune page (surement un bug), sortir de l'application
    if (currentNavigator == null) return true;

    // Si nous sommes sur une page où nous pouvons revenir en arrière
    // Revenir en arrière et empêcher l'application de se fermer
    if (currentNavigator.canPop()) {
      currentNavigator.pop();
      return false;
    }

    // Si nous sommes sur la page d'accueil, et qu'on peut toujours revenir en arrière,
    // revenir
    if (_selectedIndex == 0) {
      final homeNavigator = _navigatorKeys[0].currentState;
      if (homeNavigator?.canPop() ?? false) {
        homeNavigator!.pop(); // Pop Home tab stack first
        return false;
      }

      final now = DateTime.now();
      if (_lastBackPressTime == null ||
          now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
        // First press or more than 2 seconds since last press
        _lastBackPressTime = now;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appuyez à nouveau pour quitter'),
            duration: Duration(seconds: 2),
          ),
        );
        return false;
      }

      return true;
    }

    // Otherwise, switch to Home tab
    setState(() => _selectedIndex = 0);
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
          backgroundColor: Theme.of(context).colorScheme.surface,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 0.1,
                ),
              ),
            ),
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              indicatorColor: Theme.of(context).colorScheme.secondary,
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
