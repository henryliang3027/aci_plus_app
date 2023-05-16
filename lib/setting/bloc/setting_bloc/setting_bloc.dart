import 'package:bloc/bloc.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:equatable/equatable.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(const SettingState()) {
    on<SettingEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
