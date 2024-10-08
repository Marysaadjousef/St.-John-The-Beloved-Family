import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../components/info_table.dart';

class UserDailyRecordsScreen extends StatefulWidget {
  const UserDailyRecordsScreen(
      {super.key, required this.userInfoMap, required this.name});
  final Map<String, dynamic> userInfoMap;
  final String name;

  @override
  State<UserDailyRecordsScreen> createState() => _UserDailyRecordsScreenState();
}

class _UserDailyRecordsScreenState extends State<UserDailyRecordsScreen> {
  bool? findData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findData = widget.userInfoMap.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 32.h),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  weight: 100.w,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 220.w,
                child: Center(
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const Spacer(),
              Image.asset(
                "assets/images/joseph.png",
                height: 60.h,
              ),
            ],
          ),
          if (findData != null && findData!)
            InfoTable(statisticsMap: widget.userInfoMap)
          else ...[
            const Spacer(flex: 1),
            Center(
              child: findData == false
                  ? Text(
                      "No Records",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    )
                  : const CircularProgressIndicator(),
            ),
            const Spacer(
              flex: 1,
            ),
          ],
        ],
      ),
    ));
  }
}
