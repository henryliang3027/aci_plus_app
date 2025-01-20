import 'dart:async';

import 'package:aci_plus_app/core/control_item_value.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:aci_plus_app/setting/model/formz_input_initializer.dart';
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
    // on<DSVVA1Changed>(_onDSVVA1Changed);
    // on<DSVVA2Changed>(_onDSVVA2Changed);
    // on<DSVVA3Changed>(_onDSVVA3Changed);
    // on<DSVVA4Changed>(_onDSVVA4Changed);
    // on<DSVVA5Changed>(_onDSVVA5Changed);
    // on<DSSlope1Changed>(_onDSSlope1Changed);
    // on<DSSlope2Changed>(_onDSSlope2Changed);
    // on<DSSlope3Changed>(_onDSSlope3Changed);
    // on<DSSlope4Changed>(_onDSSlope4Changed);
    // on<TGCCableLengthChanged>(_onTGCCableLengthChanged);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);

    add(const Initialized());

    _forwardCEQStateSubscription =
        _amp18Repository.forwardCEQStateStream.listen((bool isChanged) {
      add(const Initialized(useCache: false));
    });
  }

  final Amp18Repository _amp18Repository;
  late final StreamSubscription _forwardCEQStateSubscription;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18ForwardControlState> emit,
  ) async {
    if (!event.useCache) {
      await _amp18Repository.updateSettingCharacteristics();
    }

    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    // 當斷線的時候重新初始化時讀取 map 元素會有 null 的情況, null 時就 assign 空字串
    String splitOption =
        characteristicDataCache[DataKey.currentDetectedSplitOption] ?? '';
    String partId = characteristicDataCache[DataKey.partId] ?? '';
    String operatingMode = getOperatingModeFromForwardCEQIndex(
        characteristicDataCache[DataKey.forwardCEQIndex] ?? '');

    Map<DataKey, MinMax> values = {};

    if (operatingMode.isNotEmpty &&
        splitOption.isNotEmpty &&
        splitOption != '0' && // '0' indicates no DFU
        partId.isNotEmpty) {
      values = ControlItemValue
          .allValueCollections[operatingMode]![splitOption]![int.parse(partId)];
    }

    Map<Enum, DataKey> forwardControlMap =
        SettingItemTable.controlItemDataMapCollection[partId]![0];

    Map<DataKey, String> initialValues = {};
    Map<DataKey, RangeFloatPointInput> targetValues = {};

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

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      initialValues: initialValues,
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
      targetValues: targetValues,
      tappedSet: {},
    ));
  }

  bool _isEnabledSubmission({
    Map<DataKey, RangeFloatPointInput>? targetValues,
  }) {
    targetValues ??= state.targetValues;

    if (targetValues.isNotEmpty) {
      bool isValid = Formz.validate(targetValues.values.toList());
      bool isChanged = false;

      if (isValid) {
        targetValues.forEach((dataKey, rangeFloatPointInput) {
          if (rangeFloatPointInput.value != state.initialValues[dataKey]) {
            isChanged = true;
          }
        });
      }

      return isChanged;
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

  @override
  Future<void> close() {
    _forwardCEQStateSubscription.cancel();
    return super.close();
  }
}
