import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_graph_module_event.dart';
part 'setting18_graph_module_state.dart';

class Setting18GraphModuleBloc
    extends Bloc<Setting18GraphModuleEvent, Setting18GraphModuleState> {
  Setting18GraphModuleBloc({required Amp18Repository amp18Repository})
      : _amp18Repository = amp18Repository,
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
    on<TGCCableLengthChanged>(_onTGCCableLengthChanged);
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

  void _onInitialized(
    Initialized event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;
    String partId = characteristicDataCache[DataKey.partId] ?? '';
    String dsVVA1 = characteristicDataCache[DataKey.dsVVA1] ?? '';
    String dsVVA4 = characteristicDataCache[DataKey.dsVVA4] ?? '';
    String dsVVA5 = characteristicDataCache[DataKey.dsVVA5] ?? '';
    String dsSlope1 = characteristicDataCache[DataKey.dsSlope1] ?? '';
    String dsSlope3 = characteristicDataCache[DataKey.dsSlope3] ?? '';
    String dsSlope4 = characteristicDataCache[DataKey.dsSlope4] ?? '';
    String usVCA1 = characteristicDataCache[DataKey.usVCA1] ?? '';
    String usVCA2 = characteristicDataCache[DataKey.usVCA2] ?? '';
    String usVCA3 = characteristicDataCache[DataKey.usVCA3] ?? '';
    String usVCA4 = characteristicDataCache[DataKey.usVCA4] ?? '';
    String eREQ = characteristicDataCache[DataKey.eREQ] ?? '';
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
    ));
  }

  void _onDSVVA1Changed(
    DSVVA1Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA1: event.dsVVA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: event.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,

        // // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
      ),
    ));
  }

  void _onDSVVA4Changed(
    DSVVA4Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA4: event.dsVVA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA4: event.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        // // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
      ),
    ));
  }

  void _onDSVVA5Changed(
    DSVVA5Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA5: event.dsVVA5,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: event.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        // // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
      ),
    ));
  }

  void _onDSSlope1Changed(
    DSSlope1Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope1: event.dsSlope1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: event.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
      ),
    ));
  }

  void _onDSSlope3Changed(
    DSSlope3Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope3: event.dsSlope3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: event.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
      ),
    ));
  }

  void _onDSSlope4Changed(
    DSSlope4Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope4: event.dsSlope4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: event.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
      ),
    ));
  }

  void _onUSVCA1Changed(
    USVCA1Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA1: event.usVCA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: event.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
      ),
    ));
  }

  void _onUSVCA2Changed(
    USVCA2Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA2: event.usVCA2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: event.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
      ),
    ));
  }

  void _onUSVCA3Changed(
    USVCA3Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA3: event.usVCA3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: event.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
      ),
    ));
  }

  void _onUSVCA4Changed(
    USVCA4Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA4: event.usVCA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: event.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
      ),
    ));
  }

  void _onEREQChanged(
    EREQChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      eREQ: event.eREQ,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: event.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
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
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: event.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
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
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: event.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
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
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: event.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
      ),
    ));
  }

  void _onTGCCableLengthChanged(
    TGCCableLengthChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      tgcCableLength: event.tgcCableLength,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: event.tgcCableLength,
        // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
      ),
    ));
  }

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
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        // usTGC: state.usTGC,
        splitOption: event.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
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
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,

        // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: event.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
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
            dsVVA1: state.dsVVA1,
            dsVVA4: state.dsVVA4,
            dsVVA5: state.dsVVA5,
            dsSlope1: state.dsSlope1,
            dsSlope3: state.dsSlope3,
            dsSlope4: state.dsSlope4,
            usVCA1: state.usVCA1,
            usVCA2: state.usVCA2,
            usVCA3: state.usVCA3,
            usVCA4: state.usVCA4,
            eREQ: state.eREQ,
            returnIngressSetting2: state.returnIngressSetting2,
            returnIngressSetting3: state.returnIngressSetting3,
            returnIngressSetting4: state.returnIngressSetting4,
            tgcCableLength: state.tgcCableLength,
            // usTGC: state.usTGC,
            splitOption: state.splitOption,
            pilotFrequencyMode: state.pilotFrequencyMode,
            firstChannelLoadingFrequency: firstChannelLoadingFrequency,
            firstChannelLoadingLevel: state.firstChannelLoadingLevel,
            lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
            lastChannelLoadingLevel: state.lastChannelLoadingLevel,
            pilotFrequency1: state.pilotFrequency1,
            pilotFrequency2: state.pilotFrequency2,
            agcMode: state.agcMode,
            alcMode: state.alcMode,
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
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
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
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
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
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
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
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
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
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: state.alcMode,
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
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
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
        dsVVA1: state.dsVVA1,
        dsVVA4: state.dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope1: state.dsSlope1,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        usVCA1: state.usVCA1,
        usVCA2: state.usVCA2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        // usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        agcMode: state.agcMode,
        alcMode: event.alcMode,
      ),
    ));
  }

  bool _isEnabledSubmission({
    required String dsVVA1,
    required String dsVVA4,
    required String dsVVA5,
    required String dsSlope1,
    required String dsSlope3,
    required String dsSlope4,
    required String usVCA1,
    required String usVCA2,
    required String usVCA3,
    required String usVCA4,
    required String eREQ,
    required String returnIngressSetting2,
    required String returnIngressSetting3,
    required String returnIngressSetting4,
    required String tgcCableLength,
    // required String usTGC,
    required String splitOption,
    required IntegerInput firstChannelLoadingFrequency,
    required FloatPointInput firstChannelLoadingLevel,
    required IntegerInput lastChannelLoadingFrequency,
    required FloatPointInput lastChannelLoadingLevel,
    required String pilotFrequencyMode,
    required IntegerInput pilotFrequency1,
    required IntegerInput pilotFrequency2,
    required String agcMode,
    required String alcMode,
  }) {
    if (dsVVA1 != state.initialValues[DataKey.dsVVA1] ||
        dsVVA4 != state.initialValues[DataKey.dsVVA4] ||
        dsVVA5 != state.initialValues[DataKey.dsVVA5] ||
        dsSlope1 != state.initialValues[DataKey.dsSlope1] ||
        dsSlope3 != state.initialValues[DataKey.dsSlope3] ||
        dsSlope4 != state.initialValues[DataKey.dsSlope4] ||
        usVCA1 != state.initialValues[DataKey.usVCA1] ||
        usVCA2 != state.initialValues[DataKey.usVCA2] ||
        usVCA3 != state.initialValues[DataKey.usVCA3] ||
        usVCA4 != state.initialValues[DataKey.usVCA4] ||
        eREQ != state.initialValues[DataKey.eREQ] ||
        returnIngressSetting2 != state.initialValues[DataKey.ingressSetting2] ||
        returnIngressSetting3 != state.initialValues[DataKey.ingressSetting3] ||
        returnIngressSetting4 != state.initialValues[DataKey.ingressSetting4] ||
        tgcCableLength != state.initialValues[DataKey.tgcCableLength] ||
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
        pilotFrequencyMode != state.initialValues[DataKey.pilotFrequencyMode] ||
        pilotFrequency1.value != state.initialValues[DataKey.pilotFrequency1] ||
        pilotFrequency2.value != state.initialValues[DataKey.pilotFrequency2] ||
        agcMode != state.initialValues[DataKey.agcMode] ||
        alcMode != state.initialValues[DataKey.alcMode]) {
      return true;
    } else {
      return false;
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

    if (state.dsVVA1 != state.initialValues[DataKey.dsVVA1]) {
      bool resultOfSetDSVVA1 =
          await _amp18Repository.set1p8GDSVVA1(state.dsVVA1);

      settingResult.add('${DataKey.dsVVA1.name},$resultOfSetDSVVA1');
    }

    if (state.dsVVA4 != state.initialValues[DataKey.dsVVA4]) {
      bool resultOfSetDSVVA4 =
          await _amp18Repository.set1p8GDSVVA4(state.dsVVA4);

      settingResult.add('${DataKey.dsVVA4.name},$resultOfSetDSVVA4');
    }

    if (state.dsVVA5 != state.initialValues[DataKey.dsVVA5]) {
      bool resultOfSetDSVVA5 =
          await _amp18Repository.set1p8GDSVVA5(state.dsVVA5);

      settingResult.add('${DataKey.dsVVA5.name},$resultOfSetDSVVA5');
    }

    if (state.dsSlope1 != state.initialValues[DataKey.dsSlope1]) {
      bool resultOfSetDSSlope1 =
          await _amp18Repository.set1p8GDSSlope1(state.dsSlope1);

      settingResult.add('${DataKey.dsSlope1.name},$resultOfSetDSSlope1');
    }

    if (state.dsSlope3 != state.initialValues[DataKey.dsSlope3]) {
      bool resultOfSetDSSlope3 =
          await _amp18Repository.set1p8GDSSlope3(state.dsSlope3);

      settingResult.add('${DataKey.dsSlope3.name},$resultOfSetDSSlope3');
    }

    if (state.dsSlope4 != state.initialValues[DataKey.dsSlope4]) {
      bool resultOfSetDSSlope4 =
          await _amp18Repository.set1p8GDSSlope4(state.dsSlope4);

      settingResult.add('${DataKey.dsSlope4.name},$resultOfSetDSSlope4');
    }

    if (state.usVCA1 != state.initialValues[DataKey.usVCA1]) {
      bool resultOfSetUSVCA1Cmd =
          await _amp18Repository.set1p8GUSVCA1(state.usVCA1);

      settingResult.add('${DataKey.usVCA1.name},$resultOfSetUSVCA1Cmd');
    }

    if (state.usVCA2 != state.initialValues[DataKey.usVCA2]) {
      bool resultOfSetUSVCA2 =
          await _amp18Repository.set1p8GUSVCA2(state.usVCA2);

      settingResult.add('${DataKey.usVCA2.name},$resultOfSetUSVCA2');
    }

    if (state.usVCA3 != state.initialValues[DataKey.usVCA3]) {
      bool resultOfSetUSVCA3 =
          await _amp18Repository.set1p8GUSVCA3(state.usVCA3);

      settingResult.add('${DataKey.usVCA3.name},$resultOfSetUSVCA3');
    }

    if (state.usVCA4 != state.initialValues[DataKey.usVCA4]) {
      bool resultOfSetUSVCA4 =
          await _amp18Repository.set1p8GUSVCA4(state.usVCA4);

      settingResult.add('${DataKey.usVCA4.name},$resultOfSetUSVCA4');
    }

    if (state.eREQ != state.initialValues[DataKey.eREQ]) {
      bool resultOfSetEREQ = await _amp18Repository.set1p8GEREQ(state.eREQ);

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

    if (state.dsVVA4 != state.initialValues[DataKey.dsVVA4]) {
      bool resultOfSetDSVVA4 =
          await _amp18Repository.set1p8GDSVVA4(state.dsVVA4);

      settingResult.add('${DataKey.dsVVA4.name},$resultOfSetDSVVA4');
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
