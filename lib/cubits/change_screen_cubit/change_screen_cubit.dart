import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habat_khardal/cubits/change_screen_cubit/change_screen_states.dart';
import 'package:habat_khardal/screens/ranking_screen.dart';
import 'package:habat_khardal/screens/record_meeting_attendance_screen.dart';
import 'package:habat_khardal/screens/statistics_screen.dart';

import '../../screens/admin_tracking_screen.dart';

class ChangeScreenCubit extends Cubit<ScreenShownState> {
  ChangeScreenCubit() : super(HomeScreenState());

  changeScreen(String screen) {
    if (screen == StatisticsScreen.id) {
      emit(StatisticsScreenState());
    } else if (screen == RecordMeetingAttendanceScreen.id) {
      emit(AttendanceScreenState());
    } else if (screen == RankingScreen.id) {
      emit(RankingScreenState());
    } else if (screen == AdminTrackingScreen.id) {
      emit(AdminTrackingScreenState());
    } else {
      emit(HomeScreenState());
    }
  }
}
