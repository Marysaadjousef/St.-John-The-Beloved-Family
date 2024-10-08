import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habat_khardal/components/custom_password_text_field.dart';
import 'package:habat_khardal/cubits/toggle_mode_cubit/toggle_mode_cubit.dart';
import 'package:habat_khardal/cubits/toggle_mode_cubit/toggle_mode_states.dart';
import 'package:habat_khardal/helper/save_user_type.dart';
import '../components/mode_icon.dart';
import '../components/custom_logo.dart';
import '../components/custom_text_field.dart';
import '../constants.dart';
import '../helper/check_if_it_is_collection_member.dart';
import '../helper/save_username.dart';
import '../helper/show_snackbar.dart';
import 'home_menu.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen(
      {super.key,
      required this.admins,
      required this.attendanceRecorders,
      required this.questionnaireDesigner});
  static const String id = "RegisterScreen";
  final CollectionReference admins, attendanceRecorders, questionnaireDesigner;
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String email = "", name = "", firstPassword = "", secondPassword = "";
  CollectionReference users = FirebaseFirestore.instance.collection(kUsers);

  bool _inAsyncCall = false;
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToggleModeCubit, ModeState>(
      builder: (context, state) => ModalProgressHUD(
        inAsyncCall: _inAsyncCall,
        progressIndicator: const CircularProgressIndicator(),
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0.w),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  child: Stack(
                    children: [
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
                            flex: 20,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Register",
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
                                      name = value;
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
                                  CustomTextField(
                                    onChanged: (value) {
                                      email = value;
                                    },
                                    label: "Email",
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
                                        firstPassword = value;
                                      },
                                      label: "Password"),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  CustomPasswordTextField(
                                      onChanged: (value) {
                                        secondPassword = value;
                                      },
                                      label: "Confirm Password"),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (formKey.currentState!.validate()) {
                                        if (firstPassword == secondPassword) {
                                          setState(() {
                                            _inAsyncCall = true;
                                          });
                                          try {
                                            CollectionReference
                                                usersCollection =
                                                FirebaseFirestore.instance
                                                    .collection("users");
                                            var userRecord =
                                                await usersCollection
                                                    .doc("vMjErydVNOqmtPQer1d2")
                                                    .get();
                                            var usersMap = userRecord.data()
                                                as Map<String, dynamic>;
                                            if (usersMap[name] != null) {
                                              showSnackBar(context,
                                                  "Name already in use");
                                            } else {
                                              await createUser();
                                              kUserName = name;
                                              await usersCollection
                                                  .doc("vMjErydVNOqmtPQer1d2")
                                                  .set({name: email},
                                                      SetOptions(merge: true));

                                              await saveUserName(kUserName!);
                                              await checkUserType();
                                              Navigator.pop(context);
                                              Navigator.popAndPushNamed(
                                                  context, Menu.id);
                                            }
                                          } on FirebaseAuthException catch (e) {
                                            showSnackBar(context,
                                                getSuitableErrorMessage(e));
                                          } catch (e) {
                                            showSnackBar(context,
                                                "There was an error, try later");
                                          }
                                          setState(() {
                                            _inAsyncCall = false;
                                          });
                                        } else {
                                          showSnackBar(context,
                                              "Password does not match");
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 40.h,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadiusDirectional.circular(
                                                  5)),
                                      child: Center(
                                        child: Text(
                                          "Register",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Already have an account?  ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Login",
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkUserType() async {
    bool isAdmin = await checkItIsCollectionMember(kUserName!, widget.admins);
    if (isAdmin) {
      saveUserType("Admin");
      return;
    }
    bool isAttendanceRecorder =
        await checkItIsCollectionMember(kUserName!, widget.attendanceRecorders);
    if (isAttendanceRecorder) {
      saveUserType("AttendanceRecorder");
      return;
    } else {
      saveUserType("NormalUser");
    }
  }

  Future<void> createUser() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: firstPassword,
    );
  }

  String getSuitableErrorMessage(FirebaseAuthException e) {
    String message;
    if (e.code == 'weak-password') {
      message = "Weak password";
    } else if (e.code == 'email-already-in-use') {
      message = "Email already in use";
    } else if (e.code == "invalid-email") {
      message = "Invalid email";
    } else if (e.code == "network-request-failed") {
      message = "No internet connection";
    } else {
      message = "There was an error, try later";
    }
    return message;
  }
}
