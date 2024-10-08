import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habat_khardal/cubits/change_select_all_value_cubit/change_select_all_value_cubit.dart';
import 'package:habat_khardal/cubits/change_select_all_value_cubit/change_select_all_value_states.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/activity_model.dart';
import '../tasks.dart';

class TasksListView extends StatefulWidget {
  TasksListView(
      {super.key,
      required this.activitiesModels,
      this.images,
      this.maxCount = 0});
  final List<ActivityModel> activitiesModels;
  final List<String>? images;
  int maxCount;
  @override
  State<TasksListView> createState() => _TasksListViewState();
}

class _TasksListViewState extends State<TasksListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0.h),
            child: Row(
              children: [
                if (widget.images?[index] != null) ...[
                  Image.asset(
                    "assets/images/${widget.images?[index]}",
                    height: 30.r,
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                ],
                Expanded(
                  flex: 2,
                  child: Text(
                    widget.activitiesModels[index].name,
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
                BlocBuilder<ChangeSelectAllValueCubit, SelectAllState>(
                    builder: (context, state) {
                  if (state is ActiveSelectAllState) {
                    widget.maxCount = widget.activitiesModels.length;
                  }
                  return Checkbox(
                    value: state is ActiveSelectAllState ||
                        widget.activitiesModels[index].value,
                    onChanged: (bool? value) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      if (widget.activitiesModels[index].name == "Eucharist" &&
                          value!) {
                        // Check both Eucharist and Attending Mass
                        ActivityModel activityModel =
                            activitiesModelsList.firstWhere(
                                (element) => element.name == "Attending Mass");

                        if (activityModel.value) {
                          widget.maxCount += 1;
                        } else {
                          activityModel.value = true;
                          widget.maxCount += 2;
                        }
                        prefs.setBool("Attending Mass", true);

                        widget.activitiesModels[index].value = value;
                      } else if (widget.activitiesModels[index].name ==
                              "Attending Mass" &&
                          !value!) {
                        // Check both Eucharist and Attending Mass
                        ActivityModel activityModel =
                            activitiesModelsList.firstWhere(
                                (element) => element.name == "Eucharist");

                        if (!activityModel.value) {
                          widget.maxCount -= 1;
                        } else {
                          activityModel.value = false;
                          widget.maxCount -= 2;
                        }

                        prefs.setBool("Eucharist", false);

                        widget.activitiesModels[index].value = value;
                      } else {
                        widget.activitiesModels[index].value = value!;
                        widget.maxCount += (value ? 1 : -1);
                      }
                      if (widget.images != null) {
                        prefs.setBool(
                            widget.activitiesModels[index].name, value);
                      }
                      if (widget.maxCount == widget.activitiesModels.length &&
                          context.read<ChangeSelectAllValueCubit>().state
                              is NotActiveSelectAllState) {
                        context.read<ChangeSelectAllValueCubit>().changeState();
                      } else if (widget.maxCount !=
                              widget.activitiesModels.length &&
                          context.read<ChangeSelectAllValueCubit>().state
                              is ActiveSelectAllState) {
                        context.read<ChangeSelectAllValueCubit>().changeState();
                      }
                      setState(() {});
                    },
                    checkColor: Colors.white,
                    activeColor: const Color.fromRGBO(0, 0, 0, 0),
                    focusColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  );
                })
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 25.h,
        );
      },
      itemCount: widget.activitiesModels.length,
    );
  }
}
