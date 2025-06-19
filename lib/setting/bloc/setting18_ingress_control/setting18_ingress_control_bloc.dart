import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/setting_items_table.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_ingress_control_event.dart';
part 'setting18_ingress_control_state.dart';

class Setting18IngressControlBloc
    extends Bloc<Setting18IngressControlEvent, Setting18IngressControlState> {
  Setting18IngressControlBloc({
    required Amp18Repository amp18Repository,
  })  : _amp18Repository = amp18Repository,
        super(const Setting18IngressControlState()) {
    on<Initialized>(_onInitialized);
    on<ControlItemChanged>(_onControlItemChanged);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);
  }

  final Amp18Repository _amp18Repository;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18IngressControlState> emit,
  ) async {
    if (!event.useCache) {
      await _amp18Repository.updateSettingCharacteristics();
    }

    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    Map<DataKey, String> initialValues = {};
    Map<DataKey, String> targetValues = {};

    String partId = characteristicDataCache[DataKey.partId] ?? '';

    if (partId.isNotEmpty) {
      Map<Enum, DataKey> ingressControlMap =
          SettingItemTable.controlItemDataMapCollection[partId]![2];

      ingressControlMap.forEach((name, dataKey) {
        initialValues[dataKey] = characteristicDataCache[dataKey]!;

        targetValues[dataKey] = characteristicDataCache[dataKey]!;
      });
    }

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      initialValues: initialValues,
      targetValues: targetValues,
      editMode: false,
      enableSubmission: false,
      tappedSet: const {},
      settingResult: const [],
    ));
  }

  void _onControlItemChanged(
    ControlItemChanged event,
    Emitter<Setting18IngressControlState> emit,
  ) {
    Map<DataKey, String> targetValues =
        Map<DataKey, String>.from(state.targetValues);

    targetValues[event.dataKey] = event.value;

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
    Map<DataKey, String>? targetValues,
  }) {
    targetValues ??= state.targetValues;

    bool isChanged = false;

    targetValues.forEach((dataKey, value) {
      if (value != state.initialValues[dataKey]) {
        isChanged = true;
      }
    });

    return isChanged;
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18IngressControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      editMode: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<Setting18IngressControlState> emit,
  ) {
    Map<DataKey, String> targetValues = {};

    for (MapEntry entry in state.initialValues.entries) {
      DataKey dataKey = entry.key;
      String value = entry.value;

      targetValues[dataKey] = value;
    }

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      editMode: false,
      enableSubmission: false,
      targetValues: targetValues,
      tappedSet: {},
    ));
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18IngressControlState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    List<String> settingResult = [];
    List<DataKey> changedSettingItem = [];

    state.targetValues.forEach((dataKey, value) {
      if (value != state.initialValues[dataKey]) {
        changedSettingItem.add(dataKey);
      }
    });

    for (DataKey dataKey in changedSettingItem) {
      if (dataKey == DataKey.ingressSetting2) {
        bool resultOfSetReturnIngress2 = await _amp18Repository
            .set1p8GReturnIngress2(state.targetValues[dataKey]!);

        settingResult
            .add('${DataKey.ingressSetting2.name},$resultOfSetReturnIngress2');
      }

      if (dataKey == DataKey.ingressSetting3) {
        bool resultOfSetReturnIngress3 = await _amp18Repository
            .set1p8GReturnIngress3(state.targetValues[dataKey]!);

        settingResult
            .add('${DataKey.ingressSetting3.name},$resultOfSetReturnIngress3');
      }

      if (dataKey == DataKey.ingressSetting4) {
        bool resultOfSetReturnIngress4 = await _amp18Repository
            .set1p8GReturnIngress4(state.targetValues[dataKey]!);

        settingResult
            .add('${DataKey.ingressSetting4.name},$resultOfSetReturnIngress4');
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
