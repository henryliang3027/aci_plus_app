import 'dart:async';

import 'package:aci_plus_app/core/control_item_value.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'setting18_forward_control_event.dart';
part 'setting18_forward_control_state.dart';

class Setting18ForwardControlBloc
    extends Bloc<Setting18ForwardControlEvent, Setting18ForwardControlState> {
  Setting18ForwardControlBloc({
    required Amp18Repository amp18Repository,
  })  : _amp18Repository = amp18Repository,
        super(const Setting18ForwardControlState()) {
    on<Initialized>(_onInitialized);
    on<ResetForwardValuesRequested>(_onResetForwardValuesRequested);
    on<ControlItemChanged>(_onControlItemChanged);
    // on<FirstChannelLoadingFrequencyChanged>(
    //     _onFirstChannelLoadingFrequencyChanged);
    on<FirstChannelLoadingLevelChanged>(_onFirstChannelLoadingLevelChanged);
    // on<LastChannelLoadingFrequencyChanged>(
    //     _onLastChannelLoadingFrequencyChanged);
    on<LastChannelLoadingLevelChanged>(_onLastChannelLoadingLevelChanged);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);

    add(const Initialized());
  }

  final Amp18Repository _amp18Repository;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18ForwardControlState> emit,
  ) async {
    if (!event.useCache) {
      await _amp18Repository.updateSettingCharacteristics();
    }

    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    Map<DataKey, String> initialValues = {};
    Map<DataKey, RangeFloatPointInput> targetValues = {};

    // 當斷線的時候重新初始化時讀取 map 元素會有 null 的情況, null 時就 assign 空字串
    String splitOption =
        characteristicDataCache[DataKey.currentDetectedSplitOption] ?? '';
    String partId = characteristicDataCache[DataKey.partId] ?? '';
    String operatingMode = getOperatingModeFromForwardCEQIndex(
        characteristicDataCache[DataKey.forwardCEQIndex] ?? '');

    String firstChannelLoadingFrequency =
        characteristicDataCache[DataKey.firstChannelLoadingFrequency] ?? '';
    String lastChannelLoadingFrequency =
        characteristicDataCache[DataKey.lastChannelLoadingFrequency] ?? '';
    String firstChannelLoadingLevel =
        characteristicDataCache[DataKey.firstChannelLoadingLevel] ?? '';
    String lastChannelLoadingLevel =
        characteristicDataCache[DataKey.lastChannelLoadingLevel] ?? '';

    initialValues[DataKey.firstChannelLoadingFrequency] =
        firstChannelLoadingFrequency;
    initialValues[DataKey.lastChannelLoadingFrequency] =
        lastChannelLoadingFrequency;
    initialValues[DataKey.firstChannelLoadingLevel] = firstChannelLoadingLevel;
    initialValues[DataKey.lastChannelLoadingLevel] = lastChannelLoadingLevel;

    Map<DataKey, MinMax> values = {};

    if (operatingMode.isNotEmpty &&
        splitOption.isNotEmpty &&
        splitOption != '0' && // '0' indicates no DFU
        partId.isNotEmpty) {
      print(ControlItemValue.allValueCollections[operatingMode]![splitOption]!);

      values = ControlItemValue
          .allValueCollections[operatingMode]![splitOption]![partId]!;

      Map<Enum, DataKey> forwardControlMap =
          SettingItemTable.controlItemDataMapCollection[partId]![0];

      forwardControlMap.forEach((name, dataKey) {
        MinMax minMax = values[dataKey]!;
        RangeFloatPointInput rangeFloatPointInput = RangeFloatPointInput.dirty(
          characteristicDataCache[dataKey]!,
          minValue: minMax.min,
          maxValue: minMax.max,
        );

        targetValues[dataKey] = rangeFloatPointInput;
        initialValues[dataKey] = characteristicDataCache[dataKey]!;
      });
    }

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      initialValues: initialValues,
      firstChannelLoadingFrequency:
          RangeIntegerInput.dirty(firstChannelLoadingFrequency),
      firstChannelLoadingLevel:
          RangeFloatPointInput.dirty(firstChannelLoadingLevel),
      lastChannelLoadingFrequency:
          RangeIntegerInput.dirty(lastChannelLoadingFrequency),
      lastChannelLoadingLevel:
          RangeFloatPointInput.dirty(lastChannelLoadingLevel),
      targetValues: targetValues,
      editMode: false,
      enableSubmission: false,
      tappedSet: const {},
      settingResult: const [],
    ));
  }

  void _onResetForwardValuesRequested(
    ResetForwardValuesRequested event,
    Emitter<Setting18ForwardControlState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.submissionInProgress,
    ));

    bool result = await _amp18Repository
        .set1p8GFactoryDefault(43); // load downstream only

    if (result) {
      // 等待 device 完成更新後在讀取值
      await Future.delayed(const Duration(milliseconds: 1000));
      await _amp18Repository.updateCharacteristics();

      emit(state.copyWith(
        resetForwardValuesSubmissionStatus: SubmissionStatus.submissionSuccess,
        editMode: false,
      ));
    } else {
      emit(state.copyWith(
        resetForwardValuesSubmissionStatus: SubmissionStatus.submissionFailure,
        editMode: false,
      ));
    }
  }

  void _onControlItemChanged(
    ControlItemChanged event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
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
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        targetValues: targetValues,
      ),
    ));
  }

  // void _onFirstChannelLoadingFrequencyChanged(
  //   FirstChannelLoadingFrequencyChanged event,
  //   Emitter<Setting18ForwardControlState> emit,
  // ) {
  //   // 根據 偵測到的 splitOption 來決定 minimum forwardStartFrequency 和 maximum forwardStopFrequency
  //   int minForwardStartFrequency = _getMinForwardStartFrequency();
  //   int maxForwardStopFrequency = _getMaxForwardStopFrequency();

  //   // 偵測到的 splitOption的起始頻率 <= firstChannelLoadingFrequency <= lastChannelLoadingFrequency
  //   // 截止頻率輸入內容不符時即 int.tryParse(state.lastChannelLoadingFrequency.value) 回傳 null,
  //   // 則判斷方式為: 偵測到的splitOption的起始頻率 <= firstChannelLoadingFrequency <= maxForwardStopFrequency
  //   RangeIntegerInput firstChannelLoadingFrequency = RangeIntegerInput.dirty(
  //     event.firstChannelLoadingFrequency,
  //     minValue: minForwardStartFrequency,
  //     maxValue: int.tryParse(state.lastChannelLoadingFrequency.value) ??
  //         maxForwardStopFrequency,
  //   );

  //   // firstChannelLoadingFrequency <= lastChannelLoadingFrequency <= maxForwardStopFrequency
  //   // 起始頻率輸入內容不符時即 int.tryParse(state.firstChannelLoadingFrequency.value) 回傳 null,
  //   // 則判斷方式為: minForwardStartFrequency <= lastChannelLoadingFrequency <= maxForwardStopFrequency
  //   RangeIntegerInput lastChannelLoadingFrequency = RangeIntegerInput.dirty(
  //     state.lastChannelLoadingFrequency.value,
  //     minValue: int.tryParse(event.firstChannelLoadingFrequency) ??
  //         minForwardStartFrequency,
  //     maxValue: maxForwardStopFrequency,
  //   );

  //   Set<DataKey> tappedSet = Set.from(state.tappedSet);
  //   tappedSet.add(DataKey.firstChannelLoadingFrequency);

  //   emit(state.copyWith(
  //     submissionStatus: SubmissionStatus.none,
  //     firstChannelLoadingFrequency: firstChannelLoadingFrequency,
  //     lastChannelLoadingFrequency: lastChannelLoadingFrequency,
  //     tappedSet: tappedSet,
  //     enableSubmission: _isEnabledSubmission(
  //       firstChannelLoadingFrequency: firstChannelLoadingFrequency,
  //       lastChannelLoadingFrequency: lastChannelLoadingFrequency,
  //     ),
  //   ));
  // }

  void _onFirstChannelLoadingLevelChanged(
    FirstChannelLoadingLevelChanged event,
    Emitter<Setting18ForwardControlState> emit,
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
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        firstChannelLoadingLevel: firstChannelLoadingLevel,
        lastChannelLoadingLevel: lastChannelLoadingLevel,
      ),
    ));
  }

  // 參照 _onFirstChannelLoadingFrequencyChanged 的邏輯來設定各個 frequency 上下限
  // void _onLastChannelLoadingFrequencyChanged(
  //   LastChannelLoadingFrequencyChanged event,
  //   Emitter<Setting18ForwardControlState> emit,
  // ) {
  //   int minForwardStartFrequency = _getMinForwardStartFrequency();
  //   int maxForwardStopFrequency = _getMaxForwardStopFrequency();

  //   RangeIntegerInput firstChannelLoadingFrequency = RangeIntegerInput.dirty(
  //     state.firstChannelLoadingFrequency.value,
  //     minValue: minForwardStartFrequency,
  //     maxValue: int.tryParse(event.lastChannelLoadingFrequency) ??
  //         maxForwardStopFrequency,
  //   );

  //   RangeIntegerInput lastChannelLoadingFrequency = RangeIntegerInput.dirty(
  //     event.lastChannelLoadingFrequency,
  //     minValue: int.tryParse(state.firstChannelLoadingFrequency.value) ??
  //         minForwardStartFrequency,
  //     maxValue: maxForwardStopFrequency,
  //   );

  //   Set<DataKey> tappedSet = Set.from(state.tappedSet);
  //   tappedSet.add(DataKey.lastChannelLoadingFrequency);

  //   emit(state.copyWith(
  //     submissionStatus: SubmissionStatus.none,
  //     firstChannelLoadingFrequency: firstChannelLoadingFrequency,
  //     lastChannelLoadingFrequency: lastChannelLoadingFrequency,
  //     tappedSet: tappedSet,
  //     enableSubmission: _isEnabledSubmission(
  //       firstChannelLoadingFrequency: firstChannelLoadingFrequency,
  //       lastChannelLoadingFrequency: lastChannelLoadingFrequency,
  //     ),
  //   ));
  // }

  void _onLastChannelLoadingLevelChanged(
    LastChannelLoadingLevelChanged event,
    Emitter<Setting18ForwardControlState> emit,
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
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        firstChannelLoadingLevel: firstChannelLoadingLevel,
        lastChannelLoadingLevel: lastChannelLoadingLevel,
      ),
    ));
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      editMode: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    Map<DataKey, RangeFloatPointInput> targetValues = {};

    for (MapEntry entry in state.initialValues.entries) {
      DataKey dataKey = entry.key;
      String value = entry.value;

      if (dataKey == DataKey.firstChannelLoadingFrequency ||
          dataKey == DataKey.lastChannelLoadingFrequency ||
          dataKey == DataKey.firstChannelLoadingLevel ||
          dataKey == DataKey.lastChannelLoadingLevel) {
        continue;
      }

      RangeFloatPointInput rangeFloatPointInput = RangeFloatPointInput.dirty(
        value,
        minValue: state.targetValues[dataKey]!.minValue,
        maxValue: state.targetValues[dataKey]!.maxValue,
      );

      targetValues[dataKey] = rangeFloatPointInput;
    }

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      editMode: false,
      enableSubmission: false,
      firstChannelLoadingLevel: RangeFloatPointInput.dirty(
          state.initialValues[DataKey.firstChannelLoadingLevel] ?? ''),
      lastChannelLoadingLevel: RangeFloatPointInput.dirty(
          state.initialValues[DataKey.lastChannelLoadingLevel] ?? ''),
      targetValues: targetValues,
      tappedSet: {},
    ));
  }

  bool _isEnabledSubmission({
    RangeFloatPointInput? firstChannelLoadingLevel,
    RangeFloatPointInput? lastChannelLoadingLevel,
    Map<DataKey, RangeFloatPointInput>? targetValues,
  }) {
    firstChannelLoadingLevel ??= state.firstChannelLoadingLevel;
    lastChannelLoadingLevel ??= state.lastChannelLoadingLevel;
    targetValues ??= state.targetValues;

    bool isValid = Formz.validate([
      ...targetValues.values.toList(),
      firstChannelLoadingLevel,
      lastChannelLoadingLevel,
    ]);

    if (isValid) {
      bool isForwardValueChanged = false;
      bool isRegulationValueChanged = false;
      targetValues.forEach((dataKey, rangeFloatPointInput) {
        if (rangeFloatPointInput.value != state.initialValues[dataKey]) {
          isForwardValueChanged = true;
        }
      });

      if (firstChannelLoadingLevel.value !=
              state.initialValues[DataKey.firstChannelLoadingLevel] ||
          lastChannelLoadingLevel.value !=
              state.initialValues[DataKey.lastChannelLoadingLevel]) {
        isRegulationValueChanged = true;
      }
      return isForwardValueChanged || isRegulationValueChanged;
    } else {
      return false;
    }
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18ForwardControlState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    // 按照畫面上的排列順序依序檢查是否值有改變, 如果有變就進行設定
    List<String> settingResult = [];
    List<DataKey> changedSettingItem = [];

    // 檢查 Regulation 設定值有沒有改變, 如果有變就進行設定
    if (state.firstChannelLoadingLevel.value !=
        state.initialValues[DataKey.firstChannelLoadingLevel]) {
      bool resultOfSetFirstChannelLoadingLevel =
          await _amp18Repository.set1p8GFirstChannelLoadingLevel(
              state.firstChannelLoadingLevel.value);

      settingResult.add(
          '${DataKey.firstChannelLoadingLevel.name},$resultOfSetFirstChannelLoadingLevel');
    }

    if (state.lastChannelLoadingLevel.value !=
        state.initialValues[DataKey.lastChannelLoadingLevel]) {
      bool resultOfSetLastChannelLoadingLevel = await _amp18Repository
          .set1p8GLastChannelLoadingLevel(state.lastChannelLoadingLevel.value);

      settingResult.add(
          '${DataKey.lastChannelLoadingLevel.name},$resultOfSetLastChannelLoadingLevel');
    }

    // 檢查 Forward port 設定值有沒有改變, 如果有變就進行設定
    state.targetValues.forEach((dataKey, rangeFloatPointInput) {
      if (rangeFloatPointInput.value != state.initialValues[dataKey]) {
        changedSettingItem.add(dataKey);
      }
    });

    for (DataKey dataKey in changedSettingItem) {
      if (dataKey == DataKey.dsVVA1) {
        bool resultOfSetDSVVA1 = await _amp18Repository
            .set1p8GDSVVA1(state.targetValues[dataKey]!.value);

        settingResult.add('${DataKey.dsVVA1.name},$resultOfSetDSVVA1');
      }

      if (dataKey == DataKey.dsVVA2) {
        bool resultOfSetDSVVA2 = await _amp18Repository
            .set1p8GDSVVA2(state.targetValues[dataKey]!.value);

        settingResult.add('${DataKey.dsVVA2.name},$resultOfSetDSVVA2');
      }

      if (dataKey == DataKey.dsVVA3) {
        bool resultOfSetDSVVA3 = await _amp18Repository
            .set1p8DSVVA3(state.targetValues[dataKey]!.value);

        settingResult.add('${DataKey.dsVVA3.name},$resultOfSetDSVVA3');
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

      if (dataKey == DataKey.dsSlope2) {
        bool resultOfSetDSSlope2 = await _amp18Repository
            .set1p8GDSSlope2(state.targetValues[dataKey]!.value);

        settingResult.add('${DataKey.dsSlope2.name},$resultOfSetDSSlope2');
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
