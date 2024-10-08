import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RankingListView extends StatelessWidget {
  const RankingListView({super.key, required this.users});
  final List<Map<String, dynamic>> users;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (users[index]["image"] != null) ...[
                  Image.asset(
                    "assets/images/${users[index]["image"]}.png",
                    height: 30.h,
                  ),
                  SizedBox(width: 8.w),
                ],
                Expanded(
                  flex: 2,
                  child: Text(
                    users[index]["name"],
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
                Text(
                  users[index]["count"].toString(),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 30.0.h,
        );
      },
      itemCount: users.length,
    );
  }
}
