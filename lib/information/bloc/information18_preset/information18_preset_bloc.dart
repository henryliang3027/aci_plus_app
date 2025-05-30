import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'information18_preset_event.dart';
part 'information18_preset_state.dart';

class Information18PresetBloc
    extends Bloc<Information18PresetEvent, Information18PresetState> {
  Information18PresetBloc({
    required Amp18Repository amp18Repository,
    required Config config,
  })  : _amp18Repository = amp18Repository,
        super(Information18PresetState(config: config)) {
    // on<DefaultConfigRequested>(_onDefaultConfigRequested);
    on<ConfigExecuted>(_onConfigExecuted);

    // add(const DefaultConfigRequested());
  }

  final Amp18Repository _amp18Repository;

  // void _onDefaultConfigRequested(
  //   DefaultConfigRequested event,
  //   Emitter<Information18PresetState> emit,
  // ) {
  //   emit(state.copyWith(
  //     isInitialize: true,
  //     config: _config,
  //   ));
  // }

  void _onConfigExecuted(
    ConfigExecuted event,
    Emitter<Information18PresetState> emit,
  ) async {
    emit(state.copyWith(
      settingStatus: SubmissionStatus.submissionInProgress,
      isInitialize: false,
    ));

    List<String> settingResult = [];

    Config config = state.config;

    // bool resultOfSetSplitOption =
    //     await _amp18Repository.set1p8GSplitOption(config.splitOption);

    // settingResult.add('${DataKey.splitOption.name},$resultOfSetSplitOption');

    bool resultOfSetPilotFrequencyMode = await _amp18Repository
        .set1p8GPilotFrequencyMode('0'); // Full mode (auto mode)

    settingResult.add(
        '${DataKey.pilotFrequencyMode.name},$resultOfSetPilotFrequencyMode');

    if (config.firstChannelLoadingFrequency.isNotEmpty) {
      bool resultOfSetFirstChannelLoadingFrequency =
          await _amp18Repository.set1p8GFirstChannelLoadingFrequency(
              config.firstChannelLoadingFrequency);

      settingResult.add(
          '${DataKey.firstChannelLoadingFrequency.name},$resultOfSetFirstChannelLoadingFrequency');
    }

    if (config.firstChannelLoadingLevel.isNotEmpty) {
      bool resultOfSetFirstChannelLoadingLevel = await _amp18Repository
          .set1p8GFirstChannelLoadingLevel(config.firstChannelLoadingLevel);

      settingResult.add(
          '${DataKey.firstChannelLoadingLevel.name},$resultOfSetFirstChannelLoadingLevel');
    }

    if (config.lastChannelLoadingFrequency.isNotEmpty) {
      bool resultOfSetLastChannelLoadingFrequency =
          await _amp18Repository.set1p8GLastChannelLoadingFrequency(
              config.lastChannelLoadingFrequency);

      settingResult.add(
          '${DataKey.lastChannelLoadingFrequency.name},$resultOfSetLastChannelLoadingFrequency');
    }

    if (config.lastChannelLoadingLevel.isNotEmpty) {
      bool resultOfSetLastChannelLoadingLevel = await _amp18Repository
          .set1p8GLastChannelLoadingLevel(config.lastChannelLoadingLevel);

      settingResult.add(
          '${DataKey.lastChannelLoadingLevel.name},$resultOfSetLastChannelLoadingLevel');
    }

    bool resultOfSetForwardAGCMode =
        await _amp18Repository.set1p8GForwardAGCMode('1');
    settingResult.add('${DataKey.agcMode.name},$resultOfSetForwardAGCMode');

    // 20240516 不顯示設定的結果, 之後不具備 ALC 功能
    // bool resultOfSetALCMode = await _amp18Repository.set1p8GALCMode('1');
    // settingResult.add('${DataKey.alcMode.name},$resultOfSetALCMode');

    // 等待 device 完成更新後在讀取值
    await Future.delayed(const Duration(milliseconds: 1000));

    await _amp18Repository.updateCharacteristics();

    emit(state.copyWith(
      settingStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
    ));
  }
}
