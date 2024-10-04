import 'package:aci_plus_app/core/control_item_value.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:aci_plus_app/setting/model/formz_input_initializer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_ccor_node_forward_control_event.dart';
part 'setting18_ccor_node_forward_control_state.dart';

class Setting18CCorNodeForwardControlBloc extends Bloc<
    Setting18CCorNodeForwardControlEvent,
    Setting18CCorNodeForwardControlState> {
  Setting18CCorNodeForwardControlBloc({
    required Amp18CCorNodeRepository amp18CCorNodeRepository,
  })  : _amp18CCorNodeRepository = amp18CCorNodeRepository,
        super(const Setting18CCorNodeForwardControlState()) {
    on<Initialized>(_onInitialized);
    on<DSVVA1Changed>(_onDSVVA1Changed);
    on<DSVVA3Changed>(_onDSVVA3Changed);
    on<DSVVA4Changed>(_onDSVVA4Changed);
    on<DSVVA6Changed>(_onDSVVA6Changed);
    // on<DSInSlope1Changed>(_onDSInSlope1Changed);
    // on<DSInSlope3Changed>(_onDSInSlope3Changed);
    // on<DSInSlope4Changed>(_onDSInSlope4Changed);
    // on<DSInSlope6Changed>(_onDSInSlope6Changed);
    on<DSOutSlope1Changed>(_onDSOutSlope1Changed);
    on<DSOutSlope3Changed>(_onDSOutSlope3Changed);
    on<DSOutSlope4Changed>(_onDSOutSlope4Changed);
    on<DSOutSlope6Changed>(_onDSOutSlope6Changed);
    on<BiasCurrent1Changed>(_onBiasCurrent1Changed);
    on<BiasCurrent3Changed>(_onBiasCurrent3Changed);
    on<BiasCurrent4Changed>(_onBiasCurrent4Changed);
    on<BiasCurrent6Changed>(_onBiasCurrent6Changed);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);

    add(const Initialized());
  }

  final Amp18CCorNodeRepository _amp18CCorNodeRepository;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) async {
    Map<DataKey, String> characteristicDataCache =
        _amp18CCorNodeRepository.characteristicDataCache;

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

    MinMax dsVVA6MinMax = values[DataKey.dsVVA6] ??
        MinMax(
          min: state.dsVVA6.minValue,
          max: state.dsVVA6.maxValue,
        );
    RangeFloatPointInput dsVVA6 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsVVA6] ?? '',
      minValue: dsVVA6MinMax.min,
      maxValue: dsVVA6MinMax.max,
    );
    // RangeFloatPointInput dsInSlope1 = initialRangeFloatPointInput(
    //   characteristicDataCache[DataKey.dsInSlope1] ?? '',
    //   minValue: state.dsInSlope1.minValue,
    //   maxValue: state.dsInSlope1.maxValue,
    // );
    // RangeFloatPointInput dsInSlope3 = initialRangeFloatPointInput(
    //   characteristicDataCache[DataKey.dsInSlope3] ?? '',
    //   minValue: state.dsInSlope3.minValue,
    //   maxValue: state.dsInSlope3.maxValue,
    // );
    // RangeFloatPointInput dsInSlope4 = initialRangeFloatPointInput(
    //   characteristicDataCache[DataKey.dsInSlope4] ?? '',
    //   minValue: state.dsInSlope4.minValue,
    //   maxValue: state.dsInSlope4.maxValue,
    // );
    // RangeFloatPointInput dsInSlope6 = initialRangeFloatPointInput(
    //   characteristicDataCache[DataKey.dsInSlope6] ?? '',
    //   minValue: state.dsInSlope6.minValue,
    //   maxValue: state.dsInSlope6.maxValue,
    // );

    MinMax dsOutSlope1MinMax = values[DataKey.dsOutSlope1] ??
        MinMax(
          min: state.dsOutSlope1.minValue,
          max: state.dsOutSlope1.maxValue,
        );
    RangeFloatPointInput dsOutSlope1 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsOutSlope1] ?? '',
      minValue: dsOutSlope1MinMax.min,
      maxValue: dsOutSlope1MinMax.max,
    );

    MinMax dsOutSlope3MinMax = values[DataKey.dsOutSlope3] ??
        MinMax(
          min: state.dsOutSlope3.minValue,
          max: state.dsOutSlope3.maxValue,
        );
    RangeFloatPointInput dsOutSlope3 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsOutSlope3] ?? '',
      minValue: dsOutSlope3MinMax.min,
      maxValue: dsOutSlope3MinMax.max,
    );

    MinMax dsOutSlope4MinMax = values[DataKey.dsOutSlope4] ??
        MinMax(
          min: state.dsOutSlope4.minValue,
          max: state.dsOutSlope4.maxValue,
        );
    RangeFloatPointInput dsOutSlope4 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsOutSlope4] ?? '',
      minValue: dsOutSlope4MinMax.min,
      maxValue: dsOutSlope4MinMax.max,
    );

    MinMax dsOutSlope6MinMax = values[DataKey.dsOutSlope6] ??
        MinMax(
          min: state.dsOutSlope6.minValue,
          max: state.dsOutSlope6.maxValue,
        );
    RangeFloatPointInput dsOutSlope6 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsOutSlope6] ?? '',
      minValue: dsOutSlope6MinMax.min,
      maxValue: dsOutSlope6MinMax.max,
    );

    MinMax biasCurrent1MinMax = values[DataKey.biasCurrent1] ??
        MinMax(
          min: state.biasCurrent1.minValue.toDouble(),
          max: state.biasCurrent1.maxValue.toDouble(),
        );
    RangeIntegerInput biasCurrent1 = initialRangeIntegerInput(
      characteristicDataCache[DataKey.biasCurrent1] ?? '',
      minValue: biasCurrent1MinMax.min.toInt(),
      maxValue: biasCurrent1MinMax.max.toInt(),
    );

    MinMax biasCurrent3MinMax = values[DataKey.biasCurrent3] ??
        MinMax(
          min: state.biasCurrent3.minValue.toDouble(),
          max: state.biasCurrent3.maxValue.toDouble(),
        );
    RangeIntegerInput biasCurrent3 = initialRangeIntegerInput(
      characteristicDataCache[DataKey.biasCurrent3] ?? '',
      minValue: biasCurrent3MinMax.min.toInt(),
      maxValue: biasCurrent3MinMax.max.toInt(),
    );

    MinMax biasCurrent4MinMax = values[DataKey.biasCurrent4] ??
        MinMax(
          min: state.biasCurrent4.minValue.toDouble(),
          max: state.biasCurrent4.maxValue.toDouble(),
        );
    RangeIntegerInput biasCurrent4 = initialRangeIntegerInput(
      characteristicDataCache[DataKey.biasCurrent4] ?? '',
      minValue: biasCurrent4MinMax.min.toInt(),
      maxValue: biasCurrent4MinMax.max.toInt(),
    );

    MinMax biasCurrent6MinMax = values[DataKey.biasCurrent6] ??
        MinMax(
          min: state.biasCurrent6.minValue.toDouble(),
          max: state.biasCurrent6.maxValue.toDouble(),
        );
    RangeIntegerInput biasCurrent6 = initialRangeIntegerInput(
      characteristicDataCache[DataKey.biasCurrent6] ?? '',
      minValue: biasCurrent6MinMax.min.toInt(),
      maxValue: biasCurrent6MinMax.max.toInt(),
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA1: dsVVA1,
      dsVVA3: dsVVA3,
      dsVVA4: dsVVA4,
      dsVVA6: dsVVA6,
      // dsInSlope1: dsInSlope1,
      // dsInSlope3: dsInSlope3,
      // dsInSlope4: dsInSlope4,
      // dsInSlope6: dsInSlope6,
      dsOutSlope1: dsOutSlope1,
      dsOutSlope3: dsOutSlope3,
      dsOutSlope4: dsOutSlope4,
      dsOutSlope6: dsOutSlope6,
      biasCurrent1: biasCurrent1,
      biasCurrent3: biasCurrent3,
      biasCurrent4: biasCurrent4,
      biasCurrent6: biasCurrent6,
      initialValues: characteristicDataCache,
      editMode: false,
      enableSubmission: false,
      tappedSet: const {},
      settingResult: const [],
    ));
  }

  void _onDSVVA1Changed(
    DSVVA1Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    RangeFloatPointInput dsVVA1 = RangeFloatPointInput.dirty(
      event.dsVVA1,
      minValue: state.dsVVA1.minValue,
      maxValue: state.dsVVA1.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.dsVVA1);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA1: dsVVA1,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: dsVVA1,
      ),
    ));
  }

  void _onDSVVA3Changed(
    DSVVA3Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    RangeFloatPointInput dsVVA3 = RangeFloatPointInput.dirty(
      event.dsVVA3,
      minValue: state.dsVVA3.minValue,
      maxValue: state.dsVVA3.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.dsVVA3);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA3: dsVVA3,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        dsVVA3: dsVVA3,
      ),
    ));
  }

  void _onDSVVA4Changed(
    DSVVA4Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    RangeFloatPointInput dsVVA4 = RangeFloatPointInput.dirty(
      event.dsVVA4,
      minValue: state.dsVVA4.minValue,
      maxValue: state.dsVVA4.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.dsVVA4);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA4: dsVVA4,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        dsVVA4: dsVVA4,
      ),
    ));
  }

  void _onDSVVA6Changed(
    DSVVA6Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    RangeFloatPointInput dsVVA6 = RangeFloatPointInput.dirty(
      event.dsVVA6,
      minValue: state.dsVVA6.minValue,
      maxValue: state.dsVVA6.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.dsVVA6);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA6: dsVVA6,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        dsVVA6: dsVVA6,
      ),
    ));
  }

  // void _onDSInSlope1Changed(
  //   DSInSlope1Changed event,
  //   Emitter<Setting18CCorNodeForwardControlState> emit,
  // ) {
  //   RangeFloatPointInput dsInSlope1 = RangeFloatPointInput.dirty(
  //     event.dsInSlope1,
  //     minValue: state.dsInSlope1.minValue,
  //     maxValue: state.dsInSlope1.maxValue,
  //   );

  //   emit(state.copyWith(
  //     submissionStatus: SubmissionStatus.none,
  //     dsInSlope1: dsInSlope1,
  //     enableSubmission: _isEnabledSubmission(
  //       dsInSlope1: dsInSlope1,
  //     ),
  //   ));
  // }

  // void _onDSInSlope3Changed(
  //   DSInSlope3Changed event,
  //   Emitter<Setting18CCorNodeForwardControlState> emit,
  // ) {
  //   RangeFloatPointInput dsInSlope3 = RangeFloatPointInput.dirty(
  //     event.dsInSlope3,
  //     minValue: state.dsInSlope3.minValue,
  //     maxValue: state.dsInSlope3.maxValue,
  //   );

  //   emit(state.copyWith(
  //     submissionStatus: SubmissionStatus.none,
  //     dsInSlope3: dsInSlope3,
  //     enableSubmission: _isEnabledSubmission(
  //       dsInSlope3: dsInSlope3,
  //     ),
  //   ));
  // }

  // void _onDSInSlope4Changed(
  //   DSInSlope4Changed event,
  //   Emitter<Setting18CCorNodeForwardControlState> emit,
  // ) {
  //   RangeFloatPointInput dsInSlope4 = RangeFloatPointInput.dirty(
  //     event.dsInSlope4,
  //     minValue: state.dsInSlope4.minValue,
  //     maxValue: state.dsInSlope4.maxValue,
  //   );

  //   emit(state.copyWith(
  //     submissionStatus: SubmissionStatus.none,
  //     dsInSlope4: dsInSlope4,
  //     enableSubmission: _isEnabledSubmission(
  //       dsInSlope4: dsInSlope4,
  //     ),
  //   ));
  // }

  // void _onDSInSlope6Changed(
  //   DSInSlope6Changed event,
  //   Emitter<Setting18CCorNodeForwardControlState> emit,
  // ) {
  //   RangeFloatPointInput dsInSlope6 = RangeFloatPointInput.dirty(
  //     event.dsInSlope6,
  //     minValue: state.dsInSlope6.minValue,
  //     maxValue: state.dsInSlope6.maxValue,
  //   );

  //   emit(state.copyWith(
  //     submissionStatus: SubmissionStatus.none,
  //     dsInSlope6: dsInSlope6,
  //     enableSubmission: _isEnabledSubmission(
  //       dsInSlope6: dsInSlope6,
  //     ),
  //   ));
  // }

  void _onDSOutSlope1Changed(
    DSOutSlope1Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    RangeFloatPointInput dsOutSlope1 = RangeFloatPointInput.dirty(
      event.dsOutSlope1,
      minValue: state.dsOutSlope1.minValue,
      maxValue: state.dsOutSlope1.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.dsOutSlope1);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsOutSlope1: dsOutSlope1,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        dsOutSlope1: dsOutSlope1,
      ),
    ));
  }

  void _onDSOutSlope3Changed(
    DSOutSlope3Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    RangeFloatPointInput dsOutSlope3 = RangeFloatPointInput.dirty(
      event.dsOutSlope3,
      minValue: state.dsOutSlope3.minValue,
      maxValue: state.dsOutSlope3.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.dsOutSlope3);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsOutSlope3: dsOutSlope3,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        dsOutSlope3: dsOutSlope3,
      ),
    ));
  }

  void _onDSOutSlope4Changed(
    DSOutSlope4Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    RangeFloatPointInput dsOutSlope4 = RangeFloatPointInput.dirty(
      event.dsOutSlope4,
      minValue: state.dsOutSlope4.minValue,
      maxValue: state.dsOutSlope4.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.dsOutSlope4);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsOutSlope4: dsOutSlope4,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        dsOutSlope4: dsOutSlope4,
      ),
    ));
  }

  void _onDSOutSlope6Changed(
    DSOutSlope6Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    RangeFloatPointInput dsOutSlope6 = RangeFloatPointInput.dirty(
      event.dsOutSlope6,
      minValue: state.dsOutSlope6.minValue,
      maxValue: state.dsOutSlope6.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.dsOutSlope6);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsOutSlope6: dsOutSlope6,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        dsOutSlope6: dsOutSlope6,
      ),
    ));
  }

  void _onBiasCurrent1Changed(
    BiasCurrent1Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    RangeIntegerInput biasCurrent1 = RangeIntegerInput.dirty(
      event.biasCurrent1,
      minValue: state.biasCurrent1.minValue,
      maxValue: state.biasCurrent1.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.biasCurrent1);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      biasCurrent1: biasCurrent1,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        biasCurrent1: biasCurrent1,
      ),
    ));
  }

  void _onBiasCurrent3Changed(
    BiasCurrent3Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    RangeIntegerInput biasCurrent3 = RangeIntegerInput.dirty(
      event.biasCurrent3,
      minValue: state.biasCurrent3.minValue,
      maxValue: state.biasCurrent3.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.biasCurrent3);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      biasCurrent3: biasCurrent3,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        biasCurrent3: biasCurrent3,
      ),
    ));
  }

  void _onBiasCurrent4Changed(
    BiasCurrent4Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    RangeIntegerInput biasCurrent4 = RangeIntegerInput.dirty(
      event.biasCurrent4,
      minValue: state.biasCurrent4.minValue,
      maxValue: state.biasCurrent4.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.biasCurrent4);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      biasCurrent4: biasCurrent4,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        biasCurrent4: biasCurrent4,
      ),
    ));
  }

  void _onBiasCurrent6Changed(
    BiasCurrent6Changed event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    RangeIntegerInput biasCurrent6 = RangeIntegerInput.dirty(
      event.biasCurrent6,
      minValue: state.biasCurrent6.minValue,
      maxValue: state.biasCurrent6.maxValue,
    );

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.biasCurrent6);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      biasCurrent6: biasCurrent6,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        biasCurrent6: biasCurrent6,
      ),
    ));
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      editMode: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      editMode: false,
      enableSubmission: false,
      tappedSet: const {},
      dsVVA1: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.dsVVA1] ?? '',
        minValue: state.dsVVA1.minValue,
        maxValue: state.dsVVA1.maxValue,
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
      dsVVA6: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.dsVVA6] ?? '',
        minValue: state.dsVVA6.minValue,
        maxValue: state.dsVVA6.maxValue,
      ),
      // dsInSlope1: RangeFloatPointInput.dirty(
      //   state.initialValues[DataKey.dsInSlope1] ?? '',
      //   minValue: state.dsInSlope1.minValue,
      //   maxValue: state.dsInSlope1.maxValue,
      // ),
      // dsInSlope3: RangeFloatPointInput.dirty(
      //   state.initialValues[DataKey.dsInSlope3] ?? '',
      //   minValue: state.dsInSlope3.minValue,
      //   maxValue: state.dsInSlope3.maxValue,
      // ),
      // dsInSlope4: RangeFloatPointInput.dirty(
      //   state.initialValues[DataKey.dsInSlope4] ?? '',
      //   minValue: state.dsInSlope4.minValue,
      //   maxValue: state.dsInSlope4.maxValue,
      // ),
      // dsInSlope6: RangeFloatPointInput.dirty(
      //   state.initialValues[DataKey.dsInSlope6] ?? '',
      //   minValue: state.dsInSlope6.minValue,
      //   maxValue: state.dsInSlope6.maxValue,
      // ),
      dsOutSlope1: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.dsOutSlope1] ?? '',
        minValue: state.dsOutSlope1.minValue,
        maxValue: state.dsOutSlope1.maxValue,
      ),
      dsOutSlope3: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.dsOutSlope3] ?? '',
        minValue: state.dsOutSlope3.minValue,
        maxValue: state.dsOutSlope3.maxValue,
      ),
      dsOutSlope4: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.dsOutSlope4] ?? '',
        minValue: state.dsOutSlope4.minValue,
        maxValue: state.dsOutSlope4.maxValue,
      ),
      dsOutSlope6: RangeFloatPointInput.dirty(
        state.initialValues[DataKey.dsOutSlope6] ?? '',
        minValue: state.dsOutSlope6.minValue,
        maxValue: state.dsOutSlope6.maxValue,
      ),
      biasCurrent1: RangeIntegerInput.dirty(
        state.initialValues[DataKey.biasCurrent1] ?? '',
        minValue: state.biasCurrent1.minValue,
        maxValue: state.biasCurrent1.maxValue,
      ),
      biasCurrent3: RangeIntegerInput.dirty(
        state.initialValues[DataKey.biasCurrent3] ?? '',
        minValue: state.biasCurrent3.minValue,
        maxValue: state.biasCurrent3.maxValue,
      ),
      biasCurrent4: RangeIntegerInput.dirty(
        state.initialValues[DataKey.biasCurrent4] ?? '',
        minValue: state.biasCurrent4.minValue,
        maxValue: state.biasCurrent4.maxValue,
      ),
      biasCurrent6: RangeIntegerInput.dirty(
        state.initialValues[DataKey.biasCurrent6] ?? '',
        minValue: state.biasCurrent6.minValue,
        maxValue: state.biasCurrent6.maxValue,
      ),
    ));
  }

  bool _isEnabledSubmission({
    RangeFloatPointInput? dsVVA1,
    RangeFloatPointInput? dsVVA3,
    RangeFloatPointInput? dsVVA4,
    RangeFloatPointInput? dsVVA6,
    // RangeFloatPointInput? dsInSlope1,
    // RangeFloatPointInput? dsInSlope3,
    // RangeFloatPointInput? dsInSlope4,
    // RangeFloatPointInput? dsInSlope6,
    RangeFloatPointInput? dsOutSlope1,
    RangeFloatPointInput? dsOutSlope3,
    RangeFloatPointInput? dsOutSlope4,
    RangeFloatPointInput? dsOutSlope6,
    RangeIntegerInput? biasCurrent1,
    RangeIntegerInput? biasCurrent3,
    RangeIntegerInput? biasCurrent4,
    RangeIntegerInput? biasCurrent6,
  }) {
    dsVVA1 ??= state.dsVVA1;
    dsVVA3 ??= state.dsVVA3;
    dsVVA4 ??= state.dsVVA4;
    dsVVA6 ??= state.dsVVA6;
    // dsInSlope1 ??= state.dsInSlope1;
    // dsInSlope3 ??= state.dsInSlope3;
    // dsInSlope4 ??= state.dsInSlope4;
    // dsInSlope6 ??= state.dsInSlope6;
    dsOutSlope1 ??= state.dsOutSlope1;
    dsOutSlope3 ??= state.dsOutSlope3;
    dsOutSlope4 ??= state.dsOutSlope4;
    dsOutSlope6 ??= state.dsOutSlope6;
    biasCurrent1 ??= state.biasCurrent1;
    biasCurrent3 ??= state.biasCurrent3;
    biasCurrent4 ??= state.biasCurrent4;
    biasCurrent6 ??= state.biasCurrent6;

    if (dsVVA1.isNotValid ||
        dsVVA3.isNotValid ||
        dsVVA4.isNotValid ||
        dsVVA6.isNotValid ||
        // dsInSlope1.isNotValid ||
        // dsInSlope3.isNotValid ||
        // dsInSlope4.isNotValid ||
        // dsInSlope6.isNotValid ||
        dsOutSlope1.isNotValid ||
        dsOutSlope3.isNotValid ||
        dsOutSlope4.isNotValid ||
        dsOutSlope6.isNotValid ||
        biasCurrent1.isNotValid ||
        biasCurrent3.isNotValid ||
        biasCurrent4.isNotValid ||
        biasCurrent6.isNotValid) {
      return false;
    } else {
      if (dsVVA1.value != state.initialValues[DataKey.dsVVA1] ||
          dsVVA3.value != state.initialValues[DataKey.dsVVA3] ||
          dsVVA4.value != state.initialValues[DataKey.dsVVA4] ||
          dsVVA6.value != state.initialValues[DataKey.dsVVA6] ||
          // dsInSlope1.value != state.initialValues[DataKey.dsInSlope1] ||
          // dsInSlope3.value != state.initialValues[DataKey.dsInSlope3] ||
          // dsInSlope4.value != state.initialValues[DataKey.dsInSlope4] ||
          // dsInSlope6.value != state.initialValues[DataKey.dsInSlope6] ||
          dsOutSlope1.value != state.initialValues[DataKey.dsOutSlope1] ||
          dsOutSlope3.value != state.initialValues[DataKey.dsOutSlope3] ||
          dsOutSlope4.value != state.initialValues[DataKey.dsOutSlope4] ||
          dsOutSlope6.value != state.initialValues[DataKey.dsOutSlope6] ||
          biasCurrent1.value != state.initialValues[DataKey.biasCurrent1] ||
          biasCurrent3.value != state.initialValues[DataKey.biasCurrent3] ||
          biasCurrent4.value != state.initialValues[DataKey.biasCurrent4] ||
          biasCurrent6.value != state.initialValues[DataKey.biasCurrent6]) {
        return true;
      } else {
        return false;
      }
    }
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18CCorNodeForwardControlState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    List<String> settingResult = [];

    if (state.dsVVA1.value != state.initialValues[DataKey.dsVVA1]) {
      bool resultOfSetDSVVA1 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSVVA1(state.dsVVA1.value);

      settingResult.add('${DataKey.dsVVA1.name},$resultOfSetDSVVA1');
    }

    if (state.dsVVA3.value != state.initialValues[DataKey.dsVVA3]) {
      bool resultOfSetDSVVA3 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSVVA3(state.dsVVA3.value);

      settingResult.add('${DataKey.dsVVA3.name},$resultOfSetDSVVA3');
    }

    if (state.dsVVA4.value != state.initialValues[DataKey.dsVVA4]) {
      bool resultOfSetDSVVA4 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSVVA4(state.dsVVA4.value);

      settingResult.add('${DataKey.dsVVA4.name},$resultOfSetDSVVA4');
    }

    if (state.dsVVA6.value != state.initialValues[DataKey.dsVVA6]) {
      bool resultOfSetDSVVA6 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSVVA6(state.dsVVA6.value);

      settingResult.add('${DataKey.dsVVA6.name},$resultOfSetDSVVA6');
    }

    // if (state.dsInSlope1.value != state.initialValues[DataKey.dsInSlope1]) {
    //   bool resultOfSetDSInSlope1 = await _amp18CCorNodeRepository
    //       .set1p8GCCorNodeDSInSlope1(state.dsInSlope1.value);

    //   settingResult.add('${DataKey.dsInSlope1.name},$resultOfSetDSInSlope1');
    // }

    // if (state.dsInSlope3.value != state.initialValues[DataKey.dsInSlope3]) {
    //   bool resultOfSetDSInSlope3 = await _amp18CCorNodeRepository
    //       .set1p8GCCorNodeDSInSlope3(state.dsInSlope3.value);

    //   settingResult.add('${DataKey.dsInSlope3.name},$resultOfSetDSInSlope3');
    // }

    // if (state.dsInSlope4.value != state.initialValues[DataKey.dsInSlope4]) {
    //   bool resultOfSetDSInSlope4 = await _amp18CCorNodeRepository
    //       .set1p8GCCorNodeDSInSlope4(state.dsInSlope4.value);

    //   settingResult.add('${DataKey.dsInSlope4.name},$resultOfSetDSInSlope4');
    // }

    // if (state.dsInSlope6.value != state.initialValues[DataKey.dsInSlope6]) {
    //   bool resultOfSetDSInSlope6 = await _amp18CCorNodeRepository
    //       .set1p8GCCorNodeDSInSlope6(state.dsInSlope6.value);

    //   settingResult.add('${DataKey.dsInSlope6.name},$resultOfSetDSInSlope6');
    // }

    if (state.dsOutSlope1.value != state.initialValues[DataKey.dsOutSlope1]) {
      bool resultOfSetDSOutSlope1 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSOutSlope1(state.dsOutSlope1.value);

      settingResult.add('${DataKey.dsOutSlope1.name},$resultOfSetDSOutSlope1');
    }

    if (state.dsOutSlope3.value != state.initialValues[DataKey.dsOutSlope3]) {
      bool resultOfSetDSOutSlope3 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSOutSlope3(state.dsOutSlope3.value);

      settingResult.add('${DataKey.dsOutSlope3.name},$resultOfSetDSOutSlope3');
    }

    if (state.dsOutSlope4.value != state.initialValues[DataKey.dsOutSlope4]) {
      bool resultOfSetDSOutSlope4 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSOutSlope4(state.dsOutSlope4.value);

      settingResult.add('${DataKey.dsOutSlope4.name},$resultOfSetDSOutSlope4');
    }

    if (state.dsOutSlope6.value != state.initialValues[DataKey.dsOutSlope6]) {
      bool resultOfSetDSOutSlope6 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSOutSlope6(state.dsOutSlope6.value);

      settingResult.add('${DataKey.dsOutSlope6.name},$resultOfSetDSOutSlope6');
    }

    if (state.biasCurrent1.value != state.initialValues[DataKey.biasCurrent1]) {
      bool resultOfSetBiasCurrent1 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeBiasCurrent1(state.biasCurrent1.value);

      settingResult
          .add('${DataKey.biasCurrent1.name},$resultOfSetBiasCurrent1');
    }

    if (state.biasCurrent3.value != state.initialValues[DataKey.biasCurrent3]) {
      bool resultOfSetBiasCurrent3 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeBiasCurrent3(state.biasCurrent3.value);

      settingResult
          .add('${DataKey.biasCurrent3.name},$resultOfSetBiasCurrent3');
    }

    if (state.biasCurrent4.value != state.initialValues[DataKey.biasCurrent4]) {
      bool resultOfSetBiasCurrent4 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeBiasCurrent4(state.biasCurrent4.value);

      settingResult
          .add('${DataKey.biasCurrent4.name},$resultOfSetBiasCurrent4');
    }

    if (state.biasCurrent6.value != state.initialValues[DataKey.biasCurrent6]) {
      bool resultOfSetBiasCurrent6 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeBiasCurrent6(state.biasCurrent6.value);

      settingResult
          .add('${DataKey.biasCurrent6.name},$resultOfSetBiasCurrent6');
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
