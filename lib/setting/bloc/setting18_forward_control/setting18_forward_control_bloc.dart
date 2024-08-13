import 'package:aci_plus_app/core/control_item_value.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:aci_plus_app/setting/model/formz_input_initializer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    on<DSVVA1Changed>(_onDSVVA1Changed);
    on<DSVVA2Changed>(_onDSVVA2Changed);
    on<DSVVA3Changed>(_onDSVVA3Changed);
    on<DSVVA4Changed>(_onDSVVA4Changed);
    on<DSVVA5Changed>(_onDSVVA5Changed);
    on<DSSlope1Changed>(_onDSSlope1Changed);
    on<DSSlope2Changed>(_onDSSlope2Changed);
    on<DSSlope3Changed>(_onDSSlope3Changed);
    on<DSSlope4Changed>(_onDSSlope4Changed);
    on<TGCCableLengthChanged>(_onTGCCableLengthChanged);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);

    add(const Initialized());
  }

  final Amp18Repository _amp18Repository;

  void _onInitialized(
    Initialized event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    // ex: C-coe LE 沒有 VVA4, VVA5, 讀到的值是 -0.1, 不符合範圍, 所以改成 0.0 作為初始值
    characteristicDataCache.forEach((key, value) {
      if (value == '-0.1') {
        characteristicDataCache[key] = '0.0';
      }
    });

    // 當斷線的時候重新初始化時讀取 map 元素會有 null 的情況, null 時就 assign 空字串
    String splitOption = characteristicDataCache[DataKey.splitOption] ?? '';
    String partId = characteristicDataCache[DataKey.partId] ?? '';

    Map<DataKey, MinMax> values = {};

    if (splitOption.isNotEmpty && partId.isNotEmpty) {
      values =
          ControlItemValue.valueCollection[splitOption]![int.parse(partId)];
    }

    MinMax dsVVA1MinMax = values[DataKey.dsVVA1] ??
        MinMax(
          min: state.dsVVA1.minValue,
          max: state.dsVVA1.maxValue,
        );
    RangeFloatPointInput dsVVA1 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsVVA1] ?? '',
      minValue: dsVVA1MinMax.min,
      maxValue: dsVVA1MinMax.max,
    );

    MinMax dsVVA2MinMax = values[DataKey.dsVVA2] ??
        MinMax(
          min: state.dsVVA2.minValue,
          max: state.dsVVA2.maxValue,
        );
    RangeFloatPointInput dsVVA2 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsVVA2] ?? '',
      minValue: dsVVA2MinMax.min,
      maxValue: dsVVA2MinMax.max,
    );

    MinMax dsVVA3MinMax = values[DataKey.dsVVA3] ??
        MinMax(
          min: state.dsVVA3.minValue,
          max: state.dsVVA3.maxValue,
        );
    RangeFloatPointInput dsVVA3 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsVVA3] ?? '',
      minValue: dsVVA3MinMax.min,
      maxValue: dsVVA3MinMax.max,
    );

    MinMax dsVVA4MinMax = values[DataKey.dsVVA4] ??
        MinMax(
          min: state.dsVVA4.minValue,
          max: state.dsVVA4.maxValue,
        );
    RangeFloatPointInput dsVVA4 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsVVA4] ?? '',
      minValue: dsVVA4MinMax.min,
      maxValue: dsVVA4MinMax.max,
    );

    MinMax dsVVA5MinMax = values[DataKey.dsVVA5] ??
        MinMax(
          min: state.dsVVA5.minValue,
          max: state.dsVVA5.maxValue,
        );
    RangeFloatPointInput dsVVA5 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsVVA5] ?? '',
      minValue: dsVVA5MinMax.min,
      maxValue: dsVVA5MinMax.max,
    );

    MinMax dsSlope1MinMax = values[DataKey.dsSlope1] ??
        MinMax(
          min: state.dsSlope1.minValue,
          max: state.dsSlope1.maxValue,
        );
    RangeFloatPointInput dsSlope1 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsSlope1] ?? '',
      minValue: dsSlope1MinMax.min,
      maxValue: dsSlope1MinMax.max,
    );

    MinMax dsSlope2MinMax = values[DataKey.dsSlope2] ??
        MinMax(
          min: state.dsSlope2.minValue,
          max: state.dsSlope2.maxValue,
        );
    RangeFloatPointInput dsSlope2 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsSlope2] ?? '',
      minValue: dsSlope2MinMax.min,
      maxValue: dsSlope2MinMax.max,
    );

    MinMax dsSlope3MinMax = values[DataKey.dsSlope3] ??
        MinMax(
          min: state.dsSlope3.minValue,
          max: state.dsSlope3.maxValue,
        );
    RangeFloatPointInput dsSlope3 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsSlope3] ?? '',
      minValue: dsSlope3MinMax.min,
      maxValue: dsSlope3MinMax.max,
    );

    MinMax dsSlope4MinMax = values[DataKey.dsSlope4] ??
        MinMax(
          min: state.dsSlope4.minValue,
          max: state.dsSlope4.maxValue,
        );
    RangeFloatPointInput dsSlope4 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsSlope4] ?? '',
      minValue: dsSlope4MinMax.min,
      maxValue: dsSlope4MinMax.max,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA1: dsVVA1,
      dsVVA2: dsVVA2,
      dsVVA3: dsVVA3,
      dsVVA4: dsVVA4,
      dsVVA5: dsVVA5,
      dsSlope1: dsSlope1,
      dsSlope2: dsSlope2,
      dsSlope3: dsSlope3,
      dsSlope4: dsSlope4,
      initialValues: characteristicDataCache,
      editMode: false,
      enableSubmission: false,
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

  void _onDSVVA1Changed(
    DSVVA1Changed event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    RangeFloatPointInput dsVVA1 = RangeFloatPointInput.dirty(
      event.dsVVA1,
      minValue: state.dsVVA1.minValue,
      maxValue: state.dsVVA1.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA1: dsVVA1,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: dsVVA1,
      ),
    ));
  }

  void _onDSVVA2Changed(
    DSVVA2Changed event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    RangeFloatPointInput dsVVA2 = RangeFloatPointInput.dirty(
      event.dsVVA2,
      minValue: state.dsVVA2.minValue,
      maxValue: state.dsVVA2.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA2: dsVVA2,
      enableSubmission: _isEnabledSubmission(
        dsVVA2: dsVVA2,
      ),
    ));
  }

  void _onDSVVA3Changed(
    DSVVA3Changed event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    RangeFloatPointInput dsVVA3 = RangeFloatPointInput.dirty(
      event.dsVVA3,
      minValue: state.dsVVA3.minValue,
      maxValue: state.dsVVA3.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA3: dsVVA3,
      enableSubmission: _isEnabledSubmission(
        dsVVA3: dsVVA3,
      ),
    ));
  }

  void _onDSVVA4Changed(
    DSVVA4Changed event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    RangeFloatPointInput dsVVA4 = RangeFloatPointInput.dirty(
      event.dsVVA4,
      minValue: state.dsVVA4.minValue,
      maxValue: state.dsVVA4.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA4: dsVVA4,
      enableSubmission: _isEnabledSubmission(
        dsVVA4: dsVVA4,
      ),
    ));
  }

  void _onDSVVA5Changed(
    DSVVA5Changed event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    RangeFloatPointInput dsVVA5 = RangeFloatPointInput.dirty(
      event.dsVVA5,
      minValue: state.dsVVA5.minValue,
      maxValue: state.dsVVA5.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA5: dsVVA5,
      enableSubmission: _isEnabledSubmission(
        dsVVA5: dsVVA5,
      ),
    ));
  }

  void _onDSSlope1Changed(
    DSSlope1Changed event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    RangeFloatPointInput dsSlope1 = RangeFloatPointInput.dirty(
      event.dsSlope1,
      minValue: state.dsSlope1.minValue,
      maxValue: state.dsSlope1.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      dsSlope1: dsSlope1,
      enableSubmission: _isEnabledSubmission(
        dsSlope1: dsSlope1,
      ),
    ));
  }

  void _onDSSlope2Changed(
    DSSlope2Changed event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    RangeFloatPointInput dsSlope2 = RangeFloatPointInput.dirty(
      event.dsSlope2,
      minValue: state.dsSlope2.minValue,
      maxValue: state.dsSlope2.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      dsSlope2: dsSlope2,
      enableSubmission: _isEnabledSubmission(
        dsSlope2: dsSlope2,
      ),
    ));
  }

  void _onDSSlope3Changed(
    DSSlope3Changed event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    RangeFloatPointInput dsSlope3 = RangeFloatPointInput.dirty(
      event.dsSlope3,
      minValue: state.dsSlope3.minValue,
      maxValue: state.dsSlope3.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      dsSlope3: dsSlope3,
      enableSubmission: _isEnabledSubmission(
        dsSlope3: dsSlope3,
      ),
    ));
  }

  void _onDSSlope4Changed(
    DSSlope4Changed event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    RangeFloatPointInput dsSlope4 = RangeFloatPointInput.dirty(
      event.dsSlope4,
      minValue: state.dsSlope4.minValue,
      maxValue: state.dsSlope4.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      dsSlope4: dsSlope4,
      enableSubmission: _isEnabledSubmission(
        dsSlope4: dsSlope4,
      ),
    ));
  }

  void _onTGCCableLengthChanged(
    TGCCableLengthChanged event,
    Emitter<Setting18ForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      tgcCableLength: event.tgcCableLength,
      enableSubmission: _isEnabledSubmission(
        tgcCableLength: event.tgcCableLength,
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
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      editMode: false,
      enableSubmission: false,
      dsVVA1: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.dsVVA1] ?? '',
        minValue: state.dsVVA1.minValue,
        maxValue: state.dsVVA1.maxValue,
      ),
      dsVVA2: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.dsVVA2] ?? '',
        minValue: state.dsVVA2.minValue,
        maxValue: state.dsVVA2.maxValue,
      ),
      dsVVA3: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.dsVVA3] ?? '',
        minValue: state.dsVVA3.minValue,
        maxValue: state.dsVVA3.maxValue,
      ),
      dsVVA4: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.dsVVA4] ?? '',
        minValue: state.dsVVA4.minValue,
        maxValue: state.dsVVA4.maxValue,
      ),
      dsVVA5: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.dsVVA5] ?? '',
        minValue: state.dsVVA5.minValue,
        maxValue: state.dsVVA5.maxValue,
      ),
      dsSlope1: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.dsSlope1] ?? '',
        minValue: state.dsSlope1.minValue,
        maxValue: state.dsSlope1.maxValue,
      ),
      dsSlope2: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.dsSlope2] ?? '',
        minValue: state.dsSlope2.minValue,
        maxValue: state.dsSlope2.maxValue,
      ),
      dsSlope3: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.dsSlope3] ?? '',
        minValue: state.dsSlope3.minValue,
        maxValue: state.dsSlope3.maxValue,
      ),
      dsSlope4: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.dsSlope4] ?? '',
        minValue: state.dsSlope4.minValue,
        maxValue: state.dsSlope4.maxValue,
      ),
      tgcCableLength: state.initialValues[DataKey.tgcCableLength],
    ));
  }

  bool _isEnabledSubmission({
    RangeFloatPointInput? dsVVA1,
    RangeFloatPointInput? dsVVA2,
    RangeFloatPointInput? dsVVA3,
    RangeFloatPointInput? dsVVA4,
    RangeFloatPointInput? dsVVA5,
    RangeFloatPointInput? dsSlope1,
    RangeFloatPointInput? dsSlope2,
    RangeFloatPointInput? dsSlope3,
    RangeFloatPointInput? dsSlope4,
    String? tgcCableLength,
  }) {
    dsVVA1 ??= state.dsVVA1;
    dsVVA2 ??= state.dsVVA2;
    dsVVA3 ??= state.dsVVA3;
    dsVVA4 ??= state.dsVVA4;
    dsVVA5 ??= state.dsVVA5;
    dsSlope1 ??= state.dsSlope1;
    dsSlope2 ??= state.dsSlope2;
    dsSlope3 ??= state.dsSlope3;
    dsSlope4 ??= state.dsSlope4;
    tgcCableLength ??= state.tgcCableLength;

    if (dsVVA1.isNotValid ||
        dsVVA2.isNotValid ||
        dsVVA3.isNotValid ||
        dsVVA4.isNotValid ||
        dsVVA5.isNotValid ||
        dsSlope1.isNotValid ||
        dsSlope2.isNotValid ||
        dsSlope3.isNotValid ||
        dsSlope4.isNotValid) {
      return false;
    } else {
      if (dsVVA1.value != state.initialValues[DataKey.dsVVA1] ||
          dsVVA2.value != state.initialValues[DataKey.dsVVA2] ||
          dsVVA3.value != state.initialValues[DataKey.dsVVA3] ||
          dsVVA4.value != state.initialValues[DataKey.dsVVA4] ||
          dsVVA5.value != state.initialValues[DataKey.dsVVA5] ||
          dsSlope1.value != state.initialValues[DataKey.dsSlope1] ||
          dsSlope2.value != state.initialValues[DataKey.dsSlope2] ||
          dsSlope3.value != state.initialValues[DataKey.dsSlope3] ||
          dsSlope4.value != state.initialValues[DataKey.dsSlope4] ||
          tgcCableLength != state.initialValues[DataKey.tgcCableLength]) {
        return true;
      } else {
        return false;
      }
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

    if (state.dsVVA1.value != state.initialValues[DataKey.dsVVA1]) {
      bool resultOfSetDSVVA1 =
          await _amp18Repository.set1p8GDSVVA1(state.dsVVA1.value);

      settingResult.add('${DataKey.dsVVA1.name},$resultOfSetDSVVA1');
    }

    if (state.dsVVA2.value != state.initialValues[DataKey.dsVVA2]) {
      bool resultOfSetDSVVA2 =
          await _amp18Repository.set1p8GDSVVA2(state.dsVVA2.value);

      settingResult.add('${DataKey.dsVVA2.name},$resultOfSetDSVVA2');
    }

    if (state.dsVVA3.value != state.initialValues[DataKey.dsVVA3]) {
      bool resultOfSetDSVVA3 =
          await _amp18Repository.set1p8DSVVA3(state.dsVVA3.value);

      settingResult.add('${DataKey.dsVVA3.name},$resultOfSetDSVVA3');
    }

    if (state.dsVVA4.value != state.initialValues[DataKey.dsVVA4]) {
      bool resultOfSetDSVVA4 =
          await _amp18Repository.set1p8GDSVVA4(state.dsVVA4.value);

      settingResult.add('${DataKey.dsVVA4.name},$resultOfSetDSVVA4');
    }

    if (state.dsVVA5.value != state.initialValues[DataKey.dsVVA5]) {
      bool resultOfSetDSVVA5 =
          await _amp18Repository.set1p8GDSVVA5(state.dsVVA5.value);

      settingResult.add('${DataKey.dsVVA5.name},$resultOfSetDSVVA5');
    }

    if (state.dsSlope1.value != state.initialValues[DataKey.dsSlope1]) {
      bool resultOfSetDSSlope1 =
          await _amp18Repository.set1p8GDSSlope1(state.dsSlope1.value);

      settingResult.add('${DataKey.dsSlope1.name},$resultOfSetDSSlope1');
    }

    if (state.dsSlope2.value != state.initialValues[DataKey.dsSlope2]) {
      bool resultOfSetDSSlope2 =
          await _amp18Repository.set1p8GDSSlope2(state.dsSlope2.value);

      settingResult.add('${DataKey.dsSlope2.name},$resultOfSetDSSlope2');
    }

    if (state.dsSlope3.value != state.initialValues[DataKey.dsSlope3]) {
      bool resultOfSetDSSlope3 =
          await _amp18Repository.set1p8GDSSlope3(state.dsSlope3.value);

      settingResult.add('${DataKey.dsSlope3.name},$resultOfSetDSSlope3');
    }

    if (state.dsSlope4.value != state.initialValues[DataKey.dsSlope4]) {
      bool resultOfSetDSSlope4 =
          await _amp18Repository.set1p8GDSSlope4(state.dsSlope4.value);

      settingResult.add('${DataKey.dsSlope4.name},$resultOfSetDSSlope4');
    }

    // if (state.tgcCableLength != state.initialValues[DataKey.tgcCableLength]) {
    //   bool resultOfSetTGCCableLength =
    //       await _amp18Repository.set1p8GTGCCableLength(state.tgcCableLength);

    //   settingResult
    //       .add('${DataKey.tgcCableLength.name},$resultOfSetTGCCableLength');
    // }

    // 等待 device 完成更新後在讀取值
    await Future.delayed(const Duration(milliseconds: 1000));

    await _amp18Repository.updateCharacteristics();

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
      enableSubmission: false,
      editMode: false,
    ));
  }
}
