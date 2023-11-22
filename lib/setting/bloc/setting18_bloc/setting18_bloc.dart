import 'package:aci_plus_app/core/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_event.dart';
part 'setting18_state.dart';

class Setting18Bloc extends Bloc<Setting18Event, Setting18State> {
  Setting18Bloc() : super(const Setting18State()) {
    on<GraphViewToggled>(_onGraphViewToggled);
    on<ListViewToggled>(_onListViewToggled);
  }

  void _onGraphViewToggled(
    GraphViewToggled event,
    Emitter<Setting18State> emit,
  ) {
    setFullScreenOrientation();

    // hide system status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    emit(state.copyWith(
      isGraphType: true,
    ));
  }

  void _onListViewToggled(
    ListViewToggled event,
    Emitter<Setting18State> emit,
  ) {
    setPreferredOrientation();

    // display system status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    emit(state.copyWith(
      isGraphType: false,
    ));
  }
}
