import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres (à implémenter)"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.1), // Thickness of the border
          child: Container(
            color: Theme.of(context).colorScheme.onSurface,
            height: 0.1, // Thickness
          ),
        ),
      ),
      body: const Center(
        child: Text("Hello"),
      ),
    );
  }
}
