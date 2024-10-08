import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habat_khardal/cubits/show_password_cubit/show_password_states.dart';

class ShowPasswordCubit extends Cubit<PasswordState> {
  ShowPasswordCubit() : super(HiddenPasswordState());

  togglePasswordState() {
    if (state is HiddenPasswordState) {
      emit(VisiblePasswordState());
    } else {
      emit(HiddenPasswordState());
    }
  }
}
