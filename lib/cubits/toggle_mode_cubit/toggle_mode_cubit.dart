import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habat_khardal/cubits/toggle_mode_cubit/toggle_mode_states.dart';

import '../../constants.dart';
import '../../constants/colors.dart';

class ToggleModeCubit extends Cubit<ModeState> {
  ToggleModeCubit() : super(LightModeState());

  toggleMode() {
    if (state is LightModeState) {
      kBackgroundColor = kDarkModeBackgroundColor;
      mode = "Dark";
      emit(DarkModeState());
    } else {
      kBackgroundColor = kLightModeBackgroundColor;
      mode = "Light";
      emit(LightModeState());
    }
  }

  setMode(String mode) {
    if (mode == "Light") {
      kBackgroundColor = kLightModeBackgroundColor;
      mode = "Light";
      emit(LightModeState());
    } else {
      kBackgroundColor = kDarkModeBackgroundColor;
      mode = "Dark";
      emit(DarkModeState());
    }
  }
}
