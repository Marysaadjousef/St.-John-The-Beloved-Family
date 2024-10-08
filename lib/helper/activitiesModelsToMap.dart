import '../models/activity_model.dart';

Map<String, bool> activitiesModelsToMap(List<ActivityModel> activitiesModels) {
  Map<String, bool> activitiesMap = {};
  for (ActivityModel activityModel in activitiesModels) {
    activitiesMap.addAll({activityModel.name: activityModel.value});
  }
  return activitiesMap;
}
