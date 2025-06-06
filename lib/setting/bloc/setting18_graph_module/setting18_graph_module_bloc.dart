import 'dart:async';

import 'package:aci_plus_app/core/control_item_value.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'setting18_graph_module_event.dart';
part 'setting18_graph_module_state.dart';

class Setting18GraphModuleBloc
    extends Bloc<Setting18GraphModuleEvent, Setting18GraphModuleState> {
  Setting18GraphModuleBloc({
    required Amp18Repository amp18Repository,
    bool editable = true,
  })  : _amp18Repository = amp18Repository,
        _editable = editable,
        super(const Setting18GraphModuleState()) {
    on<Initialized>(_onInitialized);
    on<ControlItemChanged>(_onControlItemChanged);
    on<PilotFrequencyModeChanged>(_onPilotFrequencyModeChanged);
    on<FirstChannelLoadingFrequencyChanged>(
        _onFirstChannelLoadingFrequencyChanged);
    on<LastChannelLoadingFrequencyChanged>(
        _onLastChannelLoadingFrequencyChanged);
    on<FirstChannelLoadingLevelChanged>(_onFirstChannelLoadingLevelChanged);
    on<LastChannelLoadingLevelChanged>(_onLastChannelLoadingLevelChanged);
    on<AGCModeChanged>(_onAGCModeChanged);
    on<ALCModeChanged>(_onALCModeChanged);
    on<PilotFrequency1Changed>(_onPilotFrequency1Changed);
    on<PilotFrequency2Changed>(_onPilotFrequency2Changed);
    on<SettingSubmitted>(_onSettingSubmitted);

    add(const Initialized());
  }

  final Amp18Repository _amp18Repository;
  final bool _editable;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18GraphModuleState> emit,
  ) async {
    if (!event.useCache) {
      await _amp18Repository.updateSettingCharacteristics();
    }

    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    String forwardCEQIndex =
        characteristicDataCache[DataKey.forwardCEQIndex] ?? '';

    String splitOption =
        characteristicDataCache[DataKey.currentDetectedSplitOption]!;
    String partId = characteristicDataCache[DataKey.partId]!;
    String operatingMode = getOperatingModeFromForwardCEQIndex(forwardCEQIndex);

    Map<DataKey, MinMax> values = {};

    if (operatingMode.isNotEmpty &&
        splitOption.isNotEmpty &&
        splitOption != '0' && // '0' indicates no DFU
        partId.isNotEmpty) {
      values = ControlItemValue
          .allValueCollections[operatingMode]![splitOption]![partId]!;
    }

    // Combine them into one map:
    Map<Enum, DataKey> combinedMap = {};
    for (var map in SettingItemTable.controlItemDataMapCollection[partId]!) {
      combinedMap.addAll(map);
    }

    Map<DataKey, RangeFloatPointInput> targetValues = {};
    Map<DataKey, String> targetIngressValues = {};

    combinedMap.forEach((name, dataKey) {
      if (dataKey.name.startsWith('ingress')) {
        targetIngressValues[dataKey] = characteristicDataCache[dataKey]!;
      } else {
        MinMax minMax = values[dataKey]!;
        RangeFloatPointInput rangeFloatPointInput = RangeFloatPointInput.dirty(
          characteristicDataCache[dataKey]!,
          minValue: minMax.min,
          maxValue: minMax.max,
        );

        targetValues[dataKey] = rangeFloatPointInput;
      }
    });

    String firstChannelLoadingFrequency =
        characteristicDataCache[DataKey.firstChannelLoadingFrequency] ?? '';
    String lastChannelLoadingFrequency =
        characteristicDataCache[DataKey.lastChannelLoadingFrequency] ?? '';
    String firstChannelLoadingLevel =
        characteristicDataCache[DataKey.firstChannelLoadingLevel] ?? '';
    String lastChannelLoadingLevel =
        characteristicDataCache[DataKey.lastChannelLoadingLevel] ?? '';

    String currentDetectedSplitOption =
        characteristicDataCache[DataKey.currentDetectedSplitOption] ?? '0';

    int minFirstChannelLoadingFrequency = getMinFirstChannelLoadingFrequency(
        currentDetectedSplitOption: currentDetectedSplitOption);
    int maxLastChannelLoadingFrequency = getMaxLastChannelLoadingFrequency(
      partId: partId,
      currentDetectedSplitOption: currentDetectedSplitOption,
    );

    EQType eqType = eqTypeMap[partId] ?? EQType.none;
    String pilotFrequencyMode =
        characteristicDataCache[DataKey.pilotFrequencyMode] ?? '';

    if (eqType == EQType.board) {
      // 如果是 onboard 放大器，則 pilotFrequencyMode 根據
      // lastChannelLoadingFrequency 來決定是 frequency1p2G 或 frequency1p8G
      if (pilotFrequencyMode == '3') {
        int frequency = int.tryParse(lastChannelLoadingFrequency) ?? 0;
        pilotFrequencyMode =
            _getBoardBenchModeNameByFrequency(frequency: frequency);
        characteristicDataCache[DataKey.pilotFrequencyMode] =
            pilotFrequencyMode;
      }
    }

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

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      targetValues: targetValues,
      targetIngressValues: targetIngressValues,
      pilotFrequencyMode: pilotFrequencyMode,
      eqType: eqType,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency.isNotEmpty
          ? RangeIntegerInput.dirty(firstChannelLoadingFrequency)
          : const RangeIntegerInput.pure(),
      firstChannelLoadingLevel:
          RangeFloatPointInput.dirty(firstChannelLoadingLevel),
      lastChannelLoadingFrequency:
          RangeIntegerInput.dirty(lastChannelLoadingFrequency),
      lastChannelLoadingLevel:
          RangeFloatPointInput.dirty(lastChannelLoadingLevel),
      minFirstChannelLoadingFrequency: minFirstChannelLoadingFrequency,
      maxLastChannelLoadingFrequency: maxLastChannelLoadingFrequency,
      pilotFrequency1: RangeIntegerInput.dirty(pilotFrequency1),
      pilotFrequency2: RangeIntegerInput.dirty(pilotFrequency2),
      manualModePilot1RFOutputPower: manualModePilot1RFOutputPower,
      manualModePilot2RFOutputPower: manualModePilot2RFOutputPower,
      agcMode: agcMode,
      alcMode: alcMode,
      isInitialize: true,
      isInitialPilotFrequencyLevelValues: false,
      initialValues: characteristicDataCache,
      editMode: _editable,
      enableSubmission: false,
      tappedSet: const {},
      settingResult: const [],
    ));
  }

  void _onControlItemChanged(
    ControlItemChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    if (event.dataKey.name.startsWith('ingress')) {
      Map<DataKey, String> targetIngressValues =
          Map<DataKey, String>.from(state.targetIngressValues);

      targetIngressValues[event.dataKey] = event.value;

      Set<DataKey> tappedSet = Set.from(state.tappedSet);
      tappedSet.add(event.dataKey);

      emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        targetIngressValues: targetIngressValues,
        isInitialize: false,
        tappedSet: tappedSet,
        enableSubmission: _isEnabledSubmission(
          targetIngressValues: targetIngressValues,
        ),
      ));
    } else {
      Map<DataKey, RangeFloatPointInput> targetValues =
          Map<DataKey, RangeFloatPointInput>.from(state.targetValues);

      RangeFloatPointInput rangeFloatPointInput = RangeFloatPointInput.dirty(
        event.value,
        minValue: state.targetValues[event.dataKey]!.minValue,
        maxValue: state.targetValues[event.dataKey]!.maxValue,
      );

      targetValues[event.dataKey] = rangeFloatPointInput;

      Set<DataKey> tappedSet = Set.from(state.tappedSet);
      tappedSet.add(event.dataKey);

      emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        targetValues: targetValues,
        isInitialize: false,
        tappedSet: tappedSet,
        enableSubmission: _isEnabledSubmission(
          targetValues: targetValues,
        ),
      ));
    }
  }

  void _onPilotFrequencyModeChanged(
    PilotFrequencyModeChanged event,
    Emitter<Setting18GraphModuleState> emit,
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

    RangeIntegerInput firstChannelLoadingFrequency = RangeIntegerInput.dirty(
      firstChannelLoadingFrequencyValue,
      minValue: state.minFirstChannelLoadingFrequency,
      maxValue: state.maxLastChannelLoadingFrequency,
    );

    RangeFloatPointInput firstChannelLoadingLevel = RangeFloatPointInput.dirty(
      firstChannelLoadingLevelValue,
      minValue: 20.0,
      maxValue: 61.0,
    );

    RangeIntegerInput lastChannelLoadingFrequency = RangeIntegerInput.dirty(
      lastChannelLoadingFrequencyValue,
      minValue: state.minFirstChannelLoadingFrequency,
      maxValue: state.maxLastChannelLoadingFrequency,
    );

    RangeFloatPointInput lastChannelLoadingLevel = RangeFloatPointInput.dirty(
      lastChannelLoadingLevelValue,
      minValue: 20.0,
      maxValue: 61.0,
    );

    RangeIntegerInput pilotFrequency1 = RangeIntegerInput.dirty(
      pilotFrequency1Value,
      minValue: state.minFirstChannelLoadingFrequency,
      maxValue: state.maxLastChannelLoadingFrequency,
    );

    RangeIntegerInput pilotFrequency2 = RangeIntegerInput.dirty(
      pilotFrequency2Value,
      minValue: state.minFirstChannelLoadingFrequency,
      maxValue: state.maxLastChannelLoadingFrequency,
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
        pilotFrequencyMode: event.pilotFrequencyMode,
        firstChannelLoadingFrequency: firstChannelLoadingFrequency,
        firstChannelLoadingLevel: firstChannelLoadingLevel,
        lastChannelLoadingFrequency: lastChannelLoadingFrequency,
        lastChannelLoadingLevel: lastChannelLoadingLevel,
        pilotFrequency1: pilotFrequency1,
        pilotFrequency2: pilotFrequency2,
      ),
    ));
  }

  void _onFirstChannelLoadingFrequencyChanged(
    FirstChannelLoadingFrequencyChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeIntegerInput firstChannelLoadingFrequency = RangeIntegerInput.dirty(
      event.firstChannelLoadingFrequency,
      minValue: state.minFirstChannelLoadingFrequency,
      maxValue: int.tryParse(state.lastChannelLoadingFrequency.value) ??
          state.maxLastChannelLoadingFrequency,
    );

    RangeIntegerInput lastChannelLoadingFrequency = RangeIntegerInput.dirty(
      state.lastChannelLoadingFrequency.value,
      minValue: int.tryParse(event.firstChannelLoadingFrequency) ??
          state.minFirstChannelLoadingFrequency,
      maxValue: state.maxLastChannelLoadingFrequency,
    );

    RangeIntegerInput pilotFrequency1 = RangeIntegerInput.dirty(
      state.pilotFrequency1.value,
      minValue: int.tryParse(event.firstChannelLoadingFrequency) ??
          state.minFirstChannelLoadingFrequency,
      maxValue: int.tryParse(state.pilotFrequency2.value) ??
          int.tryParse(state.lastChannelLoadingFrequency.value) ??
          state.maxLastChannelLoadingFrequency,
    );

    RangeIntegerInput pilotFrequency2 = RangeIntegerInput.dirty(
      state.pilotFrequency2.value,
      minValue: int.tryParse(state.pilotFrequency1.value) ??
          int.tryParse(event.firstChannelLoadingFrequency) ??
          state.minFirstChannelLoadingFrequency,
      maxValue: int.tryParse(state.lastChannelLoadingFrequency.value) ??
          state.maxLastChannelLoadingFrequency,
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
    Emitter<Setting18GraphModuleState> emit,
  ) {
    // 20.0 <= firstChannelLoadingLevel <= lastChannelLoadingLevel
    // 如果沒輸入 lastChannelLoadingLevel 時 lastChannelLoadingLevel <= 61.0
    RangeFloatPointInput firstChannelLoadingLevel = RangeFloatPointInput.dirty(
      event.firstChannelLoadingLevel,
      minValue: 20.0,
      maxValue: double.tryParse(state.lastChannelLoadingLevel.value) ?? 61.0,
    );

    // 輸入的起始頻率 <= event.lastChannelLoadingFrequency <= 1794
    // 起始頻率輸入內容不符時, 偵測到的splitOption的起始頻率 <= event.lastChannelLoadingFrequency
    RangeFloatPointInput lastChannelLoadingLevel = RangeFloatPointInput.dirty(
      state.lastChannelLoadingLevel.value,
      minValue: double.tryParse(
            event.firstChannelLoadingLevel,
          ) ??
          20.0,
      maxValue: 61.0,
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

  void _onLastChannelLoadingFrequencyChanged(
    LastChannelLoadingFrequencyChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeIntegerInput firstChannelLoadingFrequency = RangeIntegerInput.dirty(
      state.firstChannelLoadingFrequency.value,
      minValue: state.minFirstChannelLoadingFrequency,
      maxValue: int.tryParse(event.lastChannelLoadingFrequency) ??
          state.maxLastChannelLoadingFrequency,
    );

    RangeIntegerInput lastChannelLoadingFrequency = RangeIntegerInput.dirty(
      event.lastChannelLoadingFrequency,
      minValue: int.tryParse(state.firstChannelLoadingFrequency.value) ??
          state.minFirstChannelLoadingFrequency,
      maxValue: state.maxLastChannelLoadingFrequency,
    );

    RangeIntegerInput pilotFrequency1 = RangeIntegerInput.dirty(
      state.pilotFrequency1.value,
      minValue: int.tryParse(state.firstChannelLoadingFrequency.value) ??
          state.minFirstChannelLoadingFrequency,
      maxValue: int.tryParse(state.pilotFrequency2.value) ??
          int.tryParse(state.lastChannelLoadingFrequency.value) ??
          state.maxLastChannelLoadingFrequency,
    );

    RangeIntegerInput pilotFrequency2 = RangeIntegerInput.dirty(
      state.pilotFrequency2.value,
      minValue: int.tryParse(state.pilotFrequency1.value) ??
          int.tryParse(state.firstChannelLoadingFrequency.value) ??
          state.minFirstChannelLoadingFrequency,
      maxValue: int.tryParse(event.lastChannelLoadingFrequency) ??
          state.maxLastChannelLoadingFrequency,
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
    Emitter<Setting18GraphModuleState> emit,
  ) {
    // 20.0 <= firstChannelLoadingLevel <= lastChannelLoadingLevel
    // 如果沒輸入 lastChannelLoadingLevel 時 lastChannelLoadingLevel <= 61.0
    RangeFloatPointInput firstChannelLoadingLevel = RangeFloatPointInput.dirty(
      state.firstChannelLoadingLevel.value,
      minValue: 20.0,
      maxValue: double.tryParse(event.lastChannelLoadingLevel) ?? 61.0,
    );

    // 輸入的起始頻率 <= event.lastChannelLoadingFrequency <= 1794
    // 起始頻率輸入內容不符時, 偵測到的splitOption的起始頻率 <= event.lastChannelLoadingFrequency
    RangeFloatPointInput lastChannelLoadingLevel = RangeFloatPointInput.dirty(
      event.lastChannelLoadingLevel,
      minValue: double.tryParse(
            state.firstChannelLoadingLevel.value,
          ) ??
          20.0,
      maxValue: 61.0,
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
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeIntegerInput pilotFrequency1 = RangeIntegerInput.dirty(
      event.pilotFrequency1,
      minValue: int.tryParse(state.firstChannelLoadingFrequency.value) ??
          state.minFirstChannelLoadingFrequency,
      maxValue: int.tryParse(state.pilotFrequency2.value) ??
          int.tryParse(state.lastChannelLoadingFrequency.value) ??
          state.maxLastChannelLoadingFrequency,
    );

    RangeIntegerInput pilotFrequency2 = RangeIntegerInput.dirty(
      state.pilotFrequency2.value,
      minValue: int.tryParse(event.pilotFrequency1) ??
          int.tryParse(state.firstChannelLoadingFrequency.value) ??
          state.minFirstChannelLoadingFrequency,
      maxValue: int.tryParse(state.lastChannelLoadingFrequency.value) ??
          state.maxLastChannelLoadingFrequency,
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
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeIntegerInput pilotFrequency1 = RangeIntegerInput.dirty(
      state.pilotFrequency1.value,
      minValue: int.tryParse(state.firstChannelLoadingFrequency.value) ??
          state.minFirstChannelLoadingFrequency,
      maxValue: int.tryParse(event.pilotFrequency2) ??
          int.tryParse(state.lastChannelLoadingFrequency.value) ??
          state.maxLastChannelLoadingFrequency,
    );

    RangeIntegerInput pilotFrequency2 = RangeIntegerInput.dirty(
      event.pilotFrequency2,
      minValue: int.tryParse(state.pilotFrequency1.value) ??
          int.tryParse(state.firstChannelLoadingFrequency.value) ??
          state.minFirstChannelLoadingFrequency,
      maxValue: int.tryParse(state.lastChannelLoadingFrequency.value) ??
          state.maxLastChannelLoadingFrequency,
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
    Emitter<Setting18GraphModuleState> emit,
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
    Emitter<Setting18GraphModuleState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.alcMode);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      agcMode: event.alcMode,
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        alcMode: event.alcMode,
      ),
    ));
  }

  bool _isEnabledSubmission({
    Map<DataKey, RangeFloatPointInput>? targetValues,
    Map<DataKey, String>? targetIngressValues,
    RangeIntegerInput? firstChannelLoadingFrequency,
    RangeFloatPointInput? firstChannelLoadingLevel,
    RangeIntegerInput? lastChannelLoadingFrequency,
    RangeFloatPointInput? lastChannelLoadingLevel,
    String? pilotFrequencyMode,
    RangeIntegerInput? pilotFrequency1,
    RangeIntegerInput? pilotFrequency2,
    String? agcMode,
    String? alcMode,
  }) {
    targetValues ??= state.targetValues;
    targetIngressValues ??= state.targetIngressValues;
    firstChannelLoadingFrequency ??= state.firstChannelLoadingFrequency;
    firstChannelLoadingLevel ??= state.firstChannelLoadingLevel;
    lastChannelLoadingFrequency ??= state.lastChannelLoadingFrequency;
    lastChannelLoadingLevel ??= state.lastChannelLoadingLevel;
    pilotFrequencyMode ??= state.pilotFrequencyMode;
    pilotFrequency1 ??= state.pilotFrequency1;
    pilotFrequency2 ??= state.pilotFrequency2;
    agcMode ??= state.agcMode;
    alcMode ??= state.alcMode;

    bool isValid = false;

    if (pilotFrequencyMode == '0') {
      isValid = Formz.validate([
        ...targetValues.values.toList(),
        firstChannelLoadingFrequency,
        firstChannelLoadingLevel,
        lastChannelLoadingFrequency,
        lastChannelLoadingLevel,
      ]);
    } else if (pilotFrequencyMode == '1') {
      isValid = Formz.validate([
        ...targetValues.values.toList(),
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

    bool isChanged = false;

    if (isValid) {
      targetValues.forEach((dataKey, rangeFloatPointInput) {
        if (rangeFloatPointInput.value != state.initialValues[dataKey]) {
          isChanged = true;
        }
      });

      targetIngressValues.forEach((dataKey, value) {
        if (value != state.initialValues[dataKey]) {
          isChanged = true;
        }
      });

      if (firstChannelLoadingFrequency.value !=
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
          alcMode != state.initialValues[DataKey.alcMode]) {
        isChanged = true;
      }

      return isChanged;
    } else {
      return isChanged;
    }
  }

  String _getBoardBenchModeNameByFrequency({required int frequency}) {
    if (frequency <= 1218) {
      return BenchMode.frequency1p2G.name;
    } else {
      return BenchMode.frequency1p8G.name;
    }
  }

  Future<bool> _setBoardPilotFrequencyOnBenchMode({
    required String benchModeName,
  }) async {
    bool resultOfSetPilotFrequencyMode = false;
    bool resultOfSetLastChannelLoadingFrequency = false;
    if (benchModeName == BenchMode.frequency1p2G.name) {
      resultOfSetPilotFrequencyMode =
          await _amp18Repository.set1p8GPilotFrequencyMode('3');

      resultOfSetLastChannelLoadingFrequency =
          await _amp18Repository.set1p8GLastChannelLoadingFrequency('1218');
    } else {
      resultOfSetPilotFrequencyMode =
          await _amp18Repository.set1p8GPilotFrequencyMode('3');

      resultOfSetLastChannelLoadingFrequency =
          await _amp18Repository.set1p8GLastChannelLoadingFrequency('1794');
    }
    return resultOfSetPilotFrequencyMode &&
        resultOfSetLastChannelLoadingFrequency;
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18GraphModuleState> emit,
  ) async {
    emit(state.copyWith(
      isInitialize: false,
      isInitialPilotFrequencyLevelValues: false,
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    List<String> settingResult = [];
    List<DataKey> changedSettingItem = [];

    state.targetValues.forEach((dataKey, rangeFloatPointInput) {
      if (rangeFloatPointInput.value != state.initialValues[dataKey]) {
        changedSettingItem.add(dataKey);
      }
    });

    state.targetIngressValues.forEach((dataKey, value) {
      if (value != state.initialValues[dataKey]) {
        changedSettingItem.add(dataKey);
      }
    });

    for (DataKey dataKey in changedSettingItem) {
      if (dataKey == DataKey.dsVVA1) {
        bool resultOfSetDSVVA1 = await _amp18Repository
            .set1p8GDSVVA1(state.targetValues[dataKey]!.value);

        settingResult.add('${DataKey.dsVVA1.name},$resultOfSetDSVVA1');
      }
      if (dataKey == DataKey.dsVVA4) {
        bool resultOfSetDSVVA4 = await _amp18Repository
            .set1p8GDSVVA4(state.targetValues[dataKey]!.value);

        settingResult.add('${DataKey.dsVVA4.name},$resultOfSetDSVVA4');
      }

      if (dataKey == DataKey.dsVVA5) {
        bool resultOfSetDSVVA5 = await _amp18Repository
            .set1p8GDSVVA5(state.targetValues[dataKey]!.value);

        settingResult.add('${DataKey.dsVVA5.name},$resultOfSetDSVVA5');
      }

      if (dataKey == DataKey.dsSlope1) {
        bool resultOfSetDSSlope1 = await _amp18Repository
            .set1p8GDSSlope1(state.targetValues[dataKey]!.value);

        settingResult.add('${DataKey.dsSlope1.name},$resultOfSetDSSlope1');
      }

      if (dataKey == DataKey.dsSlope3) {
        bool resultOfSetDSSlope3 = await _amp18Repository
            .set1p8GDSSlope3(state.targetValues[dataKey]!.value);

        settingResult.add('${DataKey.dsSlope3.name},$resultOfSetDSSlope3');
      }

      if (dataKey == DataKey.dsSlope4) {
        bool resultOfSetDSSlope4 = await _amp18Repository
            .set1p8GDSSlope4(state.targetValues[dataKey]!.value);

        settingResult.add('${DataKey.dsSlope4.name},$resultOfSetDSSlope4');
      }

      if (dataKey == DataKey.usVCA1) {
        bool resultOfSetUSVCA1Cmd = await _amp18Repository
            .set1p8GUSVCA1(state.targetValues[dataKey]!.value);

        settingResult.add('${DataKey.usVCA1.name},$resultOfSetUSVCA1Cmd');
      }

      if (dataKey == DataKey.usVCA2) {
        bool resultOfSetUSVCA2 = await _amp18Repository
            .set1p8GUSVCA2(state.targetValues[dataKey]!.value);

        settingResult.add('${DataKey.usVCA2.name},$resultOfSetUSVCA2');
      }

      if (dataKey == DataKey.usVCA3) {
        bool resultOfSetUSVCA3 = await _amp18Repository
            .set1p8GUSVCA3(state.targetValues[dataKey]!.value);

        settingResult.add('${DataKey.usVCA3.name},$resultOfSetUSVCA3');
      }

      if (dataKey == DataKey.usVCA4) {
        bool resultOfSetUSVCA4 = await _amp18Repository
            .set1p8GUSVCA4(state.targetValues[dataKey]!.value);

        settingResult.add('${DataKey.usVCA4.name},$resultOfSetUSVCA4');
      }

      if (dataKey == DataKey.eREQ) {
        bool resultOfSetEREQ = await _amp18Repository
            .set1p8GEREQ(state.targetValues[dataKey]!.value);

        settingResult.add('${DataKey.eREQ.name},$resultOfSetEREQ');
      }

      if (dataKey == DataKey.ingressSetting2) {
        bool resultOfSetReturnIngress2 = await _amp18Repository
            .set1p8GReturnIngress2(state.targetIngressValues[dataKey]!);

        settingResult
            .add('${DataKey.ingressSetting2.name},$resultOfSetReturnIngress2');
      }

      if (dataKey == DataKey.ingressSetting3) {
        bool resultOfSetReturnIngress3 = await _amp18Repository
            .set1p8GReturnIngress3(state.targetIngressValues[dataKey]!);

        settingResult
            .add('${DataKey.ingressSetting3.name},$resultOfSetReturnIngress3');
      }

      if (dataKey == DataKey.ingressSetting4) {
        bool resultOfSetReturnIngress4 = await _amp18Repository
            .set1p8GReturnIngress4(state.targetIngressValues[dataKey]!);

        settingResult
            .add('${DataKey.ingressSetting4.name},$resultOfSetReturnIngress4');
      }
    }

    // if (state.tgcCableLength != state.initialValues[DataKey.tgcCableLength]) {
    //   bool resultOfSetTGCCableLength =
    //       await _amp18Repository.set1p8GTGCCableLength(state.tgcCableLength);

    //   settingResult
    //       .add('${DataKey.tgcCableLength.name},$resultOfSetTGCCableLength');
    // }

    // if (state.usTGC != state.initialValues[DataKey.usTGC]) {
    //   bool resultOfSetUSTGC = await _amp18Repository.set1p8USTGC(state.usTGC);

    //   settingResult.add('${DataKey.usTGC.name},$resultOfSetUSTGC');
    // }

    // if (state.splitOption != state.initialValues[DataKey.splitOption]) {
    //   bool resultOfSetSplitOption =
    //       await _amp18Repository.set1p8GSplitOption(state.splitOption);

    //   settingResult.add('${DataKey.splitOption.name},$resultOfSetSplitOption');
    // }

    if (state.pilotFrequencyMode !=
        state.initialValues[DataKey.pilotFrequencyMode]) {
      if (state.eqType == EQType.board &&
          (state.pilotFrequencyMode == BenchMode.frequency1p2G.name ||
              state.pilotFrequencyMode == BenchMode.frequency1p8G.name)) {
        // 在 bench mode 下設定 lastChannelLoadingFrequency
        bool resultOfSetBoardPilotFrequencyMode =
            await _setBoardPilotFrequencyOnBenchMode(
          benchModeName: state.pilotFrequencyMode,
        );

        settingResult.add(
            '${DataKey.pilotFrequencyMode.name},$resultOfSetBoardPilotFrequencyMode');
      } else {
        bool resultOfSetPilotFrequencyMode = await _amp18Repository
            .set1p8GPilotFrequencyMode(state.pilotFrequencyMode);

        settingResult.add(
            '${DataKey.pilotFrequencyMode.name},$resultOfSetPilotFrequencyMode');
      }
    }

    if (state.firstChannelLoadingFrequency.value !=
        state.initialValues[DataKey.firstChannelLoadingFrequency]) {
      bool resultOfSetFirstChannelLoadingFrequency =
          await _amp18Repository.set1p8GFirstChannelLoadingFrequency(
              state.firstChannelLoadingFrequency.value);

      settingResult.add(
          '${DataKey.firstChannelLoadingFrequency.name},$resultOfSetFirstChannelLoadingFrequency');
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

    // 等待 device 完成更新後在讀取值
    await Future.delayed(const Duration(milliseconds: 1000));

    await _amp18Repository.updateCharacteristics();

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
      enableSubmission: false,
      isInitialize: true,
      tappedSet: const {},
      initialValues: _amp18Repository.characteristicDataCache,
    ));
  }
}
