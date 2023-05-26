import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/setting/model/location.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(const SettingState()) {
    on<LocationChanged>(_onLocationChanged);
    on<LocationSubmitted>(_onLocationSubmitted);
  }

  void _onLocationChanged(
    LocationChanged event,
    Emitter<SettingState> emit,
  ) {
    final Location location = Location.dirty(event.location);

    emit(state.copyWith(
      location: location,
    ));
  }

  void _onLocationSubmitted(
    LocationSubmitted event,
    Emitter<SettingState> emit,
  ) {}
}
