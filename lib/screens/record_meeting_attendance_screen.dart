import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habat_khardal/cubits/change_select_all_value_cubit/change_select_all_value_cubit.dart';
import 'package:habat_khardal/cubits/change_select_all_value_cubit/change_select_all_value_states.dart';
import 'package:intl/intl.dart';
import '../components/custom_button.dart';
import '../components/ok_alert.dart';
import '../components/tasks_list_view.dart';
import '../constants.dart';
import '../cubits/change_loading_cubit/change_loading_cubit.dart';
import '../helper/show_snackbar.dart';
import '../models/activity_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecordMeetingAttendanceScreen extends StatefulWidget {
  const RecordMeetingAttendanceScreen({super.key});
  static const String id = "RecordMeetingAttendanceScreen";

  @override
  State<RecordMeetingAttendanceScreen> createState() =>
      _RecordMeetingAttendanceScreenState();
}

class _RecordMeetingAttendanceScreenState
    extends State<RecordMeetingAttendanceScreen> {
  List<ActivityModel> searchResultsList = [], usersList = [];
  int selectedItemsNum = 0;
  bool selectAll = false;

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

    for (var doc in l) {
      usersList.add(ActivityModel(name: doc));
    }
    searchResultsList = usersList;
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
      return BlocProvider<ChangeSelectAllValueCubit>(
        create: (BuildContext context) {
          return ChangeSelectAllValueCubit();
        },
        child: Expanded(
          child: Column(
            children: [
              Container(
                width: 300.w,
                padding: EdgeInsets.symmetric(horizontal: 64.0.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: TextField(
                    onChanged: (name) {
                      searchResultsList = [];
                      for (var user in usersList) {
                        bool found = true;
                        int lastIndex = -1;
                        for (var letter in name.characters) {
                          lastIndex = user.name
                              .toLowerCase()
                              .indexOf(letter.toLowerCase(), lastIndex + 1);
                          if (lastIndex == -1) {
                            found = false;
                            break;
                          }
                        }
                        if (found) {
                          searchResultsList.add(user);
                        }
                      }

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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0.w),
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
                      selectAll = context
                          .read<ChangeSelectAllValueCubit>()
                          .state is ActiveSelectAllState;

                      return Checkbox(
                        value: state is ActiveSelectAllState,
                        onChanged: (bool? value) {
                          setState(() {
                            selectAll = value!;
                            if (selectAll &&
                                context.read<ChangeSelectAllValueCubit>().state
                                    is NotActiveSelectAllState) {
                              context
                                  .read<ChangeSelectAllValueCubit>()
                                  .changeState();
                            } else if (!selectAll &&
                                context.read<ChangeSelectAllValueCubit>().state
                                    is ActiveSelectAllState) {
                              context
                                  .read<ChangeSelectAllValueCubit>()
                                  .changeState();
                            }
                            for (var element in searchResultsList) {
                              element.value = selectAll;
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
              if (searchResultsList.isNotEmpty)
                Expanded(
                    child: TasksListView(
                  activitiesModels: searchResultsList,
                ))
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
              CustomButton(
                buttonText: "Save",
                onTab: () async {
                  try {
                    context.read<ChangeLoadingCubit>().changeLoadingState();
                    await recordAttendance(usersList);
                    context.read<ChangeLoadingCubit>().changeLoadingState();
                    setState(() {
                      for (var user in usersList) {
                        user.value = false;
                      }
                      selectAll = false;
                      searchResultsList = usersList;
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
                  } catch (e) {
                    log(e.toString());
                  }
                },
              ),
            ],
          ),
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

  Future<void> recordAttendance(List<ActivityModel> usersList) async {
    CollectionReference attendance =
        FirebaseFirestore.instance.collection("Attendance");
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    Map<String, dynamic> attendanceHistory = {};
    var attendanceHistoryCollection = await attendance.get();
    attendanceHistory = attendanceHistoryCollection.docs.isNotEmpty
        ? attendanceHistoryCollection.docs[0].data() as Map<String, dynamic>
        : {};

    for (var element in usersList) {
      if (element.value) {
        if (attendanceHistory[element.name] != null) {
          if (attendanceHistory[element.name]["lastTime"] != currentDate) {
            attendanceHistory[element.name] = {
              "count": attendanceHistory[element.name]["count"] + 1,
              "lastTime": currentDate,
            };
          }
        } else {
          attendanceHistory[element.name] = {
            "count": 1,
            "lastTime": currentDate,
          };
        }
      }
    }
    attendanceHistoryCollection.docs.isNotEmpty
        ? await attendance
            .doc(attendanceHistoryCollection.docs[0].id)
            .set(attendanceHistory, SetOptions(merge: true))
        : await attendance.add(attendanceHistory);
  }
}
