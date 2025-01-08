import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_ccor_node_regulation_event.dart';
part 'setting18_ccor_node_regulation_state.dart';

class Setting18CCorNodeRegulationBloc extends Bloc<
    Setting18CCorNodeRegulationEvent, Setting18CCorNodeRegulationState> {
  Setting18CCorNodeRegulationBloc({
    required Amp18CCorNodeRepository amp18CCorNodeRepository,
  })  : _amp18CCorNodeRepository = amp18CCorNodeRepository,
        super(const Setting18CCorNodeRegulationState()) {
    on<Initialized>(_onInitialized);
    on<ForwardModeChanged>(_onForwardModeChanged);
    on<ForwardConfigChanged>(_onForwardConfigChanged);
    on<SplitOptionChanged>(_onSplitOptionChanged);
    on<LogIntervalChanged>(_onLogIntervalChanged);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);

    add(const Initialized());
  }

  final Amp18CCorNodeRepository _amp18CCorNodeRepository;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18CCorNodeRegulationState> emit,
  ) async {
    Map<DataKey, String> characteristicDataCache =
        _amp18CCorNodeRepository.characteristicDataCache;

    String forwardMode = characteristicDataCache[DataKey.forwardMode] ?? '';
    String forwardConfig = characteristicDataCache[DataKey.forwardConfig] ?? '';
    String splitOption = characteristicDataCache[DataKey.splitOption] ?? '';
    String logInterval = characteristicDataCache[DataKey.logInterval] ?? '';

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      forwardMode: forwardMode,
      forwardConfig: forwardConfig,
      splitOption: splitOption,
      logInterval: logInterval,
      isInitialize: true,
      initialValues: characteristicDataCache,
      editMode: false,
      enableSubmission: false,
      settingResult: const [],
      tappedSet: const {},
    ));
  }

  void _onForwardModeChanged(
    ForwardModeChanged event,
    Emitter<Setting18CCorNodeRegulationState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.forwardMode);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      forwardMode: event.forwardMode,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        forwardMode: event.forwardMode,
      ),
    ));
  }

  void _onForwardConfigChanged(
    ForwardConfigChanged event,
    Emitter<Setting18CCorNodeRegulationState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.forwardConfig);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      forwardConfig: event.forwardConfig,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        forwardConfig: event.forwardConfig,
      ),
    ));
  }

  void _onSplitOptionChanged(
    SplitOptionChanged event,
    Emitter<Setting18CCorNodeRegulationState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.splitOption);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      splitOption: event.splitOption,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        splitOption: event.splitOption,
      ),
    ));
  }

  void _onLogIntervalChanged(
    LogIntervalChanged event,
    Emitter<Setting18CCorNodeRegulationState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.logInterval);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      logInterval: event.logInterval,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        logInterval: event.logInterval,
      ),
    ));
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18CCorNodeRegulationState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: false,
      editMode: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<Setting18CCorNodeRegulationState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: true,
      editMode: false,
      enableSubmission: false,
      tappedSet: const {},
      forwardMode: state.initialValues[DataKey.forwardMode],
      forwardConfig: state.initialValues[DataKey.forwardConfig],
      splitOption: state.initialValues[DataKey.splitOption],
      logInterval: state.initialValues[DataKey.logInterval],
    ));
  }

  bool _isEnabledSubmission({
    String? forwardMode,
    String? forwardConfig,
    String? splitOption,
    String? logInterval,
  }) {
    forwardMode ??= state.forwardMode;
    forwardConfig ??= state.forwardConfig;
    splitOption ??= state.splitOption;
    logInterval ??= state.logInterval;

    if (forwardMode != state.initialValues[DataKey.forwardMode] ||
        forwardConfig != state.initialValues[DataKey.forwardConfig] ||
        splitOption != state.initialValues[DataKey.splitOption] ||
        logInterval != state.initialValues[DataKey.logInterval]) {
      return true;
    } else {
      return false;
    }
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18CCorNodeRegulationState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
      isInitialize: false,
    ));

    List<String> settingResult = [];

    if (state.forwardMode != state.initialValues[DataKey.forwardMode]) {
      bool resultOfSetForwardMode = await _amp18CCorNodeRepository
          .set1p8GCCorNodeForwardMode(state.forwardMode);

      settingResult.add('${DataKey.forwardMode.name},$resultOfSetForwardMode');
    }

    if (state.forwardConfig != state.initialValues[DataKey.forwardConfig]) {
      bool resultOfSetForwardConfig = await _amp18CCorNodeRepository
          .set1p8GCCorNodeForwardConfig(state.forwardConfig);

      settingResult
          .add('${DataKey.forwardConfig.name},$resultOfSetForwardConfig');
    }

    if (state.splitOption != state.initialValues[DataKey.splitOption]) {
      bool resultOfSetSplitOption = await _amp18CCorNodeRepository
          .set1p8GCCorNodeSplitOption(state.splitOption);

      settingResult.add('${DataKey.splitOption.name},$resultOfSetSplitOption');
    }

    if (state.logInterval != state.initialValues[DataKey.logInterval]) {
      bool resultOfSetLogInterval = await _amp18CCorNodeRepository
          .set1p8GCCorNodeLogInterval(state.logInterval);

      settingResult.add('${DataKey.logInterval.name},$resultOfSetLogInterval');
    }

    // 等待 device 完成更新後在讀取值
    await Future.delayed(const Duration(milliseconds: 1000));

    await _amp18CCorNodeRepository.update1p8GCCorNodeCharacteristics();

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
      tappedSet: const {},
      enableSubmission: false,
      editMode: false,
    ));
  }
}
