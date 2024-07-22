import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:aci_plus_app/setting/model/formz_input_initializer.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    on<DSVVA1Changed>(_onDSVVA1Changed);
    on<DSVVA4Changed>(_onDSVVA4Changed);
    on<DSVVA5Changed>(_onDSVVA5Changed);
    on<DSSlope1Changed>(_onDSSlope1Changed);
    on<DSSlope3Changed>(_onDSSlope3Changed);
    on<DSSlope4Changed>(_onDSSlope4Changed);
    on<USVCA1Changed>(_onUSVCA1Changed);
    on<USVCA2Changed>(_onUSVCA2Changed);
    on<USVCA3Changed>(_onUSVCA3Changed);
    on<USVCA4Changed>(_onUSVCA4Changed);
    on<EREQChanged>(_onEREQChanged);
    on<RtnIngressSetting2Changed>(_onRtnIngressSetting2Changed);
    on<RtnIngressSetting3Changed>(_onRtnIngressSetting3Changed);
    on<RtnIngressSetting4Changed>(_onRtnIngressSetting4Changed);
    // on<TGCCableLengthChanged>(_onTGCCableLengthChanged);
    // on<USTGCChanged>(_onUSTGCChanged);
    on<SplitOptionChanged>(_onSplitOptionChanged);
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

  void _onInitialized(
    Initialized event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    // ex: C-coe LE 沒有 VVA4, VVA5, VCA3, VCA4, 讀到的值是 -0.1, 不符合範圍, 所以改成 0.0 作為初始值
    characteristicDataCache.forEach((key, value) {
      if (value == '-0.1') {
        characteristicDataCache[key] = '0.0';
      }
    });

    String forwardCEQIndex =
        characteristicDataCache[DataKey.forwardCEQIndex] ?? '';

    String partId = characteristicDataCache[DataKey.partId] ?? '';
    RangeFloatPointInput dsVVA1 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsVVA1] ?? '',
      minValue: state.dsVVA1.minValue,
      maxValue: state.dsVVA1.maxValue,
    );

    RangeFloatPointInput dsVVA4 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsVVA4] ?? '',
      minValue: state.dsVVA4.minValue,
      maxValue: state.dsVVA4.maxValue,
    );
    RangeFloatPointInput dsVVA5 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsVVA5] ?? '',
      minValue: state.dsVVA5.minValue,
      maxValue: state.dsVVA5.maxValue,
    );
    RangeFloatPointInput dsSlope1 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsSlope1] ?? '',
      minValue: state.dsSlope1.minValue,
      maxValue: getSlope1MaxValue(forwardCEQIndex),
    );

    RangeFloatPointInput dsSlope3 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsSlope3] ?? '',
      minValue: state.dsSlope3.minValue,
      maxValue: state.dsSlope3.maxValue,
    );
    RangeFloatPointInput dsSlope4 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.dsSlope4] ?? '',
      minValue: state.dsSlope4.minValue,
      maxValue: state.dsSlope4.maxValue,
    );
    RangeFloatPointInput usVCA1 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.usVCA1] ?? '',
      minValue: state.usVCA1.minValue,
      maxValue: state.usVCA1.maxValue,
    );
    RangeFloatPointInput usVCA2 = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.usVCA2] ?? '',
      minValue: state.usVCA2.minValue,
      maxValue: state.usVCA2.maxValue,
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

    RangeFloatPointInput eREQ = initialRangeFloatPointInput(
      characteristicDataCache[DataKey.eREQ] ?? '',
      minValue: state.eREQ.minValue,
      maxValue: state.eREQ.maxValue,
    );
    String ingressSetting2 =
        characteristicDataCache[DataKey.ingressSetting2] ?? '';
    String ingressSetting3 =
        characteristicDataCache[DataKey.ingressSetting3] ?? '';
    String ingressSetting4 =
        characteristicDataCache[DataKey.ingressSetting4] ?? '';
    String tgcCableLength =
        characteristicDataCache[DataKey.tgcCableLength] ?? '';
    // String usTGC = characteristicDataCache[DataKey.usTGC] ?? '';
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

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA1: dsVVA1,
      dsVVA4: dsVVA4,
      dsVVA5: dsVVA5,
      dsSlope1: dsSlope1,
      dsSlope3: dsSlope3,
      dsSlope4: dsSlope4,
      usVCA1: usVCA1,
      usVCA2: usVCA2,
      usVCA3: usVCA3,
      usVCA4: usVCA4,
      eREQ: eREQ,
      returnIngressSetting2: ingressSetting2,
      returnIngressSetting3: ingressSetting3,
      returnIngressSetting4: ingressSetting4,
      tgcCableLength: tgcCableLength,
      // usTGC: usTGC,
      splitOption: splitOption,
      pilotFrequencyMode: pilotFrequencyMode,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency.isNotEmpty
          ? IntegerInput.dirty(firstChannelLoadingFrequency)
          : const IntegerInput.pure(),
      firstChannelLoadingLevel: FloatPointInput.dirty(firstChannelLoadingLevel),
      lastChannelLoadingFrequency:
          IntegerInput.dirty(lastChannelLoadingFrequency),
      lastChannelLoadingLevel: FloatPointInput.dirty(lastChannelLoadingLevel),
      pilotFrequency1: IntegerInput.dirty(pilotFrequency1),
      pilotFrequency2: IntegerInput.dirty(pilotFrequency2),
      manualModePilot1RFOutputPower: manualModePilot1RFOutputPower,
      manualModePilot2RFOutputPower: manualModePilot2RFOutputPower,
      agcMode: agcMode,
      alcMode: alcMode,
      isInitialize: true,
      initialValues: characteristicDataCache,
      editMode: _editable,
      enableSubmission: false,
      settingResult: const [],
    ));
  }

  void _onDSVVA1Changed(
    DSVVA1Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput dsVVA1 = RangeFloatPointInput.dirty(
      event.dsVVA1,
      minValue: state.dsVVA1.minValue,
      maxValue: state.dsVVA1.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA1: dsVVA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: dsVVA1,
      ),
    ));
  }

  void _onDSVVA4Changed(
    DSVVA4Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput dsVVA4 = RangeFloatPointInput.dirty(
      event.dsVVA4,
      minValue: state.dsVVA4.minValue,
      maxValue: state.dsVVA4.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA4: dsVVA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA4: dsVVA4,
      ),
    ));
  }

  void _onDSVVA5Changed(
    DSVVA5Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput dsVVA5 = RangeFloatPointInput.dirty(
      event.dsVVA5,
      minValue: state.dsVVA5.minValue,
      maxValue: state.dsVVA5.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA5: dsVVA5,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA5: dsVVA5,
      ),
    ));
  }

  void _onDSSlope1Changed(
    DSSlope1Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput dsSlope1 = RangeFloatPointInput.dirty(
      event.dsSlope1,
      minValue: state.dsSlope1.minValue,
      maxValue: state.dsSlope1.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope1: dsSlope1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsSlope1: dsSlope1,
      ),
    ));
  }

  void _onDSSlope3Changed(
    DSSlope3Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput dsSlope3 = RangeFloatPointInput.dirty(
      event.dsSlope3,
      minValue: state.dsSlope3.minValue,
      maxValue: state.dsSlope3.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope3: dsSlope3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsSlope3: dsSlope3,
      ),
    ));
  }

  void _onDSSlope4Changed(
    DSSlope4Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput dsSlope4 = RangeFloatPointInput.dirty(
      event.dsSlope4,
      minValue: state.dsSlope4.minValue,
      maxValue: state.dsSlope4.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope4: dsSlope4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsSlope4: dsSlope4,
      ),
    ));
  }

  void _onUSVCA1Changed(
    USVCA1Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput usVCA1 = RangeFloatPointInput.dirty(
      event.usVCA1,
      minValue: state.usVCA1.minValue,
      maxValue: state.usVCA1.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA1: usVCA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        usVCA1: usVCA1,
      ),
    ));
  }

  void _onUSVCA2Changed(
    USVCA2Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput usVCA2 = RangeFloatPointInput.dirty(
      event.usVCA2,
      minValue: state.usVCA2.minValue,
      maxValue: state.usVCA2.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA2: usVCA2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        usVCA2: usVCA2,
      ),
    ));
  }

  void _onUSVCA3Changed(
    USVCA3Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput usVCA3 = RangeFloatPointInput.dirty(
      event.usVCA3,
      minValue: state.usVCA3.minValue,
      maxValue: state.usVCA3.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA3: usVCA3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        usVCA3: usVCA3,
      ),
    ));
  }

  void _onUSVCA4Changed(
    USVCA4Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput usVCA4 = RangeFloatPointInput.dirty(
      event.usVCA4,
      minValue: state.usVCA4.minValue,
      maxValue: state.usVCA4.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA4: usVCA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        usVCA4: usVCA4,
      ),
    ));
  }

  void _onEREQChanged(
    EREQChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    RangeFloatPointInput eREQ = RangeFloatPointInput.dirty(
      event.eREQ,
      minValue: state.eREQ.minValue,
      maxValue: state.eREQ.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      eREQ: eREQ,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        eREQ: eREQ,
      ),
    ));
  }

  void _onRtnIngressSetting2Changed(
    RtnIngressSetting2Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnIngressSetting2: event.returnIngressSetting2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        returnIngressSetting2: event.returnIngressSetting2,
      ),
    ));
  }

  void _onRtnIngressSetting3Changed(
    RtnIngressSetting3Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnIngressSetting3: event.returnIngressSetting3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        returnIngressSetting3: event.returnIngressSetting3,
      ),
    ));
  }

  void _onRtnIngressSetting4Changed(
    RtnIngressSetting4Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnIngressSetting4: event.returnIngressSetting4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        returnIngressSetting4: event.returnIngressSetting4,
      ),
    ));
  }

  // void _onTGCCableLengthChanged(
  //   TGCCableLengthChanged event,
  //   Emitter<Setting18GraphModuleState> emit,
  // ) {
  //   emit(state.copyWith(
  //     submissionStatus: SubmissionStatus.none,
  //     tgcCableLength: event.tgcCableLength,
  //     isInitialize: false,
  //     enableSubmission: _isEnabledSubmission(
  //       tgcCableLength: event.tgcCableLength,
  //     ),
  //   ));
  // }

  // void _onUSTGCChanged(
  //   USTGCChanged event,
  //   Emitter<Setting18GraphModuleState> emit,
  // ) {
  //   emit(state.copyWith(
  //     submissionStatus: SubmissionStatus.none,
  //     usTGC: event.usTGC,
  //     isInitialize: false,
  //     enableSubmission: _isEnabledSubmission(
  //       fwdInputAttenuation: state.fwdInputAttenuation,
  //       dsSlope1: state.dsSlope1,
  //       usVCA1: state.usVCA1,
  //       returnInputAttenuation3: state.returnInputAttenuation3,
  //       returnInputAttenuation4: state.returnInputAttenuation4,
  //       usVCA2: state.usVCA2,
  //       eREQ: state.eREQ,
  //       returnIngressSetting2: state.returnIngressSetting2,
  //       returnIngressSetting3: state.returnIngressSetting3,
  //       returnIngressSetting4: state.returnIngressSetting4,
  //       tgcCableLength: state.tgcCableLength,
  //       dsVVA2: state.dsVVA2,
  //       dsSlope2: state.dsSlope2,
  //       dsVVA3: state.dsVVA3,
  //       dsVVA4: state.dsVVA4,
  //       usTGC: event.usTGC,
  //       splitOption: state.splitOption,
  //       pilotFrequencyMode: state.pilotFrequencyMode,
  //       firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
  //       firstChannelLoadingLevel: state.firstChannelLoadingLevel,
  //       lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
  //       lastChannelLoadingLevel: state.lastChannelLoadingLevel,
  //       pilotFrequency1: state.pilotFrequency1,
  //       pilotFrequency2: state.pilotFrequency2,
  //     ),
  //   ));
  // }

  void _onSplitOptionChanged(
    SplitOptionChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      splitOption: event.splitOption,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        splitOption: event.splitOption,
      ),
    ));
  }

  void _onPilotFrequencyModeChanged(
    PilotFrequencyModeChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      pilotFrequencyMode: event.pilotFrequencyMode,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        pilotFrequencyMode: event.pilotFrequencyMode,
      ),
    ));
  }

  void _onFirstChannelLoadingFrequencyChanged(
    FirstChannelLoadingFrequencyChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    IntegerInput firstChannelLoadingFrequency =
        IntegerInput.dirty(event.firstChannelLoadingFrequency);

    bool isValid = isValidFirstChannelLoadingFrequency(
      currentDetectedSplitOption: event.currentDetectedSplitOption,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency,
    );
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency,
      isInitialize: false,
      enableSubmission: isValid &&
          _isEnabledSubmission(
            firstChannelLoadingFrequency: firstChannelLoadingFrequency,
          ),
    ));
  }

  void _onFirstChannelLoadingLevelChanged(
    FirstChannelLoadingLevelChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    FloatPointInput firstChannelLoadingLevel =
        FloatPointInput.dirty(event.firstChannelLoadingLevel);
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      firstChannelLoadingLevel: firstChannelLoadingLevel,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        firstChannelLoadingLevel: firstChannelLoadingLevel,
      ),
    ));
  }

  void _onLastChannelLoadingFrequencyChanged(
    LastChannelLoadingFrequencyChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    IntegerInput lastChannelLoadingFrequency =
        IntegerInput.dirty(event.lastChannelLoadingFrequency);
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      lastChannelLoadingFrequency: lastChannelLoadingFrequency,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        lastChannelLoadingFrequency: lastChannelLoadingFrequency,
      ),
    ));
  }

  void _onLastChannelLoadingLevelChanged(
    LastChannelLoadingLevelChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    FloatPointInput lastChannelLoadingLevel =
        FloatPointInput.dirty(event.lastChannelLoadingLevel);
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      lastChannelLoadingLevel: lastChannelLoadingLevel,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        lastChannelLoadingLevel: lastChannelLoadingLevel,
      ),
    ));
  }

  void _onPilotFrequency1Changed(
    PilotFrequency1Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    IntegerInput pilotFrequency1 = IntegerInput.dirty(event.pilotFrequency1);
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      pilotFrequency1: pilotFrequency1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        pilotFrequency1: pilotFrequency1,
      ),
    ));
  }

  void _onPilotFrequency2Changed(
    PilotFrequency2Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    IntegerInput pilotFrequency2 = IntegerInput.dirty(event.pilotFrequency2);
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      pilotFrequency2: pilotFrequency2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        pilotFrequency2: pilotFrequency2,
      ),
    ));
  }

  void _onAGCModeChanged(
    AGCModeChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      agcMode: event.agcMode,
      alcMode: event.agcMode,
      isInitialize: false,
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
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      agcMode: event.alcMode,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        alcMode: event.alcMode,
      ),
    ));
  }

  bool _isEnabledSubmission({
    RangeFloatPointInput? dsVVA1,
    RangeFloatPointInput? dsVVA4,
    RangeFloatPointInput? dsVVA5,
    RangeFloatPointInput? dsSlope1,
    RangeFloatPointInput? dsSlope3,
    RangeFloatPointInput? dsSlope4,
    RangeFloatPointInput? usVCA1,
    RangeFloatPointInput? usVCA2,
    RangeFloatPointInput? usVCA3,
    RangeFloatPointInput? usVCA4,
    RangeFloatPointInput? eREQ,
    String? returnIngressSetting2,
    String? returnIngressSetting3,
    String? returnIngressSetting4,
    String? tgcCableLength,
    //  String usTGC,
    String? splitOption,
    IntegerInput? firstChannelLoadingFrequency,
    FloatPointInput? firstChannelLoadingLevel,
    IntegerInput? lastChannelLoadingFrequency,
    FloatPointInput? lastChannelLoadingLevel,
    String? pilotFrequencyMode,
    IntegerInput? pilotFrequency1,
    IntegerInput? pilotFrequency2,
    String? agcMode,
    String? alcMode,
  }) {
    dsVVA1 ??= state.dsVVA1;
    dsVVA4 ??= state.dsVVA4;
    dsVVA5 ??= state.dsVVA5;
    dsSlope1 ??= state.dsSlope1;
    dsSlope3 ??= state.dsSlope3;
    dsSlope4 ??= state.dsSlope4;
    usVCA1 ??= state.usVCA1;
    usVCA2 ??= state.usVCA2;
    usVCA3 ??= state.usVCA3;
    usVCA4 ??= state.usVCA4;
    eREQ ??= state.eREQ;
    returnIngressSetting2 ??= state.returnIngressSetting2;
    returnIngressSetting3 ??= state.returnIngressSetting3;
    returnIngressSetting4 ??= state.returnIngressSetting4;
    tgcCableLength ??= tgcCableLength;
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

    if (dsVVA1.isNotValid ||
        dsVVA4.isNotValid ||
        dsVVA5.isNotValid ||
        dsSlope1.isNotValid ||
        dsSlope3.isNotValid ||
        dsSlope4.isNotValid ||
        usVCA1.isNotValid ||
        usVCA2.isNotValid ||
        usVCA3.isNotValid ||
        usVCA4.isNotValid ||
        eREQ.isNotValid ||
        firstChannelLoadingFrequency.isNotValid ||
        firstChannelLoadingLevel.isNotValid ||
        lastChannelLoadingFrequency.isNotValid ||
        lastChannelLoadingLevel.isNotValid ||
        pilotFrequency1.isNotValid ||
        pilotFrequency2.isNotValid) {
      return false;
    } else {
      if (dsVVA1.value != state.initialValues[DataKey.dsVVA1] ||
          dsVVA4.value != state.initialValues[DataKey.dsVVA4] ||
          dsVVA5.value != state.initialValues[DataKey.dsVVA5] ||
          dsSlope1.value != state.initialValues[DataKey.dsSlope1] ||
          dsSlope3.value != state.initialValues[DataKey.dsSlope3] ||
          dsSlope4.value != state.initialValues[DataKey.dsSlope4] ||
          usVCA1.value != state.initialValues[DataKey.usVCA1] ||
          usVCA2.value != state.initialValues[DataKey.usVCA2] ||
          usVCA3.value != state.initialValues[DataKey.usVCA3] ||
          usVCA4.value != state.initialValues[DataKey.usVCA4] ||
          eREQ.value != state.initialValues[DataKey.eREQ] ||
          returnIngressSetting2 !=
              state.initialValues[DataKey.ingressSetting2] ||
          returnIngressSetting3 !=
              state.initialValues[DataKey.ingressSetting3] ||
          returnIngressSetting4 !=
              state.initialValues[DataKey.ingressSetting4] ||
          // usTGC != state.initialValues[DataKey.usTGC] ||
          splitOption != state.initialValues[DataKey.splitOption] ||
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
          alcMode != state.initialValues[DataKey.alcMode]) {
        return true;
      } else {
        return false;
      }
    }
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18GraphModuleState> emit,
  ) async {
    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    List<String> settingResult = [];

    if (state.dsVVA1.value != state.initialValues[DataKey.dsVVA1]) {
      bool resultOfSetDSVVA1 =
          await _amp18Repository.set1p8GDSVVA1(state.dsVVA1.value);

      settingResult.add('${DataKey.dsVVA1.name},$resultOfSetDSVVA1');
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

    if (state.eREQ.value != state.initialValues[DataKey.eREQ]) {
      bool resultOfSetEREQ =
          await _amp18Repository.set1p8GEREQ(state.eREQ.value);

      settingResult.add('${DataKey.eREQ.name},$resultOfSetEREQ');
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

    if (state.tgcCableLength != state.initialValues[DataKey.tgcCableLength]) {
      bool resultOfSetTGCCableLength =
          await _amp18Repository.set1p8GTGCCableLength(state.tgcCableLength);

      settingResult
          .add('${DataKey.tgcCableLength.name},$resultOfSetTGCCableLength');
    }

    // if (state.usTGC != state.initialValues[DataKey.usTGC]) {
    //   bool resultOfSetUSTGC = await _amp18Repository.set1p8USTGC(state.usTGC);

    //   settingResult.add('${DataKey.usTGC.name},$resultOfSetUSTGC');
    // }

    if (state.splitOption != state.initialValues[DataKey.splitOption]) {
      bool resultOfSetSplitOption =
          await _amp18Repository.set1p8GSplitOption(state.splitOption);

      settingResult.add('${DataKey.splitOption.name},$resultOfSetSplitOption');
    }

    if (state.pilotFrequencyMode !=
        state.initialValues[DataKey.pilotFrequencyMode]) {
      bool resultOfSetPilotFrequencyMode = await _amp18Repository
          .set1p8GPilotFrequencyMode(state.pilotFrequencyMode);

      settingResult.add(
          '${DataKey.pilotFrequencyMode.name},$resultOfSetPilotFrequencyMode');
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
      initialValues: _amp18Repository.characteristicDataCache,
    ));
  }
}
