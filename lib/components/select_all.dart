import 'package:flutter/material.dart';
import 'package:habat_khardal/models/activity_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectAll extends StatefulWidget {
  const SelectAll({super.key, required this.checkboxList});
  final List<ActivityModel> checkboxList;
  @override
  State<SelectAll> createState() => _SelectAllState();
}

class _SelectAllState extends State<SelectAll> {
  bool selectAll = false;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(
        "Select All",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
        ),
      ),
      Checkbox(
        value: selectAll,
        onChanged: (bool? value) {
          for (var element in widget.checkboxList) {
            element.value = selectAll;
          }
          setState(() {
            selectAll = value!;
          });
        },
        checkColor: Colors.white,
        activeColor: const Color.fromRGBO(0, 0, 0, 0),
        focusColor: Colors.white,
        side: const BorderSide(color: Colors.white),
      ),
    ]);
  }
}
