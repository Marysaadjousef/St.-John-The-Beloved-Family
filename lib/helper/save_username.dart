import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserName(String userName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("userName", userName);
}
