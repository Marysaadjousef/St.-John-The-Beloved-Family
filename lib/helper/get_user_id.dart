import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

Future<String?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("userId$kUserName");
}
