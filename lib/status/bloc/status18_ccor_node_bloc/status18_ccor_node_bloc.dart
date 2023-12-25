import 'dart:async';

import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'status18_ccor_node_event.dart';
part 'status18_ccor_node_state.dart';

class Status18CCorNodeBloc
    extends Bloc<Status18CCorNodeEvent, Status18CCorNodeState> {
  Status18CCorNodeBloc({
    required UnitRepository unitRepository,
    required Amp18CCorNodeRepository amp18CCorNodeRepository,
  })  : _unitRepository = unitRepository,
        _amp18CCorNodeRepository = amp18CCorNodeRepository,
        super(Status18CCorNodeState(
          temperatureUnit: unitRepository.temperatureUnit,
        )) {
    on<TemperatureUnitChanged>(_onTemperatureUnitChanged);
    on<StatusUpdated>(_onStatusUpdated);
    on<StatusPeriodicUpdateRequested>(_onStatusPeriodicUpdateRequested);
    on<StatusPeriodicUpdateCanceled>(_onStatusPeriodicUpdateCanceled);
  }

  Timer? _timer;
  final UnitRepository _unitRepository;
  final Amp18CCorNodeRepository _amp18CCorNodeRepository;

  void _onTemperatureUnitChanged(
    TemperatureUnitChanged event,
    Emitter<Status18CCorNodeState> emit,
  ) {
    _unitRepository.temperatureUnit = event.temperatureUnit;
    emit(state.copyWith(
      temperatureUnit: event.temperatureUnit,
    ));
  }

  void _onStatusPeriodicUpdateRequested(
    StatusPeriodicUpdateRequested event,
    Emitter<Status18CCorNodeState> emit,
  ) {
    if (_timer != null) {
      _timer!.cancel();
    }

    // timer 啟動後 5 秒才會發 StatusUpdated, 所以第0秒時先 StatusUpdated
    add(const StatusUpdated());

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      print('alarm trigger timer: ${timer.tick}');
      add(const StatusUpdated());
    });

    print('alarm trigger started');
  }

  Future<void> _onStatusUpdated(
    StatusUpdated event,
    Emitter<Status18CCorNodeState> emit,
  ) async {
    List<dynamic> result =
        await _amp18CCorNodeRepository.requestCommand1p8GCCorNodeA1();

    if (result[0]) {
      Map<DataKey, String> currentValues = result[1];
      _amp18CCorNodeRepository.updateDataWithGivenValuePairs(currentValues);
    } else {
      print('Status updated failed');
    }
  }

  Future<void> _onStatusPeriodicUpdateCanceled(
    StatusPeriodicUpdateCanceled event,
    Emitter<Status18CCorNodeState> emit,
  ) async {
    if (_timer != null) {
      _timer!.cancel();
      print('alarm trigger timer is canceled');
    }
  }

  @override
  Future<void> close() {
    if (_timer != null) {
      _timer!.cancel();

      print('alarm trigger timer is canceled due to bloc closing.');
    }

    return super.close();
  }
}
