import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habat_khardal/components/custom_button.dart';
import 'package:habat_khardal/components/custom_logo.dart';
import 'package:habat_khardal/cubits/toggle_mode_cubit/toggle_mode_cubit.dart';
import 'package:habat_khardal/helper/save_username.dart';
import 'package:habat_khardal/screens/register_screen.dart';
import 'package:habat_khardal/screens/reset_password_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/mode_icon.dart';
import '../components/custom_password_text_field.dart';
import '../components/custom_text_field.dart';
import '../constants.dart';
import '../cubits/toggle_mode_cubit/toggle_mode_states.dart';
import '../helper/check_if_it_is_collection_member.dart';
import '../helper/get_user_id_from_firebase.dart';
import '../helper/save_user_type.dart';
import '../helper/show_snackbar.dart';
import 'home_menu.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = "LoginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  CollectionReference admins = FirebaseFirestore.instance.collection(kAdmin);
  CollectionReference attendanceRecorders =
      FirebaseFirestore.instance.collection(kAttendanceRecorder);
  CollectionReference questionnaireDesigner =
      FirebaseFirestore.instance.collection(kQuestionnaireDesigner);

  String userName = "", password = "";

  GlobalKey<FormState> formKey = GlobalKey();

  bool inAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToggleModeCubit, ModeState>(
      builder: (context, state) => ModalProgressHUD(
        progressIndicator: const CircularProgressIndicator(),
        inAsyncCall: inAsyncCall,
        child: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                child: Form(
                  key: formKey,
                  child: Stack(children: [
                    Column(
                      children: [
                        const Spacer(
                          flex: 2,
                        ),
                        const CustomLogo(),
                        const Spacer(
                          flex: 2,
                        ),
                        Expanded(
                          flex: 8,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                CustomTextField(
                                  onChanged: (value) {
                                    userName = value;
                                  },
                                  label: "Name",
                                  validator: (name) {
                                    if (name == "") {
                                      return "Required Field";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                CustomPasswordTextField(
                                    onChanged: (value) {
                                      password = value;
                                    },
                                    label: "Password"),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ResetPasswordScreen()));
                                      },
                                      child: Text(
                                        "Forget Password ?",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                CustomButton(
                                  buttonText: "Login",
                                  onTab: () async {
                                    if (formKey.currentState!.validate()) {
                                      setState(() {
                                        inAsyncCall = true;
                                      });
                                      try {
                                        CollectionReference usersCollection =
                                            FirebaseFirestore.instance
                                                .collection("users");
                                        var userRecord = await usersCollection
                                            .doc("vMjErydVNOqmtPQer1d2")
                                            .get();
                                        var usersMap = userRecord.data()
                                            as Map<String, dynamic>;
                                        if (usersMap[userName] != null) {
                                          await loginUser(usersMap[userName]);
                                          kUserName = userName;
                                          await checkUserType();
                                          await saveUserName(userName);
                                          await getUserIDFromFirebaseAndSave();
                                          Navigator.popAndPushNamed(
                                              context, Menu.id);
                                        } else {
                                          showSnackBar(
                                              context, "Name not found");
                                        }
                                      } on FirebaseAuthException catch (e) {
                                        showSnackBar(context,
                                            getSuitableErrorMessage(e));
                                      } catch (e) {
                                        showSnackBar(context,
                                            "There was a problem, try later");
                                      }
                                      setState(() {
                                        inAsyncCall = false;
                                      });
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Don't have an account?  ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterScreen(
                                                      admins: admins,
                                                      attendanceRecorders:
                                                          attendanceRecorders,
                                                      questionnaireDesigner:
                                                          questionnaireDesigner,
                                                    )));
                                      },
                                      child: Text(
                                        "Register",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(
                          flex: 3,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        top: 54.0.h,
                      ),
                      child: ModeIcon(state: state),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkUserType() async {
    bool isAdmin = await checkItIsCollectionMember(kUserName!, admins);
    if (isAdmin) {
      saveUserType("Admin");
      return;
    }
    bool isAttendanceRecorder =
        await checkItIsCollectionMember(kUserName!, attendanceRecorders);
    if (isAttendanceRecorder) {
      saveUserType("AttendanceRecorder");
      return;
    } else {
      saveUserType("NormalUser");
    }
  }

  Future<void> loginUser(String email) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  String getSuitableErrorMessage(FirebaseAuthException e) {
    String message = "";
    if (e.code == "user-not-found") {
      message = "User not found";
    } else if (e.code == "invalid-email") {
      message = "Invalid name";
    } else if (e.code == "wrong-password") {
      message = "Wrong password";
    } else if (e.code == "network-request-failed") {
      message = "No internet connection";
    } else {
      message = "There was a problem, try later";
    }
    return message;
  }
}
