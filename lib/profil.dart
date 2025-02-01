import 'package:flutter/material.dart';
import 'package:groupe03_application/components/theme_settings_widget.dart';
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
    setState(() {});
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

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Icon(Icons.person,
                size: 30, color: Theme.of(context).colorScheme.onPrimary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$prenom $name',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    String? subtitle,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: iconColor ?? Theme.of(context).colorScheme.onSecondary,
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Profil"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.1), // Thickness of the border
          child: Container(
            color: Theme.of(context).colorScheme.onSurface,
            height: 0.1, // Thickness
          ),
        ),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserData,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileSection(),
              const SizedBox(height: 8),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.onSurface,
                thickness: 0.1,
              ),
              _buildListItem(
                title: 'Vos tickets',
                subtitle: 'Consultez vos tickets achetés',
                icon: Icons.receipt_long,
                onTap: () => Navigator.pushNamed(context, '/myTickets'),
              ),
              _buildListItem(
                title: 'Paramètres',
                subtitle: 'Modifier certaines valeurs de l\'application',
                icon: Icons.settings,
                onTap: () => Navigator.pushNamed(context, '/settings'),
              ),
              _buildListItem(
                title: 'A propos',
                subtitle: 'En savoir plus sur les développeurs',
                icon: Icons.help,
                onTap: () => Navigator.pushNamed(context, '/about'),
              ),
              const SizedBox(
                height: 20,
              ),
              const ThemeSettingsWidget(),
              const SizedBox(
                height: 20,
              ),
              if (token.isNotEmpty)
                _buildListItem(
                  title: 'Se déconnecter',
                  icon: Icons.logout,
                  iconColor: Colors.red,
                  onTap: () async {
                    await logout();
                    setState(() {});
                    await _loadUserData();
                  },
                )
              else
                _buildListItem(
                  title: 'Se connecter',
                  icon: Icons.login,
                  onTap: () => Navigator.pushNamed(context, '/login'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
