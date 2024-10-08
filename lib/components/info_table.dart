import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/tasks_images.dart';
import '../tasks.dart';

class InfoTable extends StatelessWidget {
  const InfoTable({super.key, required this.statisticsMap});
  final Map<String, dynamic> statisticsMap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Spacer(
            flex: 1,
          ),
          Expanded(
            flex: 20,
            child: SingleChildScrollView(
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(
                      0.5), // "Task" column takes twice as much space
                  1: FlexColumnWidth(
                      1), // "Frequency" column takes default space
                  2: FlexColumnWidth(1), // "Last Time"
                }, //
                border: const TableBorder(
                    horizontalInside: BorderSide(color: Colors.white12),
                    verticalInside: BorderSide(color: Colors.white12),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                children: [
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 24.0.h),
                      child: Center(
                        child: Text(
                          "Task",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Count",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Last Time",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                    )
                  ]),
                  for (int i = 0; i < statisticsMap.keys.length; i++) ...[
                    TableRow(children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/${images[i]}",
                              height: 30.h,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 24.0.h,
                        ),
                        child: Center(
                          child: Text(
                            statisticsMap[activitiesModelsList[i].name]["count"]
                                .toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0.h),
                        child: Center(
                          child: Text(
                            statisticsMap[activitiesModelsList[i].name]
                                ["lastTime"],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ]
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
  }
}
