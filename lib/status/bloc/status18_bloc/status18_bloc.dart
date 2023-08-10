import 'package:dsim_app/core/temperature_unit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'status18_event.dart';
part 'status18_state.dart';

class Status18Bloc extends Bloc<Status18Event, Status18State> {
  Status18Bloc() : super(const Status18State()) {
    on<TemperatureUnitChanged>(_onTemperatureUnitChanged);
  }

  void _onTemperatureUnitChanged(
    TemperatureUnitChanged event,
    Emitter<Status18State> emit,
  ) {
    emit(state.copyWith(
      temperatureUnit: event.temperatureUnit,
    ));
  }
}
