import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habat_khardal/screens/user_daily_records_screen.dart';
import '../constants.dart';
import '../helper/show_snackbar.dart';
import '../models/activity_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminTrackingScreen extends StatefulWidget {
  const AdminTrackingScreen({super.key});
  static const String id = "AdminTrackingScreen";

  @override
  State<AdminTrackingScreen> createState() => _AdminTrackingScreenState();
}

class _AdminTrackingScreenState extends State<AdminTrackingScreen> {
  List<String> searchResultsList = [], usersList = [];
  var dailyRecordsCollection;
  CollectionReference dailyRecords =
      FirebaseFirestore.instance.collection(kDailyRecords);

  Future<void> _getUsers() async {
    CollectionReference users = FirebaseFirestore.instance.collection(kUsers);
    var usersCollection = await users.get();
    var usersMap = usersCollection.docs[0].data() as Map<String, dynamic>;

    List<String> l = [];
    for (var doc in usersMap.keys) {
      l.add(doc);
    }
    l.sort();
    l.remove("Abona Bvnoty");

    searchResultsList = usersList = l;

    dailyRecordsCollection = await dailyRecords.orderBy("name").get();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUsers().timeout(const Duration(seconds: 10), onTimeout: () {
      showSnackBar(context, "Check your internet connection!");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (usersList.isNotEmpty) {
      return Expanded(
        child: Column(
          children: [
            Container(
              width: 300.w,
              padding: EdgeInsets.symmetric(horizontal: 64.0.w),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: TextField(
                  onChanged: (name) {
                    searchResultsList = [];
                    searchAbout(name);
                    setState(() {});
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(),
                      border: InputBorder.none),
                ),
              ),
            ),
            SizedBox(
              height: 10.0.h,
            ),
            if (searchResultsList.isNotEmpty)
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          Map<String, dynamic> userDailyRecordsMap = {};

                          for (var doc in dailyRecordsCollection.docs) {
                            if (doc["name"] == searchResultsList[index]) {
                              userDailyRecordsMap =
                                  doc.data() as Map<String, dynamic>;
                              userDailyRecordsMap.remove("name");
                              userDailyRecordsMap.remove("lastAccessedDate");
                            }
                          }
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return UserDailyRecordsScreen(
                              userInfoMap: userDailyRecordsMap,
                              name: searchResultsList[index],
                            );
                          }));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.0.w),
                          child: Padding(
                            padding: EdgeInsets.all(8.0.w),
                            child: SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  searchResultsList[index],
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 20.0.h,
                      );
                    },
                    itemCount: searchResultsList.length),
              )
            else ...[
              const Spacer(
                flex: 1,
              ),
              Text(
                "Not found",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp),
              ),
              const Spacer(
                flex: 1,
              ),
            ],
            SizedBox(
              height: 20.0.h,
            ),
          ],
        ),
      );
    } else {
      return const Expanded(
        child: Column(
          children: [
            Spacer(flex: 1),
            CircularProgressIndicator(),
            Spacer(flex: 2),
          ],
        ),
      );
    }
  }

  void searchAbout(String name) {
    for (var user in usersList) {
      bool found = true;
      int lastIndex = -1;
      for (var letter in name.characters) {
        lastIndex =
            user.toLowerCase().indexOf(letter.toLowerCase(), lastIndex + 1);
        if (lastIndex == -1) {
          found = false;
          break;
        }
      }
      if (found) {
        searchResultsList.add(user);
      }
    }
  }

  Future<void> recordAttendance(List<ActivityModel> usersList) async {
    CollectionReference attendance =
        FirebaseFirestore.instance.collection("Attendance");
    for (var element in usersList) {
      if (element.value) {
        await attendance.add({"name": element.name});
      }
    }
  }
}
