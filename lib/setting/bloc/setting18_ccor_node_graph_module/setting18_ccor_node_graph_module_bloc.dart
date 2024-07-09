import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:aci_plus_app/setting/model/formz_input_initializer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_ccor_node_graph_module_event.dart';
part 'setting18_ccor_node_graph_module_state.dart';

class Setting18CCorNodeGraphModuleBloc extends Bloc<
    Setting18CCorNodeGraphModuleEvent, Setting18CCorNodeGraphModuleState> {
  Setting18CCorNodeGraphModuleBloc(
      {required Amp18CCorNodeRepository amp18CCorNodeRepository})
      : _amp18CCorNodeRepository = amp18CCorNodeRepository,
        super(const Setting18CCorNodeGraphModuleState()) {
    on<Initialized>(_onInitialized);
    on<ForwardConfigChanged>(_onForwardConfigChanged);
    on<SplitOptionChanged>(_onSplitOptionChanged);
    on<DSVVA1Changed>(_onDSVVA1Changed);
    on<DSVVA3Changed>(_onDSVVA3Changed);
    on<DSVVA4Changed>(_onDSVVA4Changed);
    on<DSVVA6Changed>(_onDSVVA6Changed);
    on<DSInSlope1Changed>(_onDSInSlope1Changed);
    on<DSInSlope3Changed>(_onDSInSlope3Changed);
    on<DSInSlope4Changed>(_onDSInSlope4Changed);
    on<DSInSlope6Changed>(_onDSInSlope6Changed);
    on<DSOutSlope1Changed>(_onDSOutSlope1Changed);
    on<DSOutSlope3Changed>(_onDSOutSlope3Changed);
    on<DSOutSlope4Changed>(_onDSOutSlope4Changed);
    on<DSOutSlope6Changed>(_onDSOutSlope6Changed);
    on<BiasCurrent1Changed>(_onBiasCurrent1Changed);
    on<BiasCurrent3Changed>(_onBiasCurrent3Changed);
    on<BiasCurrent4Changed>(_onBiasCurrent4Changed);
    on<BiasCurrent6Changed>(_onBiasCurrent6Changed);
    on<USVCA1Changed>(_onUSVCA1Changed);
    on<USVCA3Changed>(_onUSVCA3Changed);
    on<USVCA4Changed>(_onUSVCA4Changed);
    on<USVCA6Changed>(_onUSVCA6Changed);
    on<ReturnIngressSetting1Changed>(_onReturnIngressSetting1Changed);
    on<ReturnIngressSetting3Changed>(_onReturnIngressSetting3Changed);
    on<ReturnIngressSetting4Changed>(_onReturnIngressSetting4Changed);
    on<ReturnIngressSetting6Changed>(_onReturnIngressSetting6Changed);
    on<SettingSubmitted>(_onSettingSubmitted);

    add(const Initialized());
  }

  final Amp18CCorNodeRepository _amp18CCorNodeRepository;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) async {
    Map<DataKey, String> characteristicDataCache =
        _amp18CCorNodeRepository.characteristicDataCache;

    String forwardConfig = characteristicDataCache[DataKey.forwardConfig] ?? '';
    String splitOption = characteristicDataCache[DataKey.splitOption] ?? '';
    RangeFloatPointInput dsVVA1 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsVVA1] ?? '',
      minValue: state.dsVVA1.minValue,
      maxValue: state.dsVVA1.maxValue,
    );
    RangeFloatPointInput dsVVA3 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsVVA3] ?? '',
      minValue: state.dsVVA3.minValue,
      maxValue: state.dsVVA3.maxValue,
    );
    RangeFloatPointInput dsVVA4 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsVVA4] ?? '',
      minValue: state.dsVVA4.minValue,
      maxValue: state.dsVVA4.maxValue,
    );
    RangeFloatPointInput dsVVA6 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsVVA6] ?? '',
      minValue: state.dsVVA6.minValue,
      maxValue: state.dsVVA6.maxValue,
    );
    RangeFloatPointInput dsInSlope1 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsInSlope1] ?? '',
      minValue: state.dsInSlope1.minValue,
      maxValue: state.dsInSlope1.maxValue,
    );
    RangeFloatPointInput dsInSlope3 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsInSlope3] ?? '',
      minValue: state.dsInSlope3.minValue,
      maxValue: state.dsInSlope3.maxValue,
    );
    RangeFloatPointInput dsInSlope4 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsInSlope4] ?? '',
      minValue: state.dsInSlope4.minValue,
      maxValue: state.dsInSlope4.maxValue,
    );
    RangeFloatPointInput dsInSlope6 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsInSlope6] ?? '',
      minValue: state.dsInSlope6.minValue,
      maxValue: state.dsInSlope6.maxValue,
    );
    RangeFloatPointInput dsOutSlope1 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsOutSlope1] ?? '',
      minValue: state.dsOutSlope1.minValue,
      maxValue: state.dsOutSlope1.maxValue,
    );
    RangeFloatPointInput dsOutSlope3 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsOutSlope3] ?? '',
      minValue: state.dsOutSlope3.minValue,
      maxValue: state.dsOutSlope3.maxValue,
    );
    RangeFloatPointInput dsOutSlope4 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsOutSlope4] ?? '',
      minValue: state.dsOutSlope4.minValue,
      maxValue: state.dsOutSlope4.maxValue,
    );
    RangeFloatPointInput dsOutSlope6 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsOutSlope6] ?? '',
      minValue: state.dsOutSlope6.minValue,
      maxValue: state.dsOutSlope6.maxValue,
    );
    RangeIntegerInput biasCurrent1 = initialRangeIntegerInput(
      characteristicDataCache[DataKey.biasCurrent1] ?? '',
      minValue: state.biasCurrent1.minValue,
      maxValue: state.biasCurrent1.maxValue,
    );
    RangeIntegerInput biasCurrent3 = initialRangeIntegerInput(
      characteristicDataCache[DataKey.biasCurrent3] ?? '',
      minValue: state.biasCurrent3.minValue,
      maxValue: state.biasCurrent3.maxValue,
    );
    RangeIntegerInput biasCurrent4 = initialRangeIntegerInput(
      characteristicDataCache[DataKey.biasCurrent4] ?? '',
      minValue: state.biasCurrent4.minValue,
      maxValue: state.biasCurrent4.maxValue,
    );
    RangeIntegerInput biasCurrent6 = initialRangeIntegerInput(
      characteristicDataCache[DataKey.biasCurrent6] ?? '',
      minValue: state.biasCurrent6.minValue,
      maxValue: state.biasCurrent6.maxValue,
    );
    RangeFloatPointInput usVCA1 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.usVCA1] ?? '',
      minValue: state.usVCA1.minValue,
      maxValue: state.usVCA1.maxValue,
    );
    RangeFloatPointInput usVCA3 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.usVCA3] ?? '',
      minValue: state.usVCA3.minValue,
      maxValue: state.usVCA3.maxValue,
    );
    RangeFloatPointInput usVCA4 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.usVCA4] ?? '',
      minValue: state.usVCA4.minValue,
      maxValue: state.usVCA4.maxValue,
    );
    RangeFloatPointInput usVCA6 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.usVCA6] ?? '',
      minValue: state.usVCA6.minValue,
      maxValue: state.usVCA6.maxValue,
    );
    String returnIngressSetting1 =
        characteristicDataCache[DataKey.ingressSetting1] ?? '';
    String returnIngressSetting3 =
        characteristicDataCache[DataKey.ingressSetting3] ?? '';
    String returnIngressSetting4 =
        characteristicDataCache[DataKey.ingressSetting4] ?? '';
    String returnIngressSetting6 =
        characteristicDataCache[DataKey.ingressSetting6] ?? '';

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      forwardConfig: forwardConfig,
      splitOption: splitOption,
      dsVVA1: dsVVA1,
      dsVVA3: dsVVA3,
      dsVVA4: dsVVA4,
      dsVVA6: dsVVA6,
      dsInSlope1: dsInSlope1,
      dsInSlope3: dsInSlope3,
      dsInSlope4: dsInSlope4,
      dsInSlope6: dsInSlope6,
      dsOutSlope1: dsOutSlope1,
      dsOutSlope3: dsOutSlope3,
      dsOutSlope4: dsOutSlope4,
      dsOutSlope6: dsOutSlope6,
      biasCurrent1: biasCurrent1,
      biasCurrent3: biasCurrent3,
      biasCurrent4: biasCurrent4,
      biasCurrent6: biasCurrent6,
      usVCA1: usVCA1,
      usVCA3: usVCA3,
      usVCA4: usVCA4,
      usVCA6: usVCA6,
      returnIngressSetting1: returnIngressSetting1,
      returnIngressSetting3: returnIngressSetting3,
      returnIngressSetting4: returnIngressSetting4,
      returnIngressSetting6: returnIngressSetting6,
      initialValues: characteristicDataCache,
      enableSubmission: false,
      settingResult: const [],
    ));
  }

  void _onForwardConfigChanged(
    ForwardConfigChanged event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    emit(state.copyWith(
      forwardConfig: event.forwardConfig,
      enableSubmission: _isEnabledSubmission(
        forwardConfig: event.forwardConfig,
      ),
    ));
  }

  void _onSplitOptionChanged(
    SplitOptionChanged event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    emit(state.copyWith(
      splitOption: event.splitOption,
      enableSubmission: _isEnabledSubmission(
        splitOption: event.splitOption,
      ),
    ));
  }

  void _onDSVVA1Changed(
    DSVVA1Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    RangeFloatPointInput dsVVA1 = RangeFloatPointInput.dirty(
      event.dsVVA1,
      minValue: state.dsVVA1.minValue,
      maxValue: state.dsVVA1.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA1: dsVVA1,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: dsVVA1,
      ),
    ));
  }

  void _onDSVVA3Changed(
    DSVVA3Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    RangeFloatPointInput dsVVA3 = RangeFloatPointInput.dirty(
      event.dsVVA3,
      minValue: state.dsVVA3.minValue,
      maxValue: state.dsVVA3.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA3: dsVVA3,
      enableSubmission: _isEnabledSubmission(
        forwardConfig: state.forwardConfig,
        splitOption: state.splitOption,
        dsVVA3: dsVVA3,
      ),
    ));
  }

  void _onDSVVA4Changed(
    DSVVA4Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    RangeFloatPointInput dsVVA4 = RangeFloatPointInput.dirty(
      event.dsVVA4,
      minValue: state.dsVVA4.minValue,
      maxValue: state.dsVVA4.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA4: dsVVA4,
      enableSubmission: _isEnabledSubmission(
        dsVVA4: dsVVA4,
      ),
    ));
  }

  void _onDSVVA6Changed(
    DSVVA6Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    RangeFloatPointInput dsVVA6 = RangeFloatPointInput.dirty(
      event.dsVVA6,
      minValue: state.dsVVA6.minValue,
      maxValue: state.dsVVA6.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA6: dsVVA6,
      enableSubmission: _isEnabledSubmission(
        dsVVA6: dsVVA6,
      ),
    ));
  }

  void _onDSInSlope1Changed(
    DSInSlope1Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    RangeFloatPointInput dsInSlope1 = RangeFloatPointInput.dirty(
      event.dsInSlope1,
      minValue: state.dsInSlope1.minValue,
      maxValue: state.dsInSlope1.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsInSlope1: dsInSlope1,
      enableSubmission: _isEnabledSubmission(
        dsInSlope1: dsInSlope1,
      ),
    ));
  }

  void _onDSInSlope3Changed(
    DSInSlope3Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    RangeFloatPointInput dsInSlope3 = RangeFloatPointInput.dirty(
      event.dsInSlope3,
      minValue: state.dsInSlope3.minValue,
      maxValue: state.dsInSlope3.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsInSlope3: dsInSlope3,
      enableSubmission: _isEnabledSubmission(
        dsInSlope3: dsInSlope3,
      ),
    ));
  }

  void _onDSInSlope4Changed(
    DSInSlope4Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    RangeFloatPointInput dsInSlope4 = RangeFloatPointInput.dirty(
      event.dsInSlope4,
      minValue: state.dsInSlope4.minValue,
      maxValue: state.dsInSlope4.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsInSlope4: dsInSlope4,
      enableSubmission: _isEnabledSubmission(
        dsInSlope4: dsInSlope4,
      ),
    ));
  }

  void _onDSInSlope6Changed(
    DSInSlope6Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    RangeFloatPointInput dsInSlope6 = RangeFloatPointInput.dirty(
      event.dsInSlope6,
      minValue: state.dsInSlope6.minValue,
      maxValue: state.dsInSlope6.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsInSlope6: dsInSlope6,
      enableSubmission: _isEnabledSubmission(
        dsInSlope6: dsInSlope6,
      ),
    ));
  }

  void _onDSOutSlope1Changed(
    DSOutSlope1Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    RangeFloatPointInput dsOutSlope1 = RangeFloatPointInput.dirty(
      event.dsOutSlope1,
      minValue: state.dsOutSlope1.minValue,
      maxValue: state.dsOutSlope1.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsOutSlope1: dsOutSlope1,
      enableSubmission: _isEnabledSubmission(
        dsOutSlope1: dsOutSlope1,
      ),
    ));
  }

  void _onDSOutSlope3Changed(
    DSOutSlope3Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    RangeFloatPointInput dsOutSlope3 = RangeFloatPointInput.dirty(
      event.dsOutSlope3,
      minValue: state.dsOutSlope3.minValue,
      maxValue: state.dsOutSlope3.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsOutSlope3: dsOutSlope3,
      enableSubmission: _isEnabledSubmission(
        dsOutSlope3: dsOutSlope3,
      ),
    ));
  }

  void _onDSOutSlope4Changed(
    DSOutSlope4Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    RangeFloatPointInput dsOutSlope4 = RangeFloatPointInput.dirty(
      event.dsOutSlope4,
      minValue: state.dsOutSlope4.minValue,
      maxValue: state.dsOutSlope4.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsOutSlope4: dsOutSlope4,
      enableSubmission: _isEnabledSubmission(
        dsOutSlope4: dsOutSlope4,
      ),
    ));
  }

  void _onDSOutSlope6Changed(
    DSOutSlope6Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    RangeFloatPointInput dsOutSlope6 = RangeFloatPointInput.dirty(
      event.dsOutSlope6,
      minValue: state.dsOutSlope6.minValue,
      maxValue: state.dsOutSlope6.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsOutSlope6: dsOutSlope6,
      enableSubmission: _isEnabledSubmission(
        dsOutSlope6: dsOutSlope6,
      ),
    ));
  }

  void _onBiasCurrent1Changed(
    BiasCurrent1Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    RangeIntegerInput biasCurrent1 = RangeIntegerInput.dirty(
      event.biasCurrent1,
      minValue: state.biasCurrent1.minValue,
      maxValue: state.biasCurrent1.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      biasCurrent1: biasCurrent1,
      enableSubmission: _isEnabledSubmission(
        biasCurrent1: biasCurrent1,
      ),
    ));
  }

  void _onBiasCurrent3Changed(
    BiasCurrent3Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    RangeIntegerInput biasCurrent3 = RangeIntegerInput.dirty(
      event.biasCurrent3,
      minValue: state.biasCurrent3.minValue,
      maxValue: state.biasCurrent3.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      biasCurrent3: biasCurrent3,
      enableSubmission: _isEnabledSubmission(
        biasCurrent3: biasCurrent3,
      ),
    ));
  }

  void _onBiasCurrent4Changed(
    BiasCurrent4Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    RangeIntegerInput biasCurrent4 = RangeIntegerInput.dirty(
      event.biasCurrent4,
      minValue: state.biasCurrent4.minValue,
      maxValue: state.biasCurrent4.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      biasCurrent4: biasCurrent4,
      enableSubmission: _isEnabledSubmission(
        biasCurrent4: biasCurrent4,
      ),
    ));
  }

  void _onBiasCurrent6Changed(
    BiasCurrent6Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    RangeIntegerInput biasCurrent6 = RangeIntegerInput.dirty(
      event.biasCurrent6,
      minValue: state.biasCurrent6.minValue,
      maxValue: state.biasCurrent6.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      biasCurrent6: biasCurrent6,
      enableSubmission: _isEnabledSubmission(
        biasCurrent6: biasCurrent6,
      ),
    ));
  }

  void _onUSVCA1Changed(
    USVCA1Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    RangeFloatPointInput usVCA1 = RangeFloatPointInput.dirty(
      event.usVCA1,
      minValue: state.usVCA1.minValue,
      maxValue: state.usVCA1.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA1: usVCA1,
      enableSubmission: _isEnabledSubmission(
        usVCA1: usVCA1,
      ),
    ));
  }

  void _onUSVCA3Changed(
    USVCA3Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    RangeFloatPointInput usVCA3 = RangeFloatPointInput.dirty(
      event.usVCA3,
      minValue: state.usVCA3.minValue,
      maxValue: state.usVCA3.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA3: usVCA3,
      enableSubmission: _isEnabledSubmission(
        usVCA3: usVCA3,
      ),
    ));
  }

  void _onUSVCA4Changed(
    USVCA4Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    RangeFloatPointInput usVCA4 = RangeFloatPointInput.dirty(
      event.usVCA4,
      minValue: state.usVCA4.minValue,
      maxValue: state.usVCA4.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA4: usVCA4,
      enableSubmission: _isEnabledSubmission(
        usVCA4: usVCA4,
      ),
    ));
  }

  void _onUSVCA6Changed(
    USVCA6Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    RangeFloatPointInput usVCA6 = RangeFloatPointInput.dirty(
      event.usVCA6,
      minValue: state.usVCA6.minValue,
      maxValue: state.usVCA6.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA6: usVCA6,
      enableSubmission: _isEnabledSubmission(
        usVCA6: usVCA6,
      ),
    ));
  }

  void _onReturnIngressSetting1Changed(
    ReturnIngressSetting1Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnIngressSetting1: event.returnIngressSetting1,
      enableSubmission: _isEnabledSubmission(
        returnIngressSetting1: event.returnIngressSetting1,
      ),
    ));
  }

  void _onReturnIngressSetting3Changed(
    ReturnIngressSetting3Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnIngressSetting3: event.returnIngressSetting3,
      enableSubmission: _isEnabledSubmission(
        returnIngressSetting3: event.returnIngressSetting3,
      ),
    ));
  }

  void _onReturnIngressSetting4Changed(
    ReturnIngressSetting4Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnIngressSetting4: event.returnIngressSetting4,
      enableSubmission: _isEnabledSubmission(
        returnIngressSetting4: event.returnIngressSetting4,
      ),
    ));
  }

  void _onReturnIngressSetting6Changed(
    ReturnIngressSetting6Changed event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnIngressSetting6: event.returnIngressSetting6,
      enableSubmission: _isEnabledSubmission(
        returnIngressSetting6: event.returnIngressSetting6,
      ),
    ));
  }

  bool _isEnabledSubmission({
    String? forwardConfig,
    String? splitOption,
    RangeFloatPointInput? dsVVA1,
    RangeFloatPointInput? dsVVA3,
    RangeFloatPointInput? dsVVA4,
    RangeFloatPointInput? dsVVA6,
    RangeFloatPointInput? dsInSlope1,
    RangeFloatPointInput? dsInSlope3,
    RangeFloatPointInput? dsInSlope4,
    RangeFloatPointInput? dsInSlope6,
    RangeFloatPointInput? dsOutSlope1,
    RangeFloatPointInput? dsOutSlope3,
    RangeFloatPointInput? dsOutSlope4,
    RangeFloatPointInput? dsOutSlope6,
    RangeIntegerInput? biasCurrent1,
    RangeIntegerInput? biasCurrent3,
    RangeIntegerInput? biasCurrent4,
    RangeIntegerInput? biasCurrent6,
    RangeFloatPointInput? usVCA1,
    RangeFloatPointInput? usVCA3,
    RangeFloatPointInput? usVCA4,
    RangeFloatPointInput? usVCA6,
    String? returnIngressSetting1,
    String? returnIngressSetting3,
    String? returnIngressSetting4,
    String? returnIngressSetting6,
  }) {
    forwardConfig ??= state.forwardConfig;
    splitOption ??= state.splitOption;
    dsVVA1 ??= state.dsVVA1;
    dsVVA3 ??= state.dsVVA3;
    dsVVA4 ??= state.dsVVA4;
    dsVVA6 ??= state.dsVVA6;
    dsInSlope1 ??= state.dsInSlope1;
    dsInSlope3 ??= state.dsInSlope3;
    dsInSlope4 ??= state.dsInSlope4;
    dsInSlope6 ??= state.dsInSlope6;
    dsOutSlope1 ??= state.dsOutSlope1;
    dsOutSlope3 ??= state.dsOutSlope3;
    dsOutSlope4 ??= state.dsOutSlope4;
    dsOutSlope6 ??= state.dsOutSlope6;
    biasCurrent1 ??= state.biasCurrent1;
    biasCurrent3 ??= state.biasCurrent3;
    biasCurrent4 ??= state.biasCurrent4;
    biasCurrent6 ??= state.biasCurrent6;
    usVCA1 ??= state.usVCA1;
    usVCA3 ??= state.usVCA3;
    usVCA4 ??= state.usVCA4;
    usVCA6 ??= state.usVCA6;
    returnIngressSetting1 ??= state.returnIngressSetting1;
    returnIngressSetting3 ??= state.returnIngressSetting3;
    returnIngressSetting4 ??= state.returnIngressSetting4;
    returnIngressSetting6 ??= state.returnIngressSetting6;

    if (dsVVA1.isNotValid ||
        dsVVA3.isNotValid ||
        dsVVA4.isNotValid ||
        dsVVA6.isNotValid ||
        dsInSlope1.isNotValid ||
        dsInSlope3.isNotValid ||
        dsInSlope4.isNotValid ||
        dsInSlope6.isNotValid ||
        dsOutSlope1.isNotValid ||
        dsOutSlope3.isNotValid ||
        dsOutSlope4.isNotValid ||
        dsOutSlope6.isNotValid ||
        biasCurrent1.isNotValid ||
        biasCurrent3.isNotValid ||
        biasCurrent4.isNotValid ||
        biasCurrent6.isNotValid ||
        usVCA1.isNotValid ||
        usVCA3.isNotValid ||
        usVCA4.isNotValid ||
        usVCA6.isNotValid) {
      return false;
    } else {
      if (forwardConfig != state.initialValues[DataKey.forwardConfig] ||
          splitOption != state.initialValues[DataKey.splitOption] ||
          dsVVA1.value != state.initialValues[DataKey.dsVVA1] ||
          dsVVA3.value != state.initialValues[DataKey.dsVVA3] ||
          dsVVA4.value != state.initialValues[DataKey.dsVVA4] ||
          dsVVA6.value != state.initialValues[DataKey.dsVVA6] ||
          dsInSlope1.value != state.initialValues[DataKey.dsInSlope1] ||
          dsInSlope3.value != state.initialValues[DataKey.dsInSlope3] ||
          dsInSlope4.value != state.initialValues[DataKey.dsInSlope4] ||
          dsInSlope6.value != state.initialValues[DataKey.dsInSlope6] ||
          dsOutSlope1.value != state.initialValues[DataKey.dsOutSlope1] ||
          dsOutSlope3.value != state.initialValues[DataKey.dsOutSlope3] ||
          dsOutSlope4.value != state.initialValues[DataKey.dsOutSlope4] ||
          dsOutSlope6.value != state.initialValues[DataKey.dsOutSlope6] ||
          biasCurrent1.value != state.initialValues[DataKey.biasCurrent1] ||
          biasCurrent3.value != state.initialValues[DataKey.biasCurrent3] ||
          biasCurrent4.value != state.initialValues[DataKey.biasCurrent4] ||
          biasCurrent6.value != state.initialValues[DataKey.biasCurrent6] ||
          usVCA1.value != state.initialValues[DataKey.usVCA1] ||
          usVCA3.value != state.initialValues[DataKey.usVCA3] ||
          usVCA4.value != state.initialValues[DataKey.usVCA4] ||
          usVCA6.value != state.initialValues[DataKey.usVCA6] ||
          returnIngressSetting1 !=
              state.initialValues[DataKey.ingressSetting1] ||
          returnIngressSetting3 !=
              state.initialValues[DataKey.ingressSetting3] ||
          returnIngressSetting4 !=
              state.initialValues[DataKey.ingressSetting4] ||
          returnIngressSetting6 !=
              state.initialValues[DataKey.ingressSetting6]) {
        return true;
      } else {
        return false;
      }
    }
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18CCorNodeGraphModuleState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    List<String> settingResult = [];

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

    if (state.dsInSlope1.value != state.initialValues[DataKey.dsInSlope1]) {
      bool resultOfSetDSInSlope1 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSInSlope1(state.dsInSlope1.value);

      settingResult.add('${DataKey.dsInSlope1.name},$resultOfSetDSInSlope1');
    }

    if (state.dsInSlope3.value != state.initialValues[DataKey.dsInSlope3]) {
      bool resultOfSetDSInSlope3 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSInSlope3(state.dsInSlope3.value);

      settingResult.add('${DataKey.dsInSlope3.name},$resultOfSetDSInSlope3');
    }

    if (state.dsInSlope4.value != state.initialValues[DataKey.dsInSlope4]) {
      bool resultOfSetDSInSlope4 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSInSlope4(state.dsInSlope4.value);

      settingResult.add('${DataKey.dsInSlope4.name},$resultOfSetDSInSlope4');
    }

    if (state.dsInSlope6.value != state.initialValues[DataKey.dsInSlope6]) {
      bool resultOfSetDSInSlope6 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSInSlope6(state.dsInSlope6.value);

      settingResult.add('${DataKey.dsInSlope6.name},$resultOfSetDSInSlope6');
    }

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

    if (state.usVCA1.value != state.initialValues[DataKey.usVCA1]) {
      bool resultOfSetUSVCA1 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeUSVCA1(state.usVCA1.value);

      settingResult.add('${DataKey.usVCA1.name},$resultOfSetUSVCA1');
    }

    if (state.usVCA3.value != state.initialValues[DataKey.usVCA3]) {
      bool resultOfSetUSVCA3 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeUSVCA3(state.usVCA3.value);

      settingResult.add('${DataKey.usVCA3.name},$resultOfSetUSVCA3');
    }

    if (state.usVCA4.value != state.initialValues[DataKey.usVCA4]) {
      bool resultOfSetUSVCA4 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeUSVCA4(state.usVCA4.value);

      settingResult.add('${DataKey.usVCA4.name},$resultOfSetUSVCA4');
    }

    if (state.usVCA6.value != state.initialValues[DataKey.usVCA6]) {
      bool resultOfSetUSVCA6 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeUSVCA6(state.usVCA6.value);

      settingResult.add('${DataKey.usVCA6.name},$resultOfSetUSVCA6');
    }

    if (state.returnIngressSetting1 !=
        state.initialValues[DataKey.ingressSetting1]) {
      bool resultOfSetReturnIngress1 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeReturnIngress1(state.returnIngressSetting1);

      settingResult
          .add('${DataKey.ingressSetting1.name},$resultOfSetReturnIngress1');
    }
    if (state.returnIngressSetting3 !=
        state.initialValues[DataKey.ingressSetting3]) {
      bool resultOfSetReturnIngress3 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeReturnIngress3(state.returnIngressSetting3);

      settingResult
          .add('${DataKey.ingressSetting3.name},$resultOfSetReturnIngress3');
    }
    if (state.returnIngressSetting4 !=
        state.initialValues[DataKey.ingressSetting4]) {
      bool resultOfSetReturnIngress4 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeReturnIngress4(state.returnIngressSetting4);

      settingResult
          .add('${DataKey.ingressSetting4.name},$resultOfSetReturnIngress4');
    }
    if (state.returnIngressSetting6 !=
        state.initialValues[DataKey.ingressSetting6]) {
      bool resultOfSetReturnIngress6 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeReturnIngress6(state.returnIngressSetting6);

      settingResult
          .add('${DataKey.ingressSetting6.name},$resultOfSetReturnIngress6');
    }

    // 等待 device 完成更新後在讀取值
    await Future.delayed(const Duration(milliseconds: 1000));

    await _amp18CCorNodeRepository.update1p8GCCorNodeCharacteristics();

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
      enableSubmission: false,
    ));
  }
}
