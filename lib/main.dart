import 'package:flutter/material.dart';
import 'package:groupe03_application/main_wrapper.dart';
import 'package:groupe03_application/themes/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:groupe03_application/themes/themes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("token") ?? "";
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(token: token),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String token;
  const MyApp({super.key, required this.token});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          home: const MainWrapper(),
        );
      },
    );
  }
}
