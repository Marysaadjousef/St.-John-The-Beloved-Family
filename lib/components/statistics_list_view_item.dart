import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticsListViewItem extends StatelessWidget {
  const StatisticsListViewItem(
      {super.key,
      required this.image,
      required this.name,
      required this.count,
      required this.lastTime});

  final String image;
  final String name;
  final int count;
  final String lastTime;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0.h),
        child: Row(children: [
          Image.asset(
            "assets/images/$image",
            height: 30.h,
          ),
          SizedBox(
            width: 8.w,
          ),
          Text(
            name,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Text(
            count.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          const Spacer(),
          Text(
            lastTime,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
        ]),
      ),
    );
  }
}
