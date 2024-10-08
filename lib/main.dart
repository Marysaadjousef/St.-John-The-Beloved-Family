import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habat_khardal/constants/colors.dart';
import 'package:habat_khardal/cubits/change_screen_cubit/change_screen_cubit.dart';
import 'package:habat_khardal/cubits/change_select_all_value_cubit/change_select_all_value_cubit.dart';
import 'package:habat_khardal/cubits/toggle_mode_cubit/toggle_mode_cubit.dart';
import 'package:habat_khardal/cubits/toggle_mode_cubit/toggle_mode_states.dart';
import 'package:habat_khardal/screens/home_menu.dart';
import 'package:habat_khardal/screens/login_screen.dart';
import 'package:habat_khardal/screens/reset_password_screen.dart';
import 'package:habat_khardal/screens/splash_screen.dart';
import 'cubits/collapse_screen_cubit/collapse_screen_cubit.dart';
import 'cubits/set_user_type/set_user_type_cubit.dart';
import 'firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const MyApp());
}
//235806

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ToggleModeCubit>(
      create: (context) => ToggleModeCubit(),
      child: BlocProvider<CollapseScreenCubit>(
        create: (context) => CollapseScreenCubit(),
        child: BlocProvider<SetUserTypeCubit>(
          create: (context) => SetUserTypeCubit(),
          child: BlocBuilder<ToggleModeCubit, ModeState>(
            builder: (context, state) => BlocProvider<ChangeScreenCubit>(
                create: (context) => ChangeScreenCubit(),
                child: ScreenUtilInit(
                    ensureScreenSize: true,
                    designSize: const Size(411, 843),
                    minTextAdapt: true,
                    splitScreenMode: true,
                    // Use builder only if you need to use library outside ScreenUtilInit context
                    builder: (context, child) {
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        routes: {
                          SplashScreen.id: (_) => const SplashScreen(),
                          LoginScreen.id: (_) => const LoginScreen(),
                          Menu.id: (_) => const Menu(),
                          ResetPasswordScreen.id: (_) =>
                              const ResetPasswordScreen(),
                        },
                        initialRoute: SplashScreen.id,
                        theme: ThemeData(
                          scaffoldBackgroundColor: kBackgroundColor,
                          textTheme: Typography.englishLike2018.apply(
                            fontSizeFactor: 1.sp,
                            fontFamily: "Righteous",
                          ),
                        ),
                      );
                    })),
          ),
        ),
      ),
    );
  }
}
