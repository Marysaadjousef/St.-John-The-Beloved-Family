import 'package:flutter_bloc/flutter_bloc.dart';

import 'change_select_all_value_states.dart';

class ChangeSelectAllValueCubit extends Cubit<SelectAllState> {
  ChangeSelectAllValueCubit() : super(NotActiveSelectAllState());

  changeState() {
    if (state is ActiveSelectAllState) {
      emit(NotActiveSelectAllState());
    } else {
      emit(ActiveSelectAllState());
    }
  }
}
