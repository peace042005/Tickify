import 'package:shared_preferences/shared_preferences.dart';

Future<bool> userLoggedIn() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString("token") ?? '';

  return token != '';
}
