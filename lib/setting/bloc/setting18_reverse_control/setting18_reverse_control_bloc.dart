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

part 'setting18_reverse_control_event.dart';
part 'setting18_reverse_control_state.dart';

class Setting18ReverseControlBloc
    extends Bloc<Setting18ReverseControlEvent, Setting18ReverseControlState> {
  Setting18ReverseControlBloc({
    required Amp18Repository amp18Repository,
  })  : _amp18Repository = amp18Repository,
        super(const Setting18ReverseControlState()) {
    on<Initialized>(_onInitialized);
    on<ResetReverseValuesRequested>(_onResetReverseValuesRequested);
    on<ControlItemChanged>(_onControlItemChanged);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);

    add(const Initialized());
  }

  final Amp18Repository _amp18Repository;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18ReverseControlState> emit,
  ) async {
    if (!event.useCache) {
      await _amp18Repository.updateSettingCharacteristics();
    }

    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    // splitOption = '0' 代表沒有 DFU
    String splitOption =
        characteristicDataCache[DataKey.currentDetectedSplitOption] ?? '0';
    String partId = characteristicDataCache[DataKey.partId] ?? '';
    String operatingMode = getOperatingModeFromForwardCEQIndex(
        characteristicDataCache[DataKey.forwardCEQIndex] ?? '');

    Map<DataKey, String> initialValues = {};
    Map<DataKey, RangeFloatPointInput> targetValues = {};
    Map<DataKey, MinMax> values = {};

    if (partId.isNotEmpty) {
      values = ControlItemValue
          .allValueCollections[operatingMode]![splitOption]![partId]!;

      Map<Enum, DataKey> reverseControlMap =
          SettingItemTable.controlItemDataMapCollection[partId]![1];

      reverseControlMap.forEach((name, dataKey) {
        initialValues[dataKey] = characteristicDataCache[dataKey]!;

        MinMax minMax = values[dataKey]!;
        RangeFloatPointInput rangeFloatPointInput = RangeFloatPointInput.dirty(
          characteristicDataCache[dataKey]!,
          minValue: minMax.min,
          maxValue: minMax.max,
        );

        targetValues[dataKey] = rangeFloatPointInput;
      });
    }
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      initialValues: initialValues,
      targetValues: targetValues,
      editMode: false,
      enableSubmission: false,
      tappedSet: const {},
      settingResult: const [],
    ));
  }

  void _onResetReverseValuesRequested(
    ResetReverseValuesRequested event,
    Emitter<Setting18ReverseControlState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.submissionInProgress,
    ));

    bool result =
        await _amp18Repository.set1p8GFactoryDefault(34); // load upstream only

    if (result) {
      // 等待 device 完成更新後在讀取值
      await Future.delayed(const Duration(milliseconds: 1000));
      await _amp18Repository.updateCharacteristics();

      emit(state.copyWith(
        resetReverseValuesSubmissionStatus: SubmissionStatus.submissionSuccess,
        editMode: false,
      ));
    } else {
      emit(state.copyWith(
        resetReverseValuesSubmissionStatus: SubmissionStatus.submissionFailure,
        editMode: false,
      ));
    }
  }

  void _onControlItemChanged(
    ControlItemChanged event,
    Emitter<Setting18ReverseControlState> emit,
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

  bool _isEnabledSubmission({
    Map<DataKey, RangeFloatPointInput>? targetValues,
  }) {
    targetValues ??= state.targetValues;

    bool isValid = false;
    bool isChanged = false;

    if (targetValues.isNotEmpty) {
      isValid = Formz.validate(targetValues.values.toList());
    }

    if (isValid) {
      targetValues.forEach((dataKey, rangeFloatPointInput) {
        if (rangeFloatPointInput.value != state.initialValues[dataKey]) {
          isChanged = true;
        }
      });
    }

    return isChanged;
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18ReverseControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      editMode: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<Setting18ReverseControlState> emit,
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
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      editMode: false,
      enableSubmission: false,
      targetValues: targetValues,
      tappedSet: {},
    ));
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18ReverseControlState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    List<String> settingResult = [];
    List<DataKey> changedSettingItem = [];

    state.targetValues.forEach((dataKey, rangeFloatPointInput) {
      if (rangeFloatPointInput.value != state.initialValues[dataKey]) {
        changedSettingItem.add(dataKey);
      }
    });

    for (DataKey dataKey in changedSettingItem) {
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
