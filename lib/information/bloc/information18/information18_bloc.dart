import 'dart:async';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/config.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'information18_event.dart';
part 'information18_state.dart';

class Information18Bloc extends Bloc<Information18Event, Information18State> {
  Information18Bloc({
    required Amp18Repository amp18Repository,
    required ConfigRepository configRepository,
  })  : _configRepository = configRepository,
        _amp18Repository = amp18Repository,
        super(const Information18State()) {
    on<ConfigLoaded>(_onConfigLoaded);
    on<AppVersionRequested>(_onAppVersionRequested);
    on<ALSCModeRequested>(_onALSCModeRequested);

    add(const AppVersionRequested());
  }

  final ConfigRepository _configRepository;
  final Amp18Repository _amp18Repository;

  Future<void> _onAppVersionRequested(
    AppVersionRequested event,
    Emitter<Information18State> emit,
  ) async {
    String appVersion = await getAppVersion();

    emit(state.copyWith(
      appVersion: appVersion,
    ));
  }

  String getGroupIdByPartId(String partId) {
    // TR 或 SDAT 為 trunk
    if (partId == '5' || partId == '15' || partId == '8' || partId == '18') {
      return '0'; // trunk
    } else if (partId == '10') {
      return '3'; // mdu
    } else {
      return '1'; // distribution
    }
  }

  Future<void> _onConfigLoaded(
    ConfigLoaded event,
    Emitter<Information18State> emit,
  ) async {
    String groupId = getGroupIdByPartId(event.partId);

    List<Config> configs = _configRepository.getConfigsByGroupId(groupId);

    emit(state.copyWith(
      configs: configs,
    ));
  }

  Future<void> _onALSCModeRequested(
    ALSCModeRequested event,
    Emitter<Information18State> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    List<String> settingResult = [];

    bool resultOfSetPilotFrequencyMode =
        await _amp18Repository.set1p8GPilotFrequencyMode('0');

    // 開啟 ALSC 模式
    // AGC ON 和 ALC ON
    bool resultOfSetForwardAGCMode =
        await _amp18Repository.set1p8GForwardAGCMode('1');
    bool resultOfSetALCMode = await _amp18Repository.set1p8GALCMode('1');

    settingResult.addAll([
      '${DataKey.pilotFrequencyMode.name},$resultOfSetPilotFrequencyMode',
      '${DataKey.agcMode.name},${resultOfSetForwardAGCMode && resultOfSetALCMode}',
    ]);

    // 等待 device 完成更新後在讀取值
    await Future.delayed(const Duration(milliseconds: 1000));

    await _amp18Repository.updateCharacteristics();

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
    ));
  }
}
