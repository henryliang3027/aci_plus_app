import 'dart:async';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'setting18_regulation_event.dart';
part 'setting18_regulation_state.dart';

class Setting18RegulationBloc
    extends Bloc<Setting18RegulationEvent, Setting18RegulationState> {
  Setting18RegulationBloc({
    required Amp18Repository amp18Repository,
  })  : _amp18Repository = amp18Repository,
        super(const Setting18RegulationState()) {
    on<Initialized>(_onInitialized);
    on<SplitOptionChanged>(_onSplitOptionChanged);
    on<PilotFrequencyModeChanged>(_onPilotFrequencyModeChanged);
    on<FirstChannelLoadingFrequencyChanged>(
        _onFirstChannelLoadingFrequencyChanged);
    on<FirstChannelLoadingLevelChanged>(_onFirstChannelLoadingLevelChanged);
    on<LastChannelLoadingFrequencyChanged>(
        _onLastChannelLoadingFrequencyChanged);
    on<LastChannelLoadingLevelChanged>(_onLastChannelLoadingLevelChanged);
    on<PilotFrequency1Changed>(_onPilotFrequency1Changed);
    on<PilotFrequency2Changed>(_onPilotFrequency2Changed);
    on<AGCModeChanged>(_onAGCModeChanged);
    on<ALCModeChanged>(_onALCModeChanged);
    on<LogIntervalChanged>(_onLogIntervalChanged);
    on<RFOutputLogIntervalChanged>(_onRFOutputLogIntervalChanged);
    on<TGCCableLengthChanged>(_onTGCCableLengthChanged);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);

    add(const Initialized());
  }

  final Amp18Repository _amp18Repository;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18RegulationState> emit,
  ) async {
    if (!event.useCache) {
      await _amp18Repository.updateSettingCharacteristics();
    }
    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    String splitOption = characteristicDataCache[DataKey.splitOption] ?? '';
    String firstChannelLoadingFrequency =
        characteristicDataCache[DataKey.firstChannelLoadingFrequency] ?? '';
    String lastChannelLoadingFrequency =
        characteristicDataCache[DataKey.lastChannelLoadingFrequency] ?? '';
    String firstChannelLoadingLevel =
        characteristicDataCache[DataKey.firstChannelLoadingLevel] ?? '';
    String lastChannelLoadingLevel =
        characteristicDataCache[DataKey.lastChannelLoadingLevel] ?? '';
    String pilotFrequencyMode =
        characteristicDataCache[DataKey.pilotFrequencyMode] ?? '';
    String pilotFrequency1 =
        characteristicDataCache[DataKey.pilotFrequency1] ?? '';
    String pilotFrequency2 =
        characteristicDataCache[DataKey.pilotFrequency2] ?? '';

    String manualModePilot1RFOutputPower =
        characteristicDataCache[DataKey.manualModePilot1RFOutputPower] ?? '';
    String manualModePilot2RFOutputPower =
        characteristicDataCache[DataKey.manualModePilot2RFOutputPower] ?? '';

    String agcMode = characteristicDataCache[DataKey.agcMode] ?? '';
    String alcMode = characteristicDataCache[DataKey.alcMode] ?? '';
    String logInterval =
        characteristicDataCache[DataKey.logInterval] ?? state.logInterval;
    String rfOutputLogInterval =
        characteristicDataCache[DataKey.rfOutputLogInterval] ??
            state.rfOutputLogInterval;
    String tgcCableLength =
        characteristicDataCache[DataKey.tgcCableLength] ?? '';

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      splitOption: splitOption,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency.isNotEmpty
          ? RangeIntegerInput.dirty(firstChannelLoadingFrequency)
          : const RangeIntegerInput.pure(),
      firstChannelLoadingLevel:
          RangeFloatPointInput.dirty(firstChannelLoadingLevel),
      lastChannelLoadingFrequency:
          RangeIntegerInput.dirty(lastChannelLoadingFrequency),
      lastChannelLoadingLevel:
          RangeFloatPointInput.dirty(lastChannelLoadingLevel),
      pilotFrequencyMode: pilotFrequencyMode,
      pilotFrequency1: RangeIntegerInput.dirty(pilotFrequency1),
      pilotFrequency2: RangeIntegerInput.dirty(pilotFrequency2),
      manualModePilot1RFOutputPower: manualModePilot1RFOutputPower,
      manualModePilot2RFOutputPower: manualModePilot2RFOutputPower,
      agcMode: agcMode,
      alcMode: alcMode,
      logInterval: logInterval,
      rfOutputLogInterval: rfOutputLogInterval,
      tgcCableLength: tgcCableLength,
      isInitialize: true,
      isInitialPilotFrequencyLevelValues: false,
      initialValues: characteristicDataCache,
      editMode: false,
      enableSubmission: false,
      tappedSet: const {},
      settingResult: const [],
    ));
  }

  void _onSplitOptionChanged(
    SplitOptionChanged event,
    Emitter<Setting18RegulationState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.splitOption);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      splitOption: event.splitOption,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        splitOption: event.splitOption,
      ),
    ));
  }

  int _getMinForwardStartFrequency() {
    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    String currentDetectedSplitOption =
        characteristicDataCache[DataKey.currentDetectedSplitOption] ?? '0';

    int startFrequency = splitBaseLine[currentDetectedSplitOption]?.$2 ?? 0;

    return startFrequency;
  }

  int _getMaxForwardStopFrequency() {
    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    String currentDetectedSplitOption =
        characteristicDataCache[DataKey.currentDetectedSplitOption] ?? '0';

    int stopFrequency =
        maxStopFrequencyByDFUType[currentDetectedSplitOption] ?? 1794;

    return stopFrequency;
  }

  void _onPilotFrequencyModeChanged(
    PilotFrequencyModeChanged event,
    Emitter<Setting18RegulationState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.pilotFrequencyMode);

    tappedSet.remove(DataKey.firstChannelLoadingFrequency);
    tappedSet.remove(DataKey.firstChannelLoadingLevel);
    tappedSet.remove(DataKey.lastChannelLoadingFrequency);
    tappedSet.remove(DataKey.lastChannelLoadingLevel);
    tappedSet.remove(DataKey.pilotFrequency1);
    tappedSet.remove(DataKey.pilotFrequency2);

    String firstChannelLoadingFrequencyValue = '';
    String firstChannelLoadingLevelValue = '';
    String lastChannelLoadingFrequencyValue = '';
    String lastChannelLoadingLevelValue = '';
    String pilotFrequency1Value = '';
    String pilotFrequency2Value = '';

    if (event.pilotFrequencyMode != state.pilotFrequencyMode) {
      firstChannelLoadingFrequencyValue =
          state.initialValues[DataKey.firstChannelLoadingFrequency] ?? '';
      firstChannelLoadingLevelValue =
          state.initialValues[DataKey.firstChannelLoadingLevel] ?? '';
      lastChannelLoadingFrequencyValue =
          state.initialValues[DataKey.lastChannelLoadingFrequency] ?? '';
      lastChannelLoadingLevelValue =
          state.initialValues[DataKey.lastChannelLoadingLevel] ?? '';
      pilotFrequency1Value = state.initialValues[DataKey.pilotFrequency1] ?? '';
      pilotFrequency2Value = state.initialValues[DataKey.pilotFrequency2] ?? '';
    } else {
      firstChannelLoadingFrequencyValue =
          state.firstChannelLoadingFrequency.value;
      firstChannelLoadingLevelValue = state.firstChannelLoadingLevel.value;
      lastChannelLoadingFrequencyValue =
          state.lastChannelLoadingFrequency.value;
      lastChannelLoadingLevelValue = state.lastChannelLoadingLevel.value;
      pilotFrequency1Value = state.pilotFrequency1.value;
      pilotFrequency2Value = state.pilotFrequency2.value;
    }

    int forwardStartFrequency = _getMinForwardStartFrequency();
    int forwardStopFrequency = _getMaxForwardStopFrequency();

    RangeIntegerInput firstChannelLoadingFrequency = RangeIntegerInput.dirty(
      firstChannelLoadingFrequencyValue,
      minValue: forwardStartFrequency,
      maxValue: forwardStopFrequency,
    );

    RangeFloatPointInput firstChannelLoadingLevel = RangeFloatPointInput.dirty(
      firstChannelLoadingLevelValue,
      minValue: 20.0,
      maxValue: 61.0,
    );

    RangeIntegerInput lastChannelLoadingFrequency = RangeIntegerInput.dirty(
      lastChannelLoadingFrequencyValue,
      minValue: forwardStartFrequency,
      maxValue: forwardStopFrequency,
    );

    RangeFloatPointInput lastChannelLoadingLevel = RangeFloatPointInput.dirty(
      lastChannelLoadingLevelValue,
      minValue: 20.0,
      maxValue: 61.0,
    );

    RangeIntegerInput pilotFrequency1 = RangeIntegerInput.dirty(
      pilotFrequency1Value,
      minValue: forwardStartFrequency,
      maxValue: forwardStopFrequency,
    );

    RangeIntegerInput pilotFrequency2 = RangeIntegerInput.dirty(
      pilotFrequency2Value,
      minValue: forwardStartFrequency,
      maxValue: forwardStopFrequency,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      pilotFrequencyMode: event.pilotFrequencyMode,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency,
      firstChannelLoadingLevel: firstChannelLoadingLevel,
      lastChannelLoadingFrequency: lastChannelLoadingFrequency,
      lastChannelLoadingLevel: lastChannelLoadingLevel,
      pilotFrequency1: pilotFrequency1,
      pilotFrequency2: pilotFrequency2,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: true,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        firstChannelLoadingFrequency: firstChannelLoadingFrequency,
        firstChannelLoadingLevel: firstChannelLoadingLevel,
        lastChannelLoadingFrequency: lastChannelLoadingFrequency,
        lastChannelLoadingLevel: lastChannelLoadingLevel,
        pilotFrequencyMode: event.pilotFrequencyMode,
        pilotFrequency1: pilotFrequency1,
        pilotFrequency2: pilotFrequency2,
      ),
    ));
  }

  void _onFirstChannelLoadingFrequencyChanged(
    FirstChannelLoadingFrequencyChanged event,
    Emitter<Setting18RegulationState> emit,
  ) {
    // 根據 偵測到的 splitOption 來決定 minimum forwardStartFrequency 和 maximum forwardStopFrequency
    int minForwardStartFrequency = _getMinForwardStartFrequency();
    int maxForwardStopFrequency = _getMaxForwardStopFrequency();

    // 偵測到的 splitOption的起始頻率 <= firstChannelLoadingFrequency <= lastChannelLoadingFrequency
    // 截止頻率輸入內容不符時即 int.tryParse(state.lastChannelLoadingFrequency.value) 回傳 null,
    // 則判斷方式為: 偵測到的splitOption的起始頻率 <= firstChannelLoadingFrequency <= maxForwardStopFrequency
    RangeIntegerInput firstChannelLoadingFrequency = RangeIntegerInput.dirty(
      event.firstChannelLoadingFrequency,
      minValue: minForwardStartFrequency,
      maxValue: int.tryParse(state.lastChannelLoadingFrequency.value) ??
          maxForwardStopFrequency,
    );

    // firstChannelLoadingFrequency <= lastChannelLoadingFrequency <= maxForwardStopFrequency
    // 起始頻率輸入內容不符時即 int.tryParse(state.firstChannelLoadingFrequency.value) 回傳 null,
    // 則判斷方式為: minForwardStartFrequency <= lastChannelLoadingFrequency <= maxForwardStopFrequency
    RangeIntegerInput lastChannelLoadingFrequency = RangeIntegerInput.dirty(
      state.lastChannelLoadingFrequency.value,
      minValue: int.tryParse(event.firstChannelLoadingFrequency) ??
          minForwardStartFrequency,
      maxValue: maxForwardStopFrequency,
    );

    // pilotFrequency1
    // minValue 判斷優先順序
    // firstChannelLoadingFrequency <= pilotFrequency1
    // 如果也沒輸入 firstChannelLoadingFrequency 則 minForwardStartFrequency <= pilotFrequency1

    // maxValue 判斷優先順序
    // pilotFrequency1 <= pilotFrequency2
    // 如果沒輸入 pilotFrequency2 則 pilotFrequency1 <= lastChannelLoadingFrequency
    // 如果也沒輸入 lastChannelLoadingFrequency 則 pilotFrequency1 <= maxForwardStopFrequency
    RangeIntegerInput pilotFrequency1 = RangeIntegerInput.dirty(
      state.pilotFrequency1.value,
      minValue: int.tryParse(event.firstChannelLoadingFrequency) ??
          minForwardStartFrequency,
      maxValue: int.tryParse(state.pilotFrequency2.value) ??
          int.tryParse(state.lastChannelLoadingFrequency.value) ??
          maxForwardStopFrequency,
    );

    // minValue 判斷優先順序
    // pilotFrequency1 <= pilotFrequency2
    // 如果沒輸入 pilotFrequency1 則 firstChannelLoadingFrequency <= pilotFrequency2
    // 如果也沒輸入 firstChannelLoadingFrequency 則 minForwardStartFrequency <= pilotFrequency2

    // maxValue 判斷優先順序
    // pilotFrequency2 <= lastChannelLoadingFrequency
    // 如果沒輸入 lastChannelLoadingFrequency 則 pilotFrequency2 <= maxForwardStopFrequency
    RangeIntegerInput pilotFrequency2 = RangeIntegerInput.dirty(
      state.pilotFrequency2.value,
      minValue: int.tryParse(state.pilotFrequency1.value) ??
          int.tryParse(event.firstChannelLoadingFrequency) ??
          minForwardStartFrequency,
      maxValue: int.tryParse(state.lastChannelLoadingFrequency.value) ??
          maxForwardStopFrequency,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.firstChannelLoadingFrequency);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency,
      lastChannelLoadingFrequency: lastChannelLoadingFrequency,
      pilotFrequency1: pilotFrequency1,
      pilotFrequency2: pilotFrequency2,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        firstChannelLoadingFrequency: firstChannelLoadingFrequency,
        lastChannelLoadingFrequency: lastChannelLoadingFrequency,
        pilotFrequency1: pilotFrequency1,
        pilotFrequency2: pilotFrequency2,
      ),
    ));
  }

  void _onFirstChannelLoadingLevelChanged(
    FirstChannelLoadingLevelChanged event,
    Emitter<Setting18RegulationState> emit,
  ) {
    // 20.0 <= firstChannelLoadingLevel <= lastChannelLoadingLevel
    // 如果沒輸入 lastChannelLoadingLevel 時 lastChannelLoadingLevel <= 61.0

    // 2025/04/24 改為不限制範圍
    RangeFloatPointInput firstChannelLoadingLevel = RangeFloatPointInput.dirty(
      event.firstChannelLoadingLevel,
    );

    RangeFloatPointInput lastChannelLoadingLevel = RangeFloatPointInput.dirty(
      state.lastChannelLoadingLevel.value,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.firstChannelLoadingLevel);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      firstChannelLoadingLevel: firstChannelLoadingLevel,
      lastChannelLoadingLevel: lastChannelLoadingLevel,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        firstChannelLoadingLevel: firstChannelLoadingLevel,
        lastChannelLoadingLevel: lastChannelLoadingLevel,
      ),
    ));
  }

  // 參照 _onFirstChannelLoadingFrequencyChanged 的邏輯來設定各個 frequency 上下限
  void _onLastChannelLoadingFrequencyChanged(
    LastChannelLoadingFrequencyChanged event,
    Emitter<Setting18RegulationState> emit,
  ) {
    int minForwardStartFrequency = _getMinForwardStartFrequency();
    int maxForwardStopFrequency = _getMaxForwardStopFrequency();

    RangeIntegerInput firstChannelLoadingFrequency = RangeIntegerInput.dirty(
      state.firstChannelLoadingFrequency.value,
      minValue: minForwardStartFrequency,
      maxValue: int.tryParse(event.lastChannelLoadingFrequency) ??
          maxForwardStopFrequency,
    );

    RangeIntegerInput lastChannelLoadingFrequency = RangeIntegerInput.dirty(
      event.lastChannelLoadingFrequency,
      minValue: int.tryParse(state.firstChannelLoadingFrequency.value) ??
          minForwardStartFrequency,
      maxValue: maxForwardStopFrequency,
    );

    RangeIntegerInput pilotFrequency1 = RangeIntegerInput.dirty(
      state.pilotFrequency1.value,
      minValue: int.tryParse(state.firstChannelLoadingFrequency.value) ??
          minForwardStartFrequency,
      maxValue: int.tryParse(state.pilotFrequency2.value) ??
          int.tryParse(state.lastChannelLoadingFrequency.value) ??
          maxForwardStopFrequency,
    );

    RangeIntegerInput pilotFrequency2 = RangeIntegerInput.dirty(
      state.pilotFrequency2.value,
      minValue: int.tryParse(state.pilotFrequency1.value) ??
          int.tryParse(state.firstChannelLoadingFrequency.value) ??
          minForwardStartFrequency,
      maxValue: int.tryParse(event.lastChannelLoadingFrequency) ??
          maxForwardStopFrequency,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.lastChannelLoadingFrequency);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency,
      lastChannelLoadingFrequency: lastChannelLoadingFrequency,
      pilotFrequency1: pilotFrequency1,
      pilotFrequency2: pilotFrequency2,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        firstChannelLoadingFrequency: firstChannelLoadingFrequency,
        lastChannelLoadingFrequency: lastChannelLoadingFrequency,
        pilotFrequency1: pilotFrequency1,
        pilotFrequency2: pilotFrequency2,
      ),
    ));
  }

  void _onLastChannelLoadingLevelChanged(
    LastChannelLoadingLevelChanged event,
    Emitter<Setting18RegulationState> emit,
  ) {
    // 20.0 <= firstChannelLoadingLevel <= lastChannelLoadingLevel
    // 如果沒輸入 lastChannelLoadingLevel 時 lastChannelLoadingLevel <= 61.0

    // 2025/04/24 改為不限制範圍
    RangeFloatPointInput firstChannelLoadingLevel = RangeFloatPointInput.dirty(
      state.firstChannelLoadingLevel.value,
    );

    RangeFloatPointInput lastChannelLoadingLevel = RangeFloatPointInput.dirty(
      event.lastChannelLoadingLevel,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.lastChannelLoadingLevel);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      firstChannelLoadingLevel: firstChannelLoadingLevel,
      lastChannelLoadingLevel: lastChannelLoadingLevel,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        firstChannelLoadingLevel: firstChannelLoadingLevel,
        lastChannelLoadingLevel: lastChannelLoadingLevel,
      ),
    ));
  }

  void _onPilotFrequency1Changed(
    PilotFrequency1Changed event,
    Emitter<Setting18RegulationState> emit,
  ) {
    // minValue 判斷優先順序
    // firstChannelLoadingFrequency <= pilotFrequency1
    // 如果也沒輸入 firstChannelLoadingFrequency 則 forwardStartFrequency <= pilotFrequency1

    // maxValue 判斷優先順序
    // pilotFrequency1 <= pilotFrequency2
    // 如果沒輸入 pilotFrequency2 則 pilotFrequency1 <= lastChannelLoadingFrequency
    // 如果也沒輸入 lastChannelLoadingFrequency 則 pilotFrequency1 <= 1794
    int forwardStartFrequency = _getMinForwardStartFrequency();
    RangeIntegerInput pilotFrequency1 = RangeIntegerInput.dirty(
      event.pilotFrequency1,
      minValue: int.tryParse(state.firstChannelLoadingFrequency.value) ??
          forwardStartFrequency,
      maxValue: int.tryParse(state.pilotFrequency2.value) ??
          int.tryParse(state.lastChannelLoadingFrequency.value) ??
          1794,
    );

    // minValue 判斷優先順序
    // pilotFrequency1 <= pilotFrequency2
    // 如果沒輸入 pilotFrequency1 則 firstChannelLoadingFrequency <= pilotFrequency2
    // 如果也沒輸入 firstChannelLoadingFrequency 則 forwardStartFrequency <= pilotFrequency2

    // maxValue 判斷優先順序
    // pilotFrequency2 <= lastChannelLoadingFrequency
    // 如果沒輸入 lastChannelLoadingFrequency 則 pilotFrequency2 <= 1794
    RangeIntegerInput pilotFrequency2 = RangeIntegerInput.dirty(
      state.pilotFrequency2.value,
      minValue: int.tryParse(event.pilotFrequency1) ??
          int.tryParse(state.firstChannelLoadingFrequency.value) ??
          forwardStartFrequency,
      maxValue: int.tryParse(state.lastChannelLoadingFrequency.value) ?? 1794,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.pilotFrequency1);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      pilotFrequency1: pilotFrequency1,
      pilotFrequency2: pilotFrequency2,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        pilotFrequency1: pilotFrequency1,
        pilotFrequency2: pilotFrequency2,
      ),
    ));
  }

  void _onPilotFrequency2Changed(
    PilotFrequency2Changed event,
    Emitter<Setting18RegulationState> emit,
  ) {
    // minValue 判斷優先順序
    // firstChannelLoadingFrequency <= pilotFrequency1
    // 如果也沒輸入 firstChannelLoadingFrequency 則 forwardStartFrequency <= pilotFrequency1

    // maxValue 判斷優先順序
    // pilotFrequency1 <= pilotFrequency2
    // 如果沒輸入 pilotFrequency2 則 pilotFrequency1 <= lastChannelLoadingFrequency
    // 如果也沒輸入 lastChannelLoadingFrequency 則 pilotFrequency1 <= 1794
    int forwardStartFrequency = _getMinForwardStartFrequency();
    RangeIntegerInput pilotFrequency1 = RangeIntegerInput.dirty(
      state.pilotFrequency1.value,
      minValue: int.tryParse(state.firstChannelLoadingFrequency.value) ??
          forwardStartFrequency,
      maxValue: int.tryParse(event.pilotFrequency2) ??
          int.tryParse(state.lastChannelLoadingFrequency.value) ??
          1794,
    );

    // minValue 判斷優先順序
    // pilotFrequency1 <= pilotFrequency2
    // 如果沒輸入 pilotFrequency1 則 firstChannelLoadingFrequency <= pilotFrequency2
    // 如果也沒輸入 firstChannelLoadingFrequency 則 forwardStartFrequency <= pilotFrequency2

    // maxValue 判斷優先順序
    // pilotFrequency2 <= lastChannelLoadingFrequency
    // 如果沒輸入 lastChannelLoadingFrequency 則 pilotFrequency2 <= 1794
    RangeIntegerInput pilotFrequency2 = RangeIntegerInput.dirty(
      event.pilotFrequency2,
      minValue: int.tryParse(state.pilotFrequency1.value) ??
          int.tryParse(state.firstChannelLoadingFrequency.value) ??
          forwardStartFrequency,
      maxValue: int.tryParse(state.lastChannelLoadingFrequency.value) ?? 1794,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.pilotFrequency2);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      pilotFrequency1: pilotFrequency1,
      pilotFrequency2: pilotFrequency2,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        pilotFrequency1: pilotFrequency1,
        pilotFrequency2: pilotFrequency2,
      ),
    ));
  }

  void _onAGCModeChanged(
    AGCModeChanged event,
    Emitter<Setting18RegulationState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.agcMode);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      agcMode: event.agcMode,
      alcMode: event.agcMode,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        agcMode: event.agcMode,
        alcMode: event.agcMode,
      ),
    ));
  }

  void _onALCModeChanged(
    ALCModeChanged event,
    Emitter<Setting18RegulationState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      alcMode: event.alcMode,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      enableSubmission: _isEnabledSubmission(
        alcMode: event.alcMode,
      ),
    ));
  }

  void _onLogIntervalChanged(
    LogIntervalChanged event,
    Emitter<Setting18RegulationState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.logInterval);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      logInterval: event.logInterval,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        logInterval: event.logInterval,
      ),
    ));
  }

  void _onRFOutputLogIntervalChanged(
    RFOutputLogIntervalChanged event,
    Emitter<Setting18RegulationState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.rfOutputLogInterval);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rfOutputLogInterval: event.rfOutputLogInterval,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        rfOutputLogInterval: event.rfOutputLogInterval,
      ),
    ));
  }

  void _onTGCCableLengthChanged(
    TGCCableLengthChanged event,
    Emitter<Setting18RegulationState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      tgcCableLength: event.tgcCableLength,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      enableSubmission: _isEnabledSubmission(
        tgcCableLength: event.tgcCableLength,
      ),
    ));
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18RegulationState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      editMode: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<Setting18RegulationState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: true,
      isInitialPilotFrequencyLevelValues: false,
      editMode: false,
      enableSubmission: false,
      tappedSet: {},
      splitOption: state.initialValues[DataKey.splitOption],
      firstChannelLoadingFrequency: RangeIntegerInput.dirty(
          state.initialValues[DataKey.firstChannelLoadingFrequency] ?? ''),
      firstChannelLoadingLevel: RangeFloatPointInput.dirty(
          state.initialValues[DataKey.firstChannelLoadingLevel] ?? ''),
      lastChannelLoadingFrequency: RangeIntegerInput.dirty(
          state.initialValues[DataKey.lastChannelLoadingFrequency] ?? ''),
      lastChannelLoadingLevel: RangeFloatPointInput.dirty(
          state.initialValues[DataKey.lastChannelLoadingLevel] ?? ''),
      pilotFrequencyMode: state.initialValues[DataKey.pilotFrequencyMode],
      pilotFrequency1: RangeIntegerInput.dirty(
          state.initialValues[DataKey.pilotFrequency1] ?? ''),
      pilotFrequency2: RangeIntegerInput.dirty(
          state.initialValues[DataKey.pilotFrequency2] ?? ''),
      agcMode: state.initialValues[DataKey.agcMode],
      alcMode: state.initialValues[DataKey.alcMode],
      logInterval: state.initialValues[DataKey.logInterval],
      rfOutputLogInterval: state.initialValues[DataKey.rfOutputLogInterval],
      tgcCableLength: state.initialValues[DataKey.tgcCableLength],
    ));
  }

  bool _isEnabledSubmission({
    String? splitOption,
    RangeIntegerInput? firstChannelLoadingFrequency,
    RangeFloatPointInput? firstChannelLoadingLevel,
    RangeIntegerInput? lastChannelLoadingFrequency,
    RangeFloatPointInput? lastChannelLoadingLevel,
    String? pilotFrequencyMode,
    RangeIntegerInput? pilotFrequency1,
    RangeIntegerInput? pilotFrequency2,
    String? agcMode,
    String? alcMode,
    String? logInterval,
    String? rfOutputLogInterval,
    String? tgcCableLength,
  }) {
    splitOption ??= state.splitOption;
    firstChannelLoadingFrequency ??= state.firstChannelLoadingFrequency;
    firstChannelLoadingLevel ??= state.firstChannelLoadingLevel;
    lastChannelLoadingFrequency ??= state.lastChannelLoadingFrequency;
    lastChannelLoadingLevel ??= state.lastChannelLoadingLevel;
    pilotFrequencyMode ??= state.pilotFrequencyMode;
    pilotFrequency1 ??= state.pilotFrequency1;
    pilotFrequency2 ??= state.pilotFrequency2;
    agcMode ??= state.agcMode;
    alcMode ??= state.alcMode;
    logInterval ??= state.logInterval;
    rfOutputLogInterval ??= state.rfOutputLogInterval;
    tgcCableLength ??= state.tgcCableLength;

    bool isValid = false;

    if (pilotFrequencyMode == '0') {
      isValid = Formz.validate([
        firstChannelLoadingFrequency,
        firstChannelLoadingLevel,
        lastChannelLoadingFrequency,
        lastChannelLoadingLevel,
      ]);
    } else if (pilotFrequencyMode == '1') {
      isValid = Formz.validate([
        firstChannelLoadingFrequency,
        firstChannelLoadingLevel,
        lastChannelLoadingFrequency,
        lastChannelLoadingLevel,
        pilotFrequency1,
        pilotFrequency2,
      ]);
    } else {
      isValid = true;
    }

    if (isValid) {
      if (splitOption != state.initialValues[DataKey.splitOption] ||
          firstChannelLoadingFrequency.value !=
              state.initialValues[DataKey.firstChannelLoadingFrequency] ||
          firstChannelLoadingLevel.value !=
              state.initialValues[DataKey.firstChannelLoadingLevel] ||
          lastChannelLoadingFrequency.value !=
              state.initialValues[DataKey.lastChannelLoadingFrequency] ||
          lastChannelLoadingLevel.value !=
              state.initialValues[DataKey.lastChannelLoadingLevel] ||
          pilotFrequencyMode !=
              state.initialValues[DataKey.pilotFrequencyMode] ||
          pilotFrequency1.value !=
              state.initialValues[DataKey.pilotFrequency1] ||
          pilotFrequency2.value !=
              state.initialValues[DataKey.pilotFrequency2] ||
          agcMode != state.initialValues[DataKey.agcMode] ||
          alcMode != state.initialValues[DataKey.alcMode] ||
          logInterval != state.initialValues[DataKey.logInterval] ||
          rfOutputLogInterval !=
              state.initialValues[DataKey.rfOutputLogInterval] ||
          tgcCableLength != state.initialValues[DataKey.tgcCableLength]) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18RegulationState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
    ));

    List<String> settingResult = [];

    // if (state.splitOption != state.initialValues[DataKey.splitOption]) {
    //   bool resultOfSetSplitOption =
    //       await _amp18Repository.set1p8GSplitOption(state.splitOption);

    //   settingResult.add('${DataKey.splitOption.name},$resultOfSetSplitOption');
    // }

    if (state.firstChannelLoadingFrequency.value !=
        state.initialValues[DataKey.firstChannelLoadingFrequency]) {
      bool resultOfSetFirstChannelLoadingFrequency =
          await _amp18Repository.set1p8GFirstChannelLoadingFrequency(
              state.firstChannelLoadingFrequency.value);

      settingResult.add(
          '${DataKey.firstChannelLoadingFrequency.name},$resultOfSetFirstChannelLoadingFrequency');

      // await _amp18Repository.updateCharacteristics();
    }

    if (state.firstChannelLoadingLevel.value !=
        state.initialValues[DataKey.firstChannelLoadingLevel]) {
      bool resultOfSetFirstChannelLoadingLevel =
          await _amp18Repository.set1p8GFirstChannelLoadingLevel(
              state.firstChannelLoadingLevel.value);

      settingResult.add(
          '${DataKey.firstChannelLoadingLevel.name},$resultOfSetFirstChannelLoadingLevel');
    }

    if (state.lastChannelLoadingFrequency.value !=
        state.initialValues[DataKey.lastChannelLoadingFrequency]) {
      bool resultOfSetLastChannelLoadingFrequency =
          await _amp18Repository.set1p8GLastChannelLoadingFrequency(
              state.lastChannelLoadingFrequency.value);

      settingResult.add(
          '${DataKey.lastChannelLoadingFrequency.name},$resultOfSetLastChannelLoadingFrequency');
    }

    if (state.lastChannelLoadingLevel.value !=
        state.initialValues[DataKey.lastChannelLoadingLevel]) {
      bool resultOfSetLastChannelLoadingLevel = await _amp18Repository
          .set1p8GLastChannelLoadingLevel(state.lastChannelLoadingLevel.value);

      settingResult.add(
          '${DataKey.lastChannelLoadingLevel.name},$resultOfSetLastChannelLoadingLevel');
    }

    if (state.pilotFrequencyMode !=
        state.initialValues[DataKey.pilotFrequencyMode]) {
      bool resultOfSetPilotFrequencyMode = await _amp18Repository
          .set1p8GPilotFrequencyMode(state.pilotFrequencyMode);

      settingResult.add(
          '${DataKey.pilotFrequencyMode.name},$resultOfSetPilotFrequencyMode');
    }

    if (state.pilotFrequency1.value !=
        state.initialValues[DataKey.pilotFrequency1]) {
      bool resultOfSetPilotFrequency1 = await _amp18Repository
          .set1p8GPilotFrequency1(state.pilotFrequency1.value);

      settingResult
          .add('${DataKey.pilotFrequency1.name},$resultOfSetPilotFrequency1');
    }

    if (state.pilotFrequency2.value !=
        state.initialValues[DataKey.pilotFrequency2]) {
      bool resultOfSetPilotFrequency2 = await _amp18Repository
          .set1p8GPilotFrequency2(state.pilotFrequency2.value);

      settingResult
          .add('${DataKey.pilotFrequency2.name},$resultOfSetPilotFrequency2');
    }

    if (state.agcMode != state.initialValues[DataKey.agcMode]) {
      bool resultOfSetForwardAGCMode =
          await _amp18Repository.set1p8GForwardAGCMode(state.agcMode);

      settingResult.add('${DataKey.agcMode.name},$resultOfSetForwardAGCMode');
    }

    if (state.alcMode != state.initialValues[DataKey.alcMode]) {
      bool resultOfSetALCMode =
          await _amp18Repository.set1p8GALCMode(state.alcMode);

      // 20240516 不顯示設定的結果, 之後不具備 ALC 功能
      // settingResult.add('${DataKey.alcMode.name},$resultOfSetALCMode');
    }

    if (state.logInterval != state.initialValues[DataKey.logInterval]) {
      bool resultOfSetLogInterval =
          await _amp18Repository.set1p8GLogInterval(state.logInterval);

      settingResult.add('${DataKey.logInterval.name},$resultOfSetLogInterval');
    }

    if (state.rfOutputLogInterval !=
        state.initialValues[DataKey.rfOutputLogInterval]) {
      bool resultOfSetRFOutputLogInterval = await _amp18Repository
          .set1p8GRFOutputLogInterval(state.rfOutputLogInterval);

      settingResult.add(
          '${DataKey.rfOutputLogInterval.name},$resultOfSetRFOutputLogInterval');
    }

    if (state.tgcCableLength != state.initialValues[DataKey.tgcCableLength]) {
      bool resultOfSetTGCCableLength =
          await _amp18Repository.set1p8GTGCCableLength(state.tgcCableLength);

      settingResult
          .add('${DataKey.tgcCableLength.name},$resultOfSetTGCCableLength');
    }

    // 等待 device 完成更新後在讀取值
    await Future.delayed(const Duration(milliseconds: 1000));

    await _amp18Repository.updateCharacteristics();

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
      tappedSet: {},
      enableSubmission: false,
      editMode: false,
    ));
  }
}
