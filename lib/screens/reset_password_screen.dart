import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habat_khardal/components/custom_button.dart';
import 'package:habat_khardal/components/custom_logo.dart';
import 'package:habat_khardal/cubits/toggle_mode_cubit/toggle_mode_cubit.dart';
import 'package:habat_khardal/helper/show_snackbar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/mode_icon.dart';
import '../components/custom_text_field.dart';
import '../cubits/toggle_mode_cubit/toggle_mode_states.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  static String id = "ResetPasswordScreen";

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String email = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GlobalKey<FormState> formKey = GlobalKey();

  bool inAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToggleModeCubit, ModeState>(
      builder: (context, state) => ModalProgressHUD(
        progressIndicator: const CircularProgressIndicator(),
        inAsyncCall: inAsyncCall,
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0.w),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  child: Stack(children: [
                    Column(
                      children: [
                        const Spacer(
                          flex: 1,
                        ),
                        const CustomLogo(),
                        const Spacer(
                          flex: 2,
                        ),
                        Row(
                          children: [
                            Text(
                              "Reset Password",
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
                            email = value;
                          },
                          label: "Email",
                          validator: (email) {
                            if (email == null || email == "") {
                              return "Required Field";
                            } else if (!RegExp(r'\S+@\S+\.\S+')
                                .hasMatch(email)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        CustomButton(
                          buttonText: "Send Mail",
                          onTab: () async {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                inAsyncCall = true;
                              });
                              email = email.trim();
                              try {
                                await _auth.sendPasswordResetEmail(
                                    email: email);
                                // Notify user that an email has been sent
                                showSnackBar(
                                  context,
                                  "Password reset email sent! Check your inbox",
                                  color: Colors.white,
                                );
                              } catch (e) {
                                showSnackBar(
                                    context, "Failed to send reset email: $e");
                              }
                              setState(() {
                                inAsyncCall = false;
                              });
                            }
                          },
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
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
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
}
