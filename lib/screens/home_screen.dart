import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habat_khardal/components/tasks_list_view.dart';
import 'package:habat_khardal/cubits/change_loading_cubit/change_loading_cubit.dart';
import 'package:habat_khardal/cubits/change_select_all_value_cubit/change_select_all_value_cubit.dart';
import 'package:habat_khardal/cubits/change_select_all_value_cubit/change_select_all_value_states.dart';
import 'package:habat_khardal/tasks.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/ok_alert.dart';
import '../constants.dart';
import '../components/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/tasks_images.dart';
import '../helper/activitiesModelsToMap.dart';
import '../helper/get_user_id.dart';
import '../helper/save_user_id.dart';
import '../helper/show_snackbar.dart';
import '../models/activity_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String id = "HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference dailyRecords =
      FirebaseFirestore.instance.collection(kDailyRecords);
  bool? newDay;
  late Map<String, dynamic> userRecordMap;
  int maxCount = 0;
  @override
  void initState() {
// TODO: implement initState
    super.initState();
    _isNewDay().timeout(const Duration(seconds: 10), onTimeout: () {
      showSnackBar(context, "Check your internet connection!");
    });
  }

  Future<void> loadActivitiesMap() async {
    activitiesModelsList = [
      ActivityModel(name: "Morning Prayer"),
      ActivityModel(name: "Evening Prayer"),
      ActivityModel(name: "Bedtime Prayer"),
      ActivityModel(name: "Bible Reading"),
      ActivityModel(name: "Attending Mass"),
      ActivityModel(name: "Eucharist"),
      ActivityModel(name: "Confession"),
    ];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? activitiesItem = prefs.getBool(activitiesModelsList[0].name);
    if (activitiesItem == null) {
      for (int i = 0; i < activitiesModelsList.length; i++) {
        prefs.setBool(activitiesModelsList[i].name, false);
      }
    } else {
      for (int i = 0; i < activitiesModelsList.length; i++) {
        activitiesModelsList[i].value =
            prefs.getBool(activitiesModelsList[i].name)!;
        if (activitiesModelsList[i].value) {
          maxCount++;
        }
      }
    }
    if (maxCount == activitiesModelsList.length &&
        context.read<ChangeSelectAllValueCubit>().state
            is NotActiveSelectAllState) {
      context.read<ChangeSelectAllValueCubit>().changeState();
    }
  }

  Future<void> _isNewDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the last accessed date
    kLastAccessedDate = prefs.getString('lastAccessedDate$kUserName');

    // Get the current date
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (kLastAccessedDate != currentDate) {
      String? userId = await getUserId();
      if (userId != null) {
        var userRecord = await dailyRecords.doc(userId).get();
        userRecordMap = userRecord.data() as Map<String, dynamic>;
        if (userRecordMap["lastAccessedDate"] != currentDate) {
          newDay = true;
        } else {
          newDay = false;
        }
      } else {
        newDay = true;
      }
    } else {
      newDay = false;
    }
    if (newDay!) {
      await loadActivitiesMap();
    }
    if (newDay != null) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (newDay != null && newDay!) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(
                  "Select All",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
                BlocBuilder<ChangeSelectAllValueCubit, SelectAllState>(
                  builder: (context, state) {
                    return Checkbox(
                      value: state is ActiveSelectAllState,
                      onChanged: (bool? value) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          if (value! &&
                              context.read<ChangeSelectAllValueCubit>().state
                                  is NotActiveSelectAllState) {
                            context
                                .read<ChangeSelectAllValueCubit>()
                                .changeState();
                          } else if (!value! &&
                              context.read<ChangeSelectAllValueCubit>().state
                                  is ActiveSelectAllState) {
                            context
                                .read<ChangeSelectAllValueCubit>()
                                .changeState();
                          }
                          for (var element in activitiesModelsList) {
                            element.value = value!;
                            prefs.setBool(element.name, value!);
                          }
                        });
                      },
                      checkColor: Colors.white,
                      activeColor: const Color.fromRGBO(0, 0, 0, 0),
                      focusColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                    );
                  },
                ),
              ]),
            ),
            Expanded(
                child: TasksListView(
              activitiesModels: activitiesModelsList,
              images: images,
              maxCount: maxCount,
            )),
            CustomButton(
              buttonText: "Save",
              onTab: () async {
                try {
                  await saveRecord().timeout(const Duration(seconds: 5),
                      onTimeout: () {
                    return;
                  });
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DoneAlert(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                  context.read<ChangeLoadingCubit>().changeLoadingState();
                  setState(() {
                    newDay = false;
                  });
                } catch (e) {
                  log(e.toString());
                }
              },
            ),
          ],
        ),
      );
    } else if (newDay != null && !newDay!) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 1,
            ),
            Text(
              "You have already recorded today\n Please come back tomorrow",
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

  saveRecord() async {
    context.read<ChangeLoadingCubit>().changeLoadingState();
    Map<String, bool> activitiesMap =
        activitiesModelsToMap(activitiesModelsList);
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String? userId = await getUserId();
    await saveLastAccessedDate(currentDate);
    kLastAccessedDate = currentDate;

    if (userId == null) {
      var i = await dailyRecords.add({
        "name": kUserName,
        "lastAccessedDate": currentDate,
        for (var key in activitiesMap.keys) ...{
          key: {
            "count": activitiesMap[key]! ? 1 : 0,
            "lastTime": activitiesMap[key]! ? currentDate : "No Record"
          },
        },
      });
      await saveUserId(i.id);
    } else {
      Map<String, dynamic> newData = {
        "lastAccessedDate": currentDate,
      };
      for (var key in activitiesMap.keys) {
        if (activitiesMap[key]!) {
          newData[key] = {
            "count": userRecordMap[key]["count"] + 1,
            "lastTime": currentDate,
          };
        }
      }
      await dailyRecords.doc(userId).set(newData, SetOptions(merge: true));
    }
    for (int i = 0; i < activitiesModelsList.length; i++) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(activitiesModelsList[i].name, false);
    }
  }

  Future<void> saveLastAccessedDate(String currentDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastAccessedDate$kUserName', currentDate);
  }
}
