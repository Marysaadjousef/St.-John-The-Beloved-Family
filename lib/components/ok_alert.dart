import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';

class DoneAlert extends StatelessWidget {
  const DoneAlert({super.key, required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/lotties/Animation - 1723723507044.json',
            height: 150.h,
          ),
          MaterialButton(
            color: kBackgroundColor,
            onPressed: onPressed,
            child: Text(
              'Ok',
              style: TextStyle(color: Colors.white, fontSize: 18.sp),
            ),
          )
        ],
      ),
    );
  }
}
