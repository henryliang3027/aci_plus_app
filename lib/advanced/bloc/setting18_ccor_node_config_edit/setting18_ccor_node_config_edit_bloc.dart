import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:aci_plus_app/repositories/node_config.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_ccor_node_config_edit_event.dart';
part 'setting18_ccor_node_config_edit_state.dart';

class Setting18CCorNodeConfigEditBloc extends Bloc<
    Setting18CcorNodeConfigEditEvent, Setting18CCorNodeConfigEditState> {
  Setting18CCorNodeConfigEditBloc({
    required Amp18CCorNodeRepository amp18CCorNodeRepository,
    required ConfigRepository configRepository,
    NodeConfig? nodeConfig,
  })  : _amp18CCorNodeRepository = amp18CCorNodeRepository,
        _configRepository = configRepository,
        _nodeConfig = nodeConfig,
        super(const Setting18CCorNodeConfigEditState()) {
    on<ConfigIntitialized>(_onConfigIntitialized);
    on<ConfigAdded>(_onConfigAdded);
    on<ConfigSubmitted>(_onConfigSubmitted);
    on<ConfigUpdated>(_onConfigUpdated);
    on<NameChanged>(_onNameChanged);
    on<ForwardModeChanged>(_onForwardModeChanged);
    on<ForwardConfigChanged>(_onForwardConfigChanged);
    on<SplitOptionChanged>(_onSplitOptionChanged);

    add(const ConfigIntitialized());
  }

  final Amp18CCorNodeRepository _amp18CCorNodeRepository;
  final ConfigRepository _configRepository;
  final NodeConfig? _nodeConfig;

  Future<void> _onConfigIntitialized(
    ConfigIntitialized event,
    Emitter<Setting18CCorNodeConfigEditState> emit,
  ) async {
    emit(state.copyWith(
      formStatus: FormStatus.requestInProgress,
      // encodeStaus: FormStatus.none,
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
    ));

    // int id = await _configRepository.getConfigAutoIncrementId();

    String groupId = '3';
    String rawName = '';
    String forwardMode = '120';
    String forwardConfig = '1';
    String splitOption = '1';

    if (_nodeConfig != null) {
      rawName = _nodeConfig.name;
      forwardMode = _nodeConfig.forwardMode;
      forwardConfig = _nodeConfig.forwardConfig;
      splitOption = _nodeConfig.splitOption;
    } else {
      int newId = _configRepository.getEmptyNameId(groupId: groupId) ?? -1;
      rawName = 'Config$newId';
    }

    NameInput name = NameInput.dirty(rawName);

    emit(state.copyWith(
      formStatus: FormStatus.requestSuccess,
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
      groupId: groupId,
      name: name,
      forwardMode: forwardMode,
      forwardConfig: forwardConfig,
      splitOption: splitOption,
      isInitialize: true,
      enableSubmission: _isEnabledSubmission(
        name: name,
        forwardMode: forwardMode,
        forwardConfig: forwardConfig,
        splitOption: splitOption,
      ),
    ));
  }

  void _onNameChanged(
    NameChanged event,
    Emitter<Setting18CCorNodeConfigEditState> emit,
  ) {
    NameInput name = NameInput.dirty(event.name);

    emit(state.copyWith(
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
      name: name,
      enableSubmission: _isEnabledSubmission(
        name: name,
        forwardMode: state.forwardMode,
        forwardConfig: state.forwardConfig,
        splitOption: state.splitOption,
      ),
    ));
  }

  void _onForwardModeChanged(
    ForwardModeChanged event,
    Emitter<Setting18CCorNodeConfigEditState> emit,
  ) {
    emit(state.copyWith(
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
      forwardMode: event.forwardMode,
      enableSubmission: _isEnabledSubmission(
        name: state.name,
        forwardMode: event.forwardMode,
        forwardConfig: state.forwardConfig,
        splitOption: state.splitOption,
      ),
    ));
  }

  void _onForwardConfigChanged(
    ForwardConfigChanged event,
    Emitter<Setting18CCorNodeConfigEditState> emit,
  ) {
    emit(state.copyWith(
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
      forwardConfig: event.forwardConfig,
      enableSubmission: _isEnabledSubmission(
        name: state.name,
        forwardMode: state.forwardMode,
        forwardConfig: event.forwardConfig,
        splitOption: state.splitOption,
      ),
    ));
  }

  void _onSplitOptionChanged(
    SplitOptionChanged event,
    Emitter<Setting18CCorNodeConfigEditState> emit,
  ) {
    emit(state.copyWith(
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
      splitOption: event.splitOption,
      enableSubmission: _isEnabledSubmission(
        name: state.name,
        forwardMode: state.forwardMode,
        forwardConfig: state.forwardConfig,
        splitOption: event.splitOption,
      ),
    ));
  }

  Future<void> _onConfigAdded(
    ConfigAdded event,
    Emitter<Setting18CCorNodeConfigEditState> emit,
  ) async {
    emit(state.copyWith(
      // encodeStaus: FormStatus.none,
      saveStatus: SubmissionStatus.submissionInProgress,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
    ));

    await _configRepository.putNodeConfig(
      groupId: state.groupId,
      name: state.name.value,
      forwardMode: state.forwardMode,
      forwardConfig: state.forwardConfig,
      splitOption: state.splitOption,
    );

    emit(state.copyWith(
      saveStatus: SubmissionStatus.submissionSuccess,
    ));
  }

  void _onConfigUpdated(
    ConfigUpdated event,
    Emitter<Setting18CCorNodeConfigEditState> emit,
  ) async {
    emit(state.copyWith(
      // encodeStaus: FormStatus.none,
      saveStatus: SubmissionStatus.submissionInProgress,
      settingStatus: SubmissionStatus.none,
      isInitialize: false,
    ));

    await _configRepository.updateNodeConfig(
      id: _nodeConfig!.id,
      name: state.name.value,
      forwardMode: state.forwardMode,
      forwardConfig: state.forwardConfig,
      splitOption: state.splitOption,
    );

    emit(state.copyWith(
      saveStatus: SubmissionStatus.submissionSuccess,
    ));
  }

  Future<void> _onConfigSubmitted(
    ConfigSubmitted event,
    Emitter<Setting18CCorNodeConfigEditState> emit,
  ) async {
    emit(state.copyWith(
      saveStatus: SubmissionStatus.none,
      settingStatus: SubmissionStatus.submissionInProgress,
      isInitialize: false,
    ));

    List<String> settingResult = [];

    if (state.forwardMode.isNotEmpty) {
      bool resultOfSetForwardMode = await _amp18CCorNodeRepository
          .set1p8GCCorNodeForwardMode(state.forwardMode);

      settingResult.add('${DataKey.forwardMode.name},$resultOfSetForwardMode');
    }

    if (state.forwardConfig.isNotEmpty) {
      bool resultOfSetForwardConfig = await _amp18CCorNodeRepository
          .set1p8GCCorNodeForwardConfig(state.forwardConfig);

      settingResult
          .add('${DataKey.forwardConfig.name},$resultOfSetForwardConfig');
    }

    if (state.splitOption.isNotEmpty) {
      bool resultOfSetSplitOption = await _amp18CCorNodeRepository
          .set1p8GCCorNodeSplitOption(state.splitOption);

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

  bool _isEnabledSubmission({
    required NameInput name,
    required String forwardMode,
    required String forwardConfig,
    required String splitOption,
  }) {
    if (name.value.isNotEmpty &&
        forwardMode.isNotEmpty &&
        forwardConfig.isNotEmpty &&
        splitOption != '0') {
      return true;
    } else {
      return false;
    }
  }
}
