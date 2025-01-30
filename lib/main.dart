import 'package:flutter/material.dart';
import 'package:groupe03_application/main_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:groupe03_application/themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("token") ?? "";
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String token;
  const MyApp({super.key, required this.token});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      // home: token == "" ? const Register() : const Register(),
      home: const MainWrapper(),
    );
  }
}
