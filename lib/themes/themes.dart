import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    // secondary: Colors.grey.shade800,
    tertiary: Colors.white,
    inversePrimary: Colors.grey.shade900,
    onSurface: Colors.black87,
    onSecondary: Colors.grey.shade800,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade500,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade900),
    bodyLarge: TextStyle(
        fontSize: 16, color: Colors.grey.shade800, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.grey.shade800),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF0B1014), // Your requested base color
    onSurface: Color(0xFFD9D9D9), // Light gray for text readability
    primary: Color(0xFF131B21), // Slightly lighter variant
    secondary: Color(0xFF404040), // Even lighter for contrast
    onSecondary: Color(0xFFB0B0B0),
    outline: Color(0xFF1F2A32), // Border color for navigation
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0B1014),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    bodyLarge: TextStyle(
        fontSize: 16, color: Color(0xFFD9D9D9), fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFB0B0B0)),
  ),
);
