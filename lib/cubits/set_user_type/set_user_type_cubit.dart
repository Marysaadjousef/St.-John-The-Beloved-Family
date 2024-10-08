import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habat_khardal/cubits/set_user_type/set_user_type_states.dart';

class SetUserTypeCubit extends Cubit<UserTypeState> {
  SetUserTypeCubit() : super(NormalUserState());

  setUserTypeState(String userType) {
    switch (userType) {
      case "Admin":
        emit(AdminUserState());
      case "QuestionDesigner":
        emit(QuestionDesignerUserState());
      case "AttendanceRecorder":
        emit(AttendanceRecorderUserState());
      default:
        emit(NormalUserState());
    }
  }
}
