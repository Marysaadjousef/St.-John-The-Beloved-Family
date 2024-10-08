import 'package:flutter/material.dart';
import 'package:habat_khardal/components/statistics_list_view_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habat_khardal/tasks.dart';
import '../constants/tasks_images.dart';

class StatisticsListView extends StatelessWidget {
  const StatisticsListView({
    super.key,
    required this.statisticsMap,
  });
  final Map<String, dynamic> statisticsMap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return StatisticsListViewItem(
          image: images[index],
          name: activitiesModelsList[index].name,
          count: statisticsMap[activitiesModelsList[index].name]["count"],
          lastTime: statisticsMap[activitiesModelsList[index].name]["lastTime"],
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 30.0.h,
        );
      },
      itemCount: statisticsMap.length,
    );
  }
}
