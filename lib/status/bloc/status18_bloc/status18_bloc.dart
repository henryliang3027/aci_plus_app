import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'status18_event.dart';
part 'status18_state.dart';

class Status18Bloc extends Bloc<Status18Event, Status18State> {
  Status18Bloc({required UnitRepository unitRepository})
      : _unitRepository = unitRepository,
        super(Status18State(
          temperatureUnit: unitRepository.temperatureUnit,
        )) {
    on<TemperatureUnitChanged>(_onTemperatureUnitChanged);
  }

  final UnitRepository _unitRepository;

  void _onTemperatureUnitChanged(
    TemperatureUnitChanged event,
    Emitter<Status18State> emit,
  ) {
    _unitRepository.temperatureUnit = event.temperatureUnit;
    emit(state.copyWith(
      temperatureUnit: event.temperatureUnit,
    ));
  }
}
