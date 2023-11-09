import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'status18_ccor_node_event.dart';
part 'status18_ccor_node_state.dart';

class Status18CCorNodeBloc
    extends Bloc<Status18CCorNodeEvent, Status18CCorNodeState> {
  Status18CCorNodeBloc({required UnitRepository unitRepository})
      : _unitRepository = unitRepository,
        super(Status18CCorNodeState(
          temperatureUnit: unitRepository.temperatureUnit,
        )) {
    on<TemperatureUnitChanged>(_onTemperatureUnitChanged);
  }

  final UnitRepository _unitRepository;

  void _onTemperatureUnitChanged(
    TemperatureUnitChanged event,
    Emitter<Status18CCorNodeState> emit,
  ) {
    _unitRepository.temperatureUnit = event.temperatureUnit;
    emit(state.copyWith(
      temperatureUnit: event.temperatureUnit,
    ));
  }
}
