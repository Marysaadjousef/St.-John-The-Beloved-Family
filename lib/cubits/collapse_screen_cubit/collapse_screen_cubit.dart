import 'package:flutter_bloc/flutter_bloc.dart';

import 'collapse_screen_states.dart';

class CollapseScreenCubit extends Cubit<ScreenState> {
  CollapseScreenCubit() : super(CollapsedState());

  changeScreenState() {
    if (state is CollapsedState) {
      emit(NotCollapsedState());
    } else {
      emit(CollapsedState());
    }
  }
}
