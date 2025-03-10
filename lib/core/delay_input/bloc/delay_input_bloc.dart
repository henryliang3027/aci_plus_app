import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'delay_input_event.dart';
part 'delay_input_state.dart';

class DelayInputBloc extends Bloc<DelayInputEvent, DelayInputState> {
  DelayInputBloc({
    required Amp18Repository amp18Repository,
  })  : _amp18Repository = amp18Repository,
        super(const DelayInputState()) {
    on<DelayRequested>(_onDelayRequested);
    on<DelayChanged>(_onDelayChanged);
    on<DelayConfirmed>(_onDelayConfirmed);

    add(const DelayRequested());
  }

  final Amp18Repository _amp18Repository;

  Future<void> _onDelayRequested(
    DelayRequested event,
    Emitter<DelayInputState> emit,
  ) async {
    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    String delay = characteristicDataCache[DataKey.bluetoothDelayTime] ?? '';

    emit(state.copyWith(
      isInitialize: true,
      delay: delay,
    ));
  }

  void _onDelayChanged(
    DelayChanged event,
    Emitter<DelayInputState> emit,
  ) {
    emit(state.copyWith(
      isInitialize: false,
      delay: event.delay,
    ));
  }

  Future<void> _onDelayConfirmed(
    DelayConfirmed event,
    Emitter<DelayInputState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
      isInitialize: false,
    ));
    await _amp18Repository.set1p8GTransmitDelayTime(ms: int.parse(state.delay));

    await _amp18Repository.updateCharacteristics();

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionSuccess,
    ));
  }
}
