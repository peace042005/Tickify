import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade100, // Light background
    onSurface: Colors.black87, // Ensures good text contrast
    primary: Colors.blueGrey.shade600, // Modern muted color
    secondary: Colors.blueGrey.shade400, // Soft complementary color
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blueGrey.shade600,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900, // Dark background
    onSurface: Colors.white70, // Ensures readable text
    primary: Colors.teal.shade300, // Fresh contrast color
    secondary: Colors.teal.shade200, // Softer secondary elements
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.teal.shade300,
    foregroundColor: Colors.black,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
  ),
);
