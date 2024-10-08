import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habat_khardal/screens/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../cubits/toggle_mode_cubit/toggle_mode_cubit.dart';
import 'home_menu.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String id = "SplashScreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _getInitialRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mode = prefs.getString("mode") ?? "Light";

    context.read<ToggleModeCubit>().setMode(mode);

    await Future.delayed(const Duration(seconds: 1));

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.popAndPushNamed(context, Menu.id);
    } else {
      Navigator.popAndPushNamed(context, LoginScreen.id);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getInitialRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/joseph.png",
          height: 100.r,
        ),
      ),
    );
  }
}
