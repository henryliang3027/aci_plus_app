import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/node_config.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'information18_ccor_node_preset_event.dart';
part 'information18_ccor_node_preset_state.dart';

class Information18CCorNodePresetBloc extends Bloc<
    Information18CCorNodePresetEvent, Information18CCorNodePresetState> {
  Information18CCorNodePresetBloc({
    required Amp18CCorNodeRepository amp18CCorNodeRepository,
    required NodeConfig nodeConfig,
  })  : _amp18CCorNodeRepository = amp18CCorNodeRepository,
        super(Information18CCorNodePresetState(nodeConfig: nodeConfig)) {
    on<ConfigExecuted>(_onConfigExecuted);
  }

  final Amp18CCorNodeRepository _amp18CCorNodeRepository;

  void _onConfigExecuted(
    ConfigExecuted event,
    Emitter<Information18CCorNodePresetState> emit,
  ) async {
    emit(state.copyWith(
      settingStatus: SubmissionStatus.submissionInProgress,
      isInitialize: false,
    ));

    List<String> settingResult = [];

    NodeConfig nodeConfig = state.nodeConfig;

    if (nodeConfig.forwardMode.isNotEmpty) {
      bool resultOfSetForwardMode = await _amp18CCorNodeRepository
          .set1p8GCCorNodeForwardMode(nodeConfig.forwardMode);

      settingResult.add('${DataKey.forwardMode.name},$resultOfSetForwardMode');
    }

    if (nodeConfig.forwardConfig.isNotEmpty) {
      bool resultOfSetForwardConfig = await _amp18CCorNodeRepository
          .set1p8GCCorNodeForwardConfig(nodeConfig.forwardConfig);

      settingResult
          .add('${DataKey.forwardConfig.name},$resultOfSetForwardConfig');
    }

    if (nodeConfig.splitOption.isNotEmpty) {
      bool resultOfSetSplitOption = await _amp18CCorNodeRepository
          .set1p8GCCorNodeSplitOption(nodeConfig.splitOption);

      settingResult.add('${DataKey.splitOption.name},$resultOfSetSplitOption');
    }

    // 等待 device 完成更新後在讀取值
    await Future.delayed(const Duration(milliseconds: 1000));

    await _amp18CCorNodeRepository.update1p8GCCorNodeCharacteristics();

    emit(state.copyWith(
      settingStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
    ));
  }
}
