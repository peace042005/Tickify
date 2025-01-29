import 'package:groupe03_application/data/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logout() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  UserService userService = UserService();
  userService.logout();
  prefs.clear();
}
