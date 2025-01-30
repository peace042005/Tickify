import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:groupe03_application/util/logout.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});
  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String name = '';
  String prenom = '';
  String email = '';
  String token = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'Non renseigné';
      prenom = prefs.getString('prenom') ?? 'Non renseigné';
      email = prefs.getString('email') ?? 'Non renseigné';
      token = prefs.getString('token') ?? '';
    });
  }

  Widget _buildProfileCard() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              '$prenom $name',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.email, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard({
    required String title,
    required IconData icon,
    required String route,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Votre profil"),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserData,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                child: _buildProfileCard(),
              ),
              const SizedBox(height: 16),
              _buildNavigationCard(
                title: 'Vos tickets',
                icon: Icons.receipt_long,
                route: '/myTickets',
                color: Colors.blue,
              ),
              _buildNavigationCard(
                title: 'Paramètres',
                icon: Icons.settings,
                route: '/settings',
                color: Colors.grey,
              ),
              _buildNavigationCard(
                title: 'A propos',
                icon: Icons.help,
                route: '/about',
                color: Colors.green,
              ),
              token != ''
                  ? Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.red.withOpacity(0.1),
                          child: const Icon(Icons.logout, color: Colors.red),
                        ),
                        title: const Text('Se déconnecter'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          await logout();
                          setState(() {});
                          await _loadUserData();
                        },
                      ),
                    )
                  : _buildNavigationCard(
                      title: 'Se connecter',
                      icon: Icons.login,
                      route: '/login',
                      color: Colors.purple),
            ],
          ),
        ),
      ),
    );
  }
}
