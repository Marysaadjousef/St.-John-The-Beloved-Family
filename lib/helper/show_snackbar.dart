import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';

void showSnackBar(BuildContext context, String message,
    {Color color = kPinkColor}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(seconds: 3),
    content: Text(
      message,
      style: TextStyle(
          fontSize: 18.sp,
          color: color == Colors.white ? Colors.black : Colors.white),
    ),
    backgroundColor: color,
  ));
}
