import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'status_event.dart';
part 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  StatusBloc() : super(const StatusState()) {
    on<TemperatureUnitChanged>(_onTemperatureUnitChanged);
  }

  void _onTemperatureUnitChanged(
    TemperatureUnitChanged event,
    Emitter<StatusState> emit,
  ) {
    emit(state.copyWith(
      temperatureUnit: event.temperatureUnit,
    ));
  }
}
