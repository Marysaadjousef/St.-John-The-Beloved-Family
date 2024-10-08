import 'package:flutter_bloc/flutter_bloc.dart';

import 'change_loading_states.dart';

class ChangeLoadingCubit extends Cubit<LoadingState> {
  ChangeLoadingCubit() : super(NotActiveState());

  changeLoadingState() {
    if (state is ActiveState) {
      emit(NotActiveState());
    } else {
      emit(ActiveState());
    }
  }
}
