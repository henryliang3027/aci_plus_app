import 'dart:async';

import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'status18_event.dart';
part 'status18_state.dart';

class Status18Bloc extends Bloc<Status18Event, Status18State> {
  Status18Bloc({
    required UnitRepository unitRepository,
    required Amp18Repository amp18Repository,
  })  : _unitRepository = unitRepository,
        _amp18Repository = amp18Repository,
        super(Status18State(
          temperatureUnit: unitRepository.temperatureUnit,
        )) {
    on<TemperatureUnitChanged>(_onTemperatureUnitChanged);
    on<StatusUpdated>(_onStatusUpdated);
    on<StatusPeriodicUpdateRequested>(_onStatusPeriodicUpdateRequested);
    on<StatusPeriodicUpdateCanceled>(_onStatusPeriodicUpdateCanceled);
  }

  Timer? _timer;
  final UnitRepository _unitRepository;
  final Amp18Repository _amp18Repository;

  void _onTemperatureUnitChanged(
    TemperatureUnitChanged event,
    Emitter<Status18State> emit,
  ) {
    _unitRepository.temperatureUnit = event.temperatureUnit;
    emit(state.copyWith(
      temperatureUnit: event.temperatureUnit,
    ));
  }

  void _onStatusPeriodicUpdateRequested(
    StatusPeriodicUpdateRequested event,
    Emitter<Status18State> emit,
  ) {
    if (_timer != null) {
      _timer!.cancel();
    }

    // timer 啟動後 5 秒才會發 StatusUpdated, 所以第0秒時先 StatusUpdated
    add(const StatusUpdated());

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      print('Status timer: ${timer.tick}');
      add(const StatusUpdated());
    });

    print('Status started');
  }

  Future<void> _onStatusUpdated(
    StatusUpdated event,
    Emitter<Status18State> emit,
  ) async {
    List<dynamic> result = await _amp18Repository.requestCommand1p8G2();

    if (result[0]) {
      Map<DataKey, String> currentValues = result[1];
      _amp18Repository.updateDataWithGivenValuePairs(currentValues);
    } else {
      print('Status updated failed');
    }
  }

  Future<void> _onStatusPeriodicUpdateCanceled(
    StatusPeriodicUpdateCanceled event,
    Emitter<Status18State> emit,
  ) async {
    if (_timer != null) {
      _timer!.cancel();
      print('Status timer is canceled');
    }
  }

  @override
  Future<void> close() {
    if (_timer != null) {
      _timer!.cancel();

      print('Status timer is canceled due to bloc closing.');
    }

    return super.close();
  }
}
