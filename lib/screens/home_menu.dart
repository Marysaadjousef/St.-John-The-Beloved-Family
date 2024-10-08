import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habat_khardal/cubits/change_loading_cubit/change_loading_states.dart';
import 'package:habat_khardal/cubits/change_screen_cubit/change_screen_cubit.dart';
import 'package:habat_khardal/cubits/change_select_all_value_cubit/change_select_all_value_cubit.dart';
import 'package:habat_khardal/cubits/toggle_mode_cubit/toggle_mode_cubit.dart';
import 'package:habat_khardal/screens/admin_tracking_screen.dart';
import 'package:habat_khardal/screens/home_screen.dart';
import 'package:habat_khardal/screens/record_meeting_attendance_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../constants/colors.dart';
import '../cubits/change_loading_cubit/change_loading_cubit.dart';
import '../cubits/change_screen_cubit/change_screen_states.dart';
import '../cubits/collapse_screen_cubit/collapse_screen_states.dart';
import '../cubits/collapse_screen_cubit/collapse_screen_cubit.dart';
import '../cubits/set_user_type/set_user_type_states.dart';
import '../cubits/set_user_type/set_user_type_cubit.dart';
import '../cubits/toggle_mode_cubit/toggle_mode_states.dart';
import '../screens/login_screen.dart';
import '../screens/ranking_screen.dart';
import '../screens/statistics_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tasks.dart';

class Menu extends StatefulWidget {
  static const String id = "Menu";
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Color iconColor = Colors.white;
  late String modeText;
  double imageSize = 20.r;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting();
    _getUserType();
  }

  Future<void> _getUserType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      kUserName = preferences.getString("userName")!;
    });
    String? userType = preferences.getString(kUserType);
    context.read<SetUserTypeCubit>().setUserTypeState(userType!);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<ToggleModeCubit, ModeState>(
        builder: (context, modeState) {
      if (modeState is DarkModeState) {
        modeText = "Light Mode";
      } else {
        modeText = "Dark Mode";
      }
      return BlocProvider<ChangeLoadingCubit>(
        create: (context) => ChangeLoadingCubit(),
        child: BlocBuilder<ChangeLoadingCubit, LoadingState>(
            builder: (context, loadingState) {
          return ModalProgressHUD(
            inAsyncCall: loadingState is ActiveState,
            child: Scaffold(
              backgroundColor: modeState is DarkModeState
                  ? const Color.fromRGBO(26, 41, 58, 0.6)
                  : const Color.fromRGBO(26, 41, 58, 1),
              body: BlocBuilder<CollapseScreenCubit, ScreenState>(
                builder: (context, state1) {
                  return SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          BlocBuilder<SetUserTypeCubit, UserTypeState>(
                              builder: (context, state) {
                            return Container(
                              padding: EdgeInsets.only(top: 50.h, left: 8.w),
                              width: (0.7 * MediaQuery.of(context).size.width),
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0.w),
                                    child: Row(
                                      children: [
                                        Text(
                                          "MENU",
                                          style: TextStyle(
                                            fontFamily: "Orbitron",
                                            color: iconColor,
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(
                                    flex: 2,
                                  ),
                                  Expanded(
                                    flex: 20,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              context
                                                  .read<CollapseScreenCubit>()
                                                  .changeScreenState();
                                              context
                                                  .read<ChangeScreenCubit>()
                                                  .changeScreen(HomeScreen.id);
                                            },
                                            child: ListTile(
                                              leading: Image.asset(
                                                "assets/images/checklist (1).png",
                                                height: imageSize,
                                              ),
                                              title: Text(
                                                "Home",
                                                style: TextStyle(
                                                    fontFamily: "Orbitron",
                                                    color: Colors.white,
                                                    fontSize: 18.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30.h,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              context
                                                  .read<CollapseScreenCubit>()
                                                  .changeScreenState();
                                              context
                                                  .read<ChangeScreenCubit>()
                                                  .changeScreen(
                                                      StatisticsScreen.id);
                                            },
                                            child: ListTile(
                                              leading: Icon(
                                                Icons.insights,
                                                color: iconColor,
                                                size: imageSize,
                                              ),
                                              title: Text(
                                                "Statistics",
                                                style: TextStyle(
                                                    fontFamily: "Orbitron",
                                                    color: Colors.white,
                                                    fontSize: 18.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30.h,
                                          ),
                                          if (state
                                              is AttendanceRecorderUserState) ...[
                                            GestureDetector(
                                              onTap: () {
                                                context
                                                    .read<CollapseScreenCubit>()
                                                    .changeScreenState();
                                                context
                                                    .read<ChangeScreenCubit>()
                                                    .changeScreen(
                                                        RecordMeetingAttendanceScreen
                                                            .id);
                                              },
                                              child: ListTile(
                                                leading: Image.asset(
                                                  "assets/images/attendance.png",
                                                  height: imageSize,
                                                ),
                                                title: Text(
                                                  "Attendance",
                                                  style: TextStyle(
                                                      fontFamily: "Orbitron",
                                                      color: Colors.white,
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30.h,
                                            ),
                                          ],
                                          if (state
                                                  is AttendanceRecorderUserState ||
                                              state is AdminUserState) ...[
                                            GestureDetector(
                                              onTap: () {
                                                context
                                                    .read<CollapseScreenCubit>()
                                                    .changeScreenState();
                                                context
                                                    .read<ChangeScreenCubit>()
                                                    .changeScreen(
                                                        RankingScreen.id);
                                              },
                                              child: ListTile(
                                                leading: Image.asset(
                                                  "assets/images/medals.png",
                                                  height: imageSize,
                                                ),
                                                title: Text(
                                                  "Ranking",
                                                  style: TextStyle(
                                                      fontFamily: "Orbitron",
                                                      color: Colors.white,
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30.h,
                                            ),
                                          ],
                                          if (state is AdminUserState) ...[
                                            GestureDetector(
                                              onTap: () {
                                                context
                                                    .read<CollapseScreenCubit>()
                                                    .changeScreenState();
                                                context
                                                    .read<ChangeScreenCubit>()
                                                    .changeScreen(
                                                        AdminTrackingScreen.id);
                                              },
                                              child: ListTile(
                                                leading: Icon(
                                                  Icons.assignment,
                                                  color: iconColor,
                                                  size: imageSize,
                                                ),
                                                title: Text(
                                                  "Tracking",
                                                  style: TextStyle(
                                                      fontFamily: "Orbitron",
                                                      color: Colors.white,
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30.h,
                                            ),
                                          ],
                                          BlocBuilder<ToggleModeCubit,
                                              ModeState>(
                                            builder: (context, state) =>
                                                GestureDetector(
                                              onTap: () async {
                                                context
                                                    .read<ToggleModeCubit>()
                                                    .toggleMode();
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                prefs.setString("mode", mode);
                                              },
                                              child: ListTile(
                                                leading: state is LightModeState
                                                    ? Icon(
                                                        Icons.dark_mode_rounded,
                                                        color: iconColor,
                                                      )
                                                    : Icon(
                                                        Icons
                                                            .light_mode_rounded,
                                                        color: iconColor,
                                                        size: imageSize,
                                                      ),
                                                title: Text(
                                                  modeText,
                                                  style: TextStyle(
                                                      fontFamily: "Orbitron",
                                                      color: Colors.white,
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30.h,
                                          ),
                                          if (kUserName != null) ...[
                                            ListTile(
                                              leading: Icon(
                                                Icons.person,
                                                color: iconColor,
                                                size: imageSize,
                                              ),
                                              title: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      kUserName!,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Orbitron",
                                                          color: Colors.white,
                                                          fontSize: 18.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const Spacer(
                                                    flex: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30.h,
                                            ),
                                          ],
                                          GestureDetector(
                                            onTap: () async {
                                              await _logout();
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              for (int i = 0;
                                                  i <
                                                      activitiesModelsList
                                                          .length;
                                                  i++) {
                                                prefs.setBool(
                                                    activitiesModelsList[i]
                                                        .name,
                                                    false);
                                              }
                                              context
                                                  .read<CollapseScreenCubit>()
                                                  .changeScreenState();
                                              context
                                                  .read<ChangeScreenCubit>()
                                                  .changeScreen(HomeScreen.id);
                                              Navigator.popAndPushNamed(
                                                  context, LoginScreen.id);
                                            },
                                            child: ListTile(
                                              leading: Icon(
                                                Icons.logout_rounded,
                                                color: iconColor,
                                                size: imageSize,
                                              ),
                                              title: Text(
                                                "Logout",
                                                style: TextStyle(
                                                    fontFamily: "Orbitron",
                                                    color: Colors.white,
                                                    fontSize: 18.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(
                                    flex: 1,
                                  ),
                                ],
                              ),
                            );
                          }),
                          Transform.translate(
                            offset: state1 is NotCollapsedState
                                ? Offset(0.45 * width, 0.03 * height)
                                : const Offset(1, 1),
                            child: SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: AnimatedScale(
                                // alignment: Alignment.centerLeft,
                                duration: const Duration(milliseconds: 7),
                                scale: state1 is NotCollapsedState ? 0.65 : 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      state1 is NotCollapsedState ? 30 : 0),
                                  child: GestureDetector(
                                    onHorizontalDragUpdate: (_) {
                                      if (state1 is NotCollapsedState) {
                                        context
                                            .read<CollapseScreenCubit>()
                                            .changeScreenState();
                                      }
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color: kBackgroundColor,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24.w, vertical: 32.h),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  context
                                                      .read<
                                                          CollapseScreenCubit>()
                                                      .changeScreenState();
                                                },
                                                icon: Icon(
                                                  Icons.menu_rounded,
                                                  color: Colors.white,
                                                  weight: 100.w,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                DateFormat('EEEE', 'en')
                                                    .format(DateTime.now()),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const Spacer(),
                                              Image.asset(
                                                "assets/images/joseph.png",
                                                height: 60.h,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          BlocBuilder<ChangeScreenCubit,
                                                  ScreenShownState>(
                                              builder: (context, state) => state
                                                      is StatisticsScreenState
                                                  ? const StatisticsScreen()
                                                  : state
                                                          is AttendanceScreenState
                                                      ? const RecordMeetingAttendanceScreen()
                                                      : state
                                                              is RankingScreenState
                                                          ? const RankingScreen()
                                                          : state
                                                                  is AdminTrackingScreenState
                                                              ? const AdminTrackingScreen()
                                                              : BlocProvider<
                                                                      ChangeSelectAllValueCubit>(
                                                                  create: (BuildContext
                                                                      context) {
                                                                    return ChangeSelectAllValueCubit();
                                                                  },
                                                                  child:
                                                                      const HomeScreen())),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }),
      );
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
