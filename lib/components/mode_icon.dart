import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../constants/colors.dart';
import '../cubits/toggle_mode_cubit/toggle_mode_cubit.dart';
import '../cubits/toggle_mode_cubit/toggle_mode_states.dart';

class ModeIcon extends StatelessWidget {
  const ModeIcon({
    super.key,
    required this.state,
  });
  final ModeState state;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          context.read<ToggleModeCubit>().toggleMode();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("mode", mode);
        },
        icon: state is LightModeState
            ? Icon(
                Icons.dark_mode_rounded,
                color: overColor,
              )
            : Icon(
                Icons.light_mode_rounded,
                color: overColor,
              ));
  }
}
