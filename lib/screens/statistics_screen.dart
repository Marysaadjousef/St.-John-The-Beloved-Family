import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habat_khardal/components/info_table.dart';
import 'package:habat_khardal/helper/get_user_id.dart';
import 'package:habat_khardal/helper/show_snackbar.dart';
import '../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helper/get_user_id_from_firebase.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});
  static const String id = "StatisticsScreen";

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Map<String, dynamic> statisticsMap = {};
  bool? foundData;

  Future<void> getStatistics() async {
    String? userId = await getUserId();
    if (userId == null && kLastAccessedDate != null) {
      await getUserIDFromFirebaseAndSave();
      userId = await getUserId();
    }
    if (userId == null) {
      foundData = false;
    } else {
      CollectionReference dailyRecords =
          FirebaseFirestore.instance.collection(kDailyRecords);
      var userRecord = await dailyRecords.doc(userId).get();
      statisticsMap = userRecord.data() as Map<String, dynamic>;
      statisticsMap.remove("name");
      statisticsMap.remove("lastAccessedDate");
      foundData = true;
    }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStatistics().timeout(const Duration(seconds: 10), onTimeout: () {
      showSnackBar(context, "Check your internet connection!");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (foundData != null && foundData!) {
      return InfoTable(statisticsMap: statisticsMap);
    } else {
      return Expanded(
        child: Column(
          children: [
            const Spacer(
              flex: 1,
            ),
            foundData == null
                ? const CircularProgressIndicator()
                : Text(
                    "No Records",
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      );
    }
  }
}
