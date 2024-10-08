import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habat_khardal/cubits/show_password_cubit/show_password_cubit.dart';
import 'package:habat_khardal/cubits/show_password_cubit/show_password_states.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPasswordTextField extends StatelessWidget {
  const CustomPasswordTextField(
      {super.key, required this.onChanged, required this.label});

  final Function(String) onChanged;
  final String label;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShowPasswordCubit>(
      create: (context) => ShowPasswordCubit(),
      child: BlocBuilder<ShowPasswordCubit, PasswordState>(
        builder: (context, state) {
          return TextFormField(
            validator: (password) {
              if (password == "") {
                return "Required Field";
              }
            },
            obscureText: state is HiddenPasswordState,
            onChanged: onChanged,
            cursorColor: Colors.white,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  state is VisiblePasswordState
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.white,
                ),
                onPressed: () {
                  context.read<ShowPasswordCubit>().togglePasswordState();
                },
              ),
              label: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                ),
                // textDirection: TextDirection.ltr, // Right to Left
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
