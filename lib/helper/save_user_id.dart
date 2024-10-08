import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

Future<void> saveUserId(String userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("userId$kUserName", userId);
}
