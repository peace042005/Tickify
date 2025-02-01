import 'package:flutter/material.dart';
import 'package:groupe03_application/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeSettingsWidget extends StatelessWidget {
  const ThemeSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return ToggleButtons(
          isSelected: [
            themeProvider.themeMode == ThemeMode.light,
            themeProvider.themeMode == ThemeMode.system,
            themeProvider.themeMode == ThemeMode.dark,
          ],
          onPressed: (int index) {
            ThemeMode selectedMode = [
              ThemeMode.light,
              ThemeMode.system,
              ThemeMode.dark,
            ][index];
            themeProvider.setThemeMode(selectedMode);
          },
          borderRadius: BorderRadius.circular(8),
          selectedColor: Theme.of(context).colorScheme.onSecondary,
          fillColor: Theme.of(context).colorScheme.primary,
          color: Theme.of(context).colorScheme.onSurface,
          constraints: const BoxConstraints(minHeight: 40, minWidth: 80),
          children: const [
            Text('Claire'),
            Text('Système'),
            Text('Sombre'),
          ],
        );
      },
    );
  }
}
