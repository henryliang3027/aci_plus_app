import 'dart:async';

import 'package:aci_plus_app/core/control_item_value.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:aci_plus_app/setting/model/formz_input_initializer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    on<USVCA1Changed>(_onUSVCA1Changed);
    on<USVCA2Changed>(_onUSVCA2Changed);
    on<USVCA3Changed>(_onUSVCA3Changed);
    on<USVCA4Changed>(_onUSVCA4Changed);
    on<EREQChanged>(_onEREQChanged);
    on<RtnIngressSetting2Changed>(_onRtnIngressSetting2Changed);
    on<RtnIngressSetting3Changed>(_onRtnIngressSetting3Changed);
    on<RtnIngressSetting4Changed>(_onRtnIngressSetting4Changed);
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
    Emitter<Setting18ReverseControlState> emit,
  ) async {
    if (!event.useCache) {
      await _amp18Repository.updateSettingCharacteristics();
    }

    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    // ex: C-coe LE 沒有 VCA3, VCA4, 讀到的值是 -0.1, 不符合範圍, 所以改成 0.0 作為初始值
    characteristicDataCache.forEach((key, value) {
      if (value == '-0.1') {
        characteristicDataCache[key] = '0.0';
      }
    });

// 當斷線的時候重新初始化時讀取 map 元素會有 null 的情況, null 時就 assign 空字串
    String splitOption = characteristicDataCache[DataKey.splitOption] ?? '';
    String partId = characteristicDataCache[DataKey.partId] ?? '';
    String operatingMode = getOperatingModeFromForwardCEQIndex(
        characteristicDataCache[DataKey.forwardCEQIndex] ?? '');

    Map<DataKey, MinMax> values = {};

    if (operatingMode.isNotEmpty &&
        splitOption.isNotEmpty &&
        partId.isNotEmpty) {
      values = ControlItemValue
          .allValueCollections[operatingMode]![splitOption]![int.parse(partId)];
    }

    MinMax usVCA1MinMax = values[DataKey.usVCA1] ??
        MinMax(
          min: state.usVCA1.minValue,
          max: state.usVCA1.maxValue,
        );
    RangeFloatPointInput usVCA1 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.usVCA1] ?? '',
      minValue: usVCA1MinMax.min,
      maxValue: usVCA1MinMax.max,
    );

    MinMax usVCA2MinMax = values[DataKey.usVCA2] ??
        MinMax(
          min: state.usVCA2.minValue,
          max: state.usVCA2.maxValue,
        );
    RangeFloatPointInput usVCA2 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.usVCA2] ?? '',
      minValue: usVCA2MinMax.min,
      maxValue: usVCA2MinMax.max,
    );

    MinMax usVCA3MinMax = values[DataKey.usVCA3] ??
        MinMax(
          min: state.usVCA3.minValue,
          max: state.usVCA3.maxValue,
        );
    RangeFloatPointInput usVCA3 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.usVCA3] ?? '',
      minValue: usVCA3MinMax.min,
      maxValue: usVCA3MinMax.max,
    );

    MinMax usVCA4MinMax = values[DataKey.usVCA4] ??
        MinMax(
          min: state.usVCA4.minValue,
          max: state.usVCA4.maxValue,
        );
    RangeFloatPointInput usVCA4 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.usVCA4] ?? '',
      minValue: usVCA4MinMax.min,
      maxValue: usVCA4MinMax.max,
    );

    MinMax eREQMinMax = values[DataKey.eREQ] ??
        MinMax(
          min: state.eREQ.minValue,
          max: state.eREQ.maxValue,
        );
    RangeFloatPointInput eREQ = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.eREQ] ?? '',
      minValue: eREQMinMax.min,
      maxValue: eREQMinMax.max,
    );
    String ingressSetting2 =
        characteristicDataCache[DataKey.ingressSetting2] ?? '';
    String ingressSetting3 =
        characteristicDataCache[DataKey.ingressSetting3] ?? '';
    String ingressSetting4 =
        characteristicDataCache[DataKey.ingressSetting4] ?? '';

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA1: usVCA1,
      usVCA2: usVCA2,
      usVCA3: usVCA3,
      usVCA4: usVCA4,
      eREQ: eREQ,
      returnIngressSetting2: ingressSetting2,
      returnIngressSetting3: ingressSetting3,
      returnIngressSetting4: ingressSetting4,
      initialValues: characteristicDataCache,
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

  void _onUSVCA1Changed(
    USVCA1Changed event,
    Emitter<Setting18ReverseControlState> emit,
  ) {
    RangeFloatPointInput usVCA1 = RangeFloatPointInput.dirty(
      event.usVCA1,
      minValue: state.usVCA1.minValue,
      maxValue: state.usVCA1.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.usVCA1);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA1: usVCA1,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        usVCA1: usVCA1,
      ),
    ));
  }

  void _onUSVCA2Changed(
    USVCA2Changed event,
    Emitter<Setting18ReverseControlState> emit,
  ) {
    RangeFloatPointInput usVCA2 = RangeFloatPointInput.dirty(
      event.usVCA2,
      minValue: state.usVCA2.minValue,
      maxValue: state.usVCA2.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.usVCA2);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA2: usVCA2,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        usVCA2: usVCA2,
      ),
    ));
  }

  void _onUSVCA3Changed(
    USVCA3Changed event,
    Emitter<Setting18ReverseControlState> emit,
  ) {
    RangeFloatPointInput usVCA3 = RangeFloatPointInput.dirty(
      event.usVCA3,
      minValue: state.usVCA3.minValue,
      maxValue: state.usVCA3.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.usVCA3);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA3: usVCA3,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        usVCA3: usVCA3,
      ),
    ));
  }

  void _onUSVCA4Changed(
    USVCA4Changed event,
    Emitter<Setting18ReverseControlState> emit,
  ) {
    RangeFloatPointInput usVCA4 = RangeFloatPointInput.dirty(
      event.usVCA4,
      minValue: state.usVCA4.minValue,
      maxValue: state.usVCA4.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.usVCA4);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA4: usVCA4,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        usVCA4: usVCA4,
      ),
    ));
  }

  void _onEREQChanged(
    EREQChanged event,
    Emitter<Setting18ReverseControlState> emit,
  ) {
    RangeFloatPointInput eREQ = RangeFloatPointInput.dirty(
      event.eREQ,
      minValue: state.eREQ.minValue,
      maxValue: state.eREQ.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.eREQ);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      eREQ: eREQ,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        eREQ: eREQ,
      ),
    ));
  }

  void _onRtnIngressSetting2Changed(
    RtnIngressSetting2Changed event,
    Emitter<Setting18ReverseControlState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.ingressSetting2);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      returnIngressSetting2: event.returnIngressSetting2,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        returnIngressSetting2: event.returnIngressSetting2,
      ),
    ));
  }

  void _onRtnIngressSetting3Changed(
    RtnIngressSetting3Changed event,
    Emitter<Setting18ReverseControlState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.ingressSetting3);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      returnIngressSetting3: event.returnIngressSetting3,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        returnIngressSetting3: event.returnIngressSetting3,
      ),
    ));
  }

  void _onRtnIngressSetting4Changed(
    RtnIngressSetting4Changed event,
    Emitter<Setting18ReverseControlState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.ingressSetting4);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      returnIngressSetting4: event.returnIngressSetting4,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        returnIngressSetting4: event.returnIngressSetting4,
      ),
    ));
  }

  bool _isEnabledSubmission({
    RangeFloatPointInput? usVCA1,
    RangeFloatPointInput? usVCA2,
    RangeFloatPointInput? usVCA3,
    RangeFloatPointInput? usVCA4,
    RangeFloatPointInput? eREQ,
    String? returnIngressSetting2,
    String? returnIngressSetting3,
    String? returnIngressSetting4,
  }) {
    usVCA1 ??= state.usVCA1;
    usVCA2 ??= state.usVCA2;
    usVCA3 ??= state.usVCA3;
    usVCA4 ??= state.usVCA4;
    eREQ ??= state.eREQ;
    returnIngressSetting2 ??= state.returnIngressSetting2;
    returnIngressSetting3 ??= state.returnIngressSetting3;
    returnIngressSetting4 ??= state.returnIngressSetting4;

    if (usVCA1.isNotValid ||
        usVCA2.isNotValid ||
        usVCA3.isNotValid ||
        usVCA4.isNotValid ||
        eREQ.isNotValid) {
      return false;
    } else {
      if (usVCA1.value != state.initialValues[DataKey.usVCA1] ||
          usVCA2.value != state.initialValues[DataKey.usVCA2] ||
          usVCA3.value != state.initialValues[DataKey.usVCA3] ||
          usVCA4.value != state.initialValues[DataKey.usVCA4] ||
          eREQ.value != state.initialValues[DataKey.eREQ] ||
          returnIngressSetting2 !=
              state.initialValues[DataKey.ingressSetting2] ||
          returnIngressSetting3 !=
              state.initialValues[DataKey.ingressSetting3] ||
          returnIngressSetting4 !=
              state.initialValues[DataKey.ingressSetting4]) {
        return true;
      } else {
        return false;
      }
    }
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
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      editMode: false,
      enableSubmission: false,
      tappedSet: {},
      usVCA1: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.usVCA1] ?? '',
        minValue: state.usVCA1.minValue,
        maxValue: state.usVCA1.maxValue,
      ),
      usVCA2: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.usVCA2] ?? '',
        minValue: state.usVCA2.minValue,
        maxValue: state.usVCA2.maxValue,
      ),
      usVCA3: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.usVCA3] ?? '',
        minValue: state.usVCA3.minValue,
        maxValue: state.usVCA3.maxValue,
      ),
      usVCA4: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.usVCA4] ?? '',
        minValue: state.usVCA4.minValue,
        maxValue: state.usVCA4.maxValue,
      ),
      eREQ: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.eREQ] ?? '',
        minValue: state.eREQ.minValue,
        maxValue: state.eREQ.maxValue,
      ),
      returnIngressSetting2: state.initialValues[DataKey.ingressSetting2],
      returnIngressSetting3: state.initialValues[DataKey.ingressSetting3],
      returnIngressSetting4: state.initialValues[DataKey.ingressSetting4],
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

    if (state.usVCA1.value != state.initialValues[DataKey.usVCA1]) {
      bool resultOfSetUSVCA1Cmd =
          await _amp18Repository.set1p8GUSVCA1(state.usVCA1.value);

      settingResult.add('${DataKey.usVCA1.name},$resultOfSetUSVCA1Cmd');
    }

    if (state.usVCA2.value != state.initialValues[DataKey.usVCA2]) {
      bool resultOfSetUSVCA2 =
          await _amp18Repository.set1p8GUSVCA2(state.usVCA2.value);

      settingResult.add('${DataKey.usVCA2.name},$resultOfSetUSVCA2');
    }

    if (state.usVCA3.value != state.initialValues[DataKey.usVCA3]) {
      bool resultOfSetUSVCA3 =
          await _amp18Repository.set1p8GUSVCA3(state.usVCA3.value);

      settingResult.add('${DataKey.usVCA3.name},$resultOfSetUSVCA3');
    }

    if (state.usVCA4.value != state.initialValues[DataKey.usVCA4]) {
      bool resultOfSetUSVCA4 =
          await _amp18Repository.set1p8GUSVCA4(state.usVCA4.value);

      settingResult.add('${DataKey.usVCA4.name},$resultOfSetUSVCA4');
    }

    if (state.returnIngressSetting2 !=
        state.initialValues[DataKey.ingressSetting2]) {
      bool resultOfSetReturnIngress2 = await _amp18Repository
          .set1p8GReturnIngress2(state.returnIngressSetting2);

      settingResult
          .add('${DataKey.ingressSetting2.name},$resultOfSetReturnIngress2');
    }

    if (state.returnIngressSetting3 !=
        state.initialValues[DataKey.ingressSetting3]) {
      bool resultOfSetReturnIngress3 = await _amp18Repository
          .set1p8GReturnIngress3(state.returnIngressSetting3);

      settingResult
          .add('${DataKey.ingressSetting3.name},$resultOfSetReturnIngress3');
    }

    if (state.returnIngressSetting4 !=
        state.initialValues[DataKey.ingressSetting4]) {
      bool resultOfSetReturnIngress4 = await _amp18Repository
          .set1p8GReturnIngress4(state.returnIngressSetting4);

      settingResult
          .add('${DataKey.ingressSetting4.name},$resultOfSetReturnIngress4');
    }

    if (state.eREQ.value != state.initialValues[DataKey.eREQ]) {
      bool resultOfSetEREQ =
          await _amp18Repository.set1p8GEREQ(state.eREQ.value);

      settingResult.add('${DataKey.eREQ.name},$resultOfSetEREQ');
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
