import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    tertiary: Colors.white,
    inversePrimary: Colors.grey.shade900,
    onSurface: Colors.black87,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade500,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade900),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.grey.shade800),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.grey.shade800),
  ),
);

// ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   colorScheme: const ColorScheme.dark(
//     surface: Color.fromARGB(255, 20, 20, 20),
//     onSurface: Color.fromARGB(255, 105, 105, 105),
//     primary: Color.fromARGB(255, 30, 30, 30),
//     secondary: Color.fromARGB(255, 47, 47, 47),
//   ),
//   appBarTheme: const AppBarTheme(
//     backgroundColor: Color.fromARGB(255, 30, 30, 30),
//     foregroundColor: Colors.white,
//     elevation: 0,
//   ),
//   textTheme: const TextTheme(
//     titleLarge: TextStyle(
//         fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
//     bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
//     bodyMedium: TextStyle(fontSize: 14, color: Colors.white60),
//   ),
// );

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF1E1E2E), // Dark, but not pure black
    onSurface: Color(0xFFD9D9D9), // Light gray for readability
    primary: Color(0xFF313244), // Muted dark blue-gray
    secondary: Color(0xFF45475A), // Slightly lighter gray for contrast
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E2E),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFD9D9D9)),
    bodyMedium:
        TextStyle(fontSize: 14, color: Color(0xFFB0B0B0)), // Softer gray
  ),
);
