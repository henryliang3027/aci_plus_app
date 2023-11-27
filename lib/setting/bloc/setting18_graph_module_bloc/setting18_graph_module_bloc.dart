import 'package:aci_plus_app/core/command.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_graph_module_event.dart';
part 'setting18_graph_module_state.dart';

class Setting18GraphModuleBloc
    extends Bloc<Setting18GraphModuleEvent, Setting18GraphModuleState> {
  Setting18GraphModuleBloc({required Amp18Repository dsimRepository})
      : _dsimRepository = dsimRepository,
        super(const Setting18GraphModuleState()) {
    on<Initialized>(_onInitialized);
    on<FwdInputAttenuationChanged>(_onFwdInputAttenuationChanged);
    on<FwdInputAttenuationIncreased>(_onFwdInputAttenuationIncreased);
    on<FwdInputAttenuationDecreased>(_onFwdInputAttenuationDecreased);
    on<FwdInputEQChanged>(_onFwdInputEQChanged);
    on<FwdInputEQIncreased>(_onFwdInputEQIncreased);
    on<FwdInputEQDecreased>(_onFwdInputEQDecreased);
    on<RtnInputAttenuation2Changed>(_onRtnInputAttenuation2Changed);
    on<RtnInputAttenuation2Increased>(_onRtnInputAttenuation2Increased);
    on<RtnInputAttenuation2Decreased>(_onRtnInputAttenuation2Decreased);
    on<RtnInputAttenuation3Changed>(_onRtnInputAttenuation3Changed);
    on<RtnInputAttenuation3Increased>(_onRtnInputAttenuation3Increased);
    on<RtnInputAttenuation3Decreased>(_onRtnInputAttenuation3Decreased);
    on<RtnInputAttenuation4Changed>(_onRtnInputAttenuation4Changed);
    on<RtnInputAttenuation4Increased>(_onRtnInputAttenuation4Increased);
    on<RtnInputAttenuation4Decreased>(_onRtnInputAttenuation4Decreased);
    on<RtnOutputLevelAttenuationChanged>(_onRtnOutputLevelAttenuationChanged);
    on<RtnOutputLevelAttenuationIncreased>(
        _onRtnOutputLevelAttenuationIncreased);
    on<RtnOutputLevelAttenuationDecreased>(
        _onRtnOutputLevelAttenuationDecreased);
    on<RtnOutputEQChanged>(_onRtnOutputEQChanged);
    on<RtnOutputEQIncreased>(_onRtnOutputEQIncreased);
    on<RtnOutputEQDecreased>(_onRtnOutputEQDecreased);
    on<RtnIngressSetting2Changed>(_onRtnIngressSetting2Changed);
    on<RtnIngressSetting3Changed>(_onRtnIngressSetting3Changed);
    on<RtnIngressSetting4Changed>(_onRtnIngressSetting4Changed);
    on<TGCCableLengthChanged>(_onTGCCableLengthChanged);
    on<DSVVA2Changed>(_onDSVVA2Changed);
    on<DSSlope2Changed>(_onDSSlope2Changed);
    on<DSVVA3Changed>(_onDSVVA3Changed);
    on<DSVVA4Changed>(_onDSVVA4Changed);
    on<USTGCChanged>(_onUSTGCChanged);
    on<SplitOptionChanged>(_onSplitOptionChanged);
    on<PilotFrequencyModeChanged>(_onPilotFrequencyModeChanged);
    on<FirstChannelLoadingFrequencyChanged>(
        _onFirstChannelLoadingFrequencyChanged);
    on<LastChannelLoadingFrequencyChanged>(
        _onLastChannelLoadingFrequencyChanged);
    on<FirstChannelLoadingLevelChanged>(_onFirstChannelLoadingLevelChanged);
    on<LastChannelLoadingLevelChanged>(_onLastChannelLoadingLevelChanged);
    on<PilotFrequency1Changed>(_onPilotFrequency1Changed);
    on<PilotFrequency2Changed>(_onPilotFrequency2Changed);
    on<SettingSubmitted>(_onSettingSubmitted);
  }

  final Amp18Repository _dsimRepository;

  void _onInitialized(
    Initialized event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
        fwdInputAttenuation: event.fwdInputAttenuation,
        fwdInputEQ: event.fwdInputEQ,
        rtnInputAttenuation2: event.rtnInputAttenuation2,
        rtnInputAttenuation3: event.rtnInputAttenuation3,
        rtnInputAttenuation4: event.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: event.rtnOutputLevelAttenuation,
        rtnOutputEQ: event.rtnOutputEQ,
        rtnIngressSetting2: event.rtnIngressSetting2,
        rtnIngressSetting3: event.rtnIngressSetting3,
        rtnIngressSetting4: event.rtnIngressSetting4,
        tgcCableLength: event.tgcCableLength,
        dsVVA2: event.dsVVA2,
        dsSlope2: event.dsSlope2,
        dsVVA3: event.dsVVA3,
        dsVVA4: event.dsVVA4,
        usTGC: event.usTGC,
        splitOption: event.splitOption,
        pilotFrequencyMode: event.pilotFrequencyMode,
        firstChannelLoadingFrequency: event.firstChannelLoadingFrequency,
        lastChannelLoadingFrequency: event.lastChannelLoadingFrequency,
        firstChannelLoadingLevel: event.firstChannelLoadingLevel,
        lastChannelLoadingLevel: event.lastChannelLoadingLevel,
        pilotFrequency1: event.pilotFrequency1,
        pilotFrequency2: event.pilotFrequency2,
        manualModePilot1RFOutputPower: event.manualModePilot1RFOutputPower,
        manualModePilot2RFOutputPower: event.manualModePilot2RFOutputPower,
        isInitialize: true,
        initialValues: {
          DataKey.inputAttenuation: event.fwdInputAttenuation,
          DataKey.inputEqualizer: event.fwdInputEQ,
          DataKey.inputAttenuation2: event.rtnInputAttenuation2,
          DataKey.inputAttenuation3: event.rtnInputAttenuation3,
          DataKey.inputAttenuation4: event.rtnInputAttenuation4,
          DataKey.outputAttenuation: event.rtnOutputLevelAttenuation,
          DataKey.outputEqualizer: event.rtnOutputEQ,
          DataKey.ingressSetting2: event.rtnIngressSetting2,
          DataKey.ingressSetting3: event.rtnIngressSetting3,
          DataKey.ingressSetting4: event.rtnIngressSetting4,
          DataKey.tgcCableLength: event.tgcCableLength,
          DataKey.dsVVA2: event.dsVVA2,
          DataKey.dsSlope2: event.dsSlope2,
          DataKey.dsVVA3: event.dsVVA3,
          DataKey.dsVVA4: event.dsVVA4,
          DataKey.usTGC: event.usTGC,
          DataKey.splitOption: event.splitOption,
          DataKey.pilotFrequencyMode: event.pilotFrequencyMode,
          DataKey.firstChannelLoadingFrequency:
              event.firstChannelLoadingFrequency,
          DataKey.lastChannelLoadingFrequency:
              event.lastChannelLoadingFrequency,
          DataKey.firstChannelLoadingLevel: event.firstChannelLoadingLevel,
          DataKey.lastChannelLoadingLevel: event.lastChannelLoadingLevel,
          DataKey.pilotFrequency1: event.pilotFrequency1,
          DataKey.pilotFrequency2: event.pilotFrequency2,
          DataKey.manualModePilot1RFOutputPower:
              event.manualModePilot1RFOutputPower,
          DataKey.manualModePilot2RFOutputPower:
              event.manualModePilot2RFOutputPower,
        }));
  }

  String _getIncreasedNumber(String value) {
    double doubleValue = double.parse(value);
    doubleValue = doubleValue + 0.1 <= 15.0 ? doubleValue + 0.1 : doubleValue;
    String strValue = doubleValue.toStringAsFixed(1);

    return strValue;
  }

  String _getDecreasedNumber(String value) {
    double doubleValue = double.parse(value);
    doubleValue = doubleValue - 0.1 >= 0.0 ? doubleValue - 0.1 : doubleValue;
    String strValue = doubleValue.toStringAsFixed(1);

    return strValue;
  }

  void _onFwdInputAttenuationChanged(
    FwdInputAttenuationChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      fwdInputAttenuation: event.fwdInputAttenuation,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: event.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onFwdInputAttenuationIncreased(
    FwdInputAttenuationIncreased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String fwdInputAttenuation = _getIncreasedNumber(state.fwdInputAttenuation);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      fwdInputAttenuation: fwdInputAttenuation,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onFwdInputAttenuationDecreased(
    FwdInputAttenuationDecreased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String fwdInputAttenuation = _getDecreasedNumber(state.fwdInputAttenuation);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      fwdInputAttenuation: fwdInputAttenuation,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onFwdInputEQChanged(
    FwdInputEQChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      fwdInputEQ: event.fwdInputEQ,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: event.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onFwdInputEQIncreased(
    FwdInputEQIncreased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String fwdInputEQ = _getIncreasedNumber(state.fwdInputEQ);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      fwdInputEQ: fwdInputEQ,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onFwdInputEQDecreased(
    FwdInputEQDecreased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String fwdInputEQ = _getDecreasedNumber(state.fwdInputEQ);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      fwdInputEQ: fwdInputEQ,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onRtnInputAttenuation2Changed(
    RtnInputAttenuation2Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnInputAttenuation2: event.rtnInputAttenuation2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: event.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onRtnInputAttenuation2Increased(
    RtnInputAttenuation2Increased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String rtnInputAttenuation2 =
        _getIncreasedNumber(state.rtnInputAttenuation2);
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnInputAttenuation2: rtnInputAttenuation2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onRtnInputAttenuation2Decreased(
    RtnInputAttenuation2Decreased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String rtnInputAttenuation2 =
        _getDecreasedNumber(state.rtnInputAttenuation2);
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnInputAttenuation2: rtnInputAttenuation2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onRtnInputAttenuation3Changed(
    RtnInputAttenuation3Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnInputAttenuation3: event.rtnInputAttenuation3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: event.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onRtnInputAttenuation3Increased(
    RtnInputAttenuation3Increased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String rtnInputAttenuation3 =
        _getIncreasedNumber(state.rtnInputAttenuation3);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnInputAttenuation3: rtnInputAttenuation3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onRtnInputAttenuation3Decreased(
    RtnInputAttenuation3Decreased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String rtnInputAttenuation3 =
        _getDecreasedNumber(state.rtnInputAttenuation3);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnInputAttenuation3: rtnInputAttenuation3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onRtnInputAttenuation4Changed(
    RtnInputAttenuation4Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnInputAttenuation4: event.rtnInputAttenuation4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: event.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onRtnInputAttenuation4Increased(
    RtnInputAttenuation4Increased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String rtnInputAttenuation4 =
        _getIncreasedNumber(state.rtnInputAttenuation4);
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnInputAttenuation4: rtnInputAttenuation4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onRtnInputAttenuation4Decreased(
    RtnInputAttenuation4Decreased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String rtnInputAttenuation4 =
        _getDecreasedNumber(state.rtnInputAttenuation4);
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnInputAttenuation4: rtnInputAttenuation4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onRtnOutputLevelAttenuationChanged(
    RtnOutputLevelAttenuationChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnOutputLevelAttenuation: event.rtnOutputLevelAttenuation,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: event.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onRtnOutputLevelAttenuationIncreased(
    RtnOutputLevelAttenuationIncreased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String rtnOutputLevelAttenuation =
        _getIncreasedNumber(state.rtnOutputLevelAttenuation);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnOutputLevelAttenuation: rtnOutputLevelAttenuation,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onRtnOutputLevelAttenuationDecreased(
    RtnOutputLevelAttenuationDecreased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String rtnOutputLevelAttenuation =
        _getDecreasedNumber(state.rtnOutputLevelAttenuation);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnOutputLevelAttenuation: rtnOutputLevelAttenuation,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onRtnOutputEQChanged(
    RtnOutputEQChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnOutputEQ: event.rtnOutputEQ,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: event.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onRtnOutputEQIncreased(
    RtnOutputEQIncreased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String rtnOutputEQ = _getIncreasedNumber(state.rtnOutputEQ);
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnOutputEQ: rtnOutputEQ,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onRtnOutputEQDecreased(
    RtnOutputEQDecreased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String rtnOutputEQ = _getDecreasedNumber(state.rtnOutputEQ);
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnOutputEQ: rtnOutputEQ,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onRtnIngressSetting2Changed(
    RtnIngressSetting2Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnIngressSetting2: event.rtnIngressSetting2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: event.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onRtnIngressSetting3Changed(
    RtnIngressSetting3Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnIngressSetting3: event.rtnIngressSetting3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: event.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onRtnIngressSetting4Changed(
    RtnIngressSetting4Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnIngressSetting4: event.rtnIngressSetting4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: event.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
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
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: event.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onDSVVA2Changed(
    DSVVA2Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA2: event.dsVVA2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: event.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onDSSlope2Changed(
    DSSlope2Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope2: event.dsSlope2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: event.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onDSVVA3Changed(
    DSVVA3Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA3: event.dsVVA3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: event.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
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
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: event.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onUSTGCChanged(
    USTGCChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usTGC: event.usTGC,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: event.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onSplitOptionChanged(
    SplitOptionChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      splitOption: event.splitOption,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: event.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
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
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: event.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onFirstChannelLoadingFrequencyChanged(
    FirstChannelLoadingFrequencyChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      firstChannelLoadingFrequency: event.firstChannelLoadingFrequency,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: event.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onFirstChannelLoadingLevelChanged(
    FirstChannelLoadingLevelChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      firstChannelLoadingLevel: event.firstChannelLoadingLevel,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: event.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onLastChannelLoadingFrequencyChanged(
    LastChannelLoadingFrequencyChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      lastChannelLoadingFrequency: event.lastChannelLoadingFrequency,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: event.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onLastChannelLoadingLevelChanged(
    LastChannelLoadingLevelChanged event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      lastChannelLoadingLevel: event.lastChannelLoadingLevel,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: event.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onPilotFrequency1Changed(
    PilotFrequency1Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      pilotFrequency1: event.pilotFrequency1,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: event.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
      ),
    ));
  }

  void _onPilotFrequency2Changed(
    PilotFrequency2Changed event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      pilotFrequency2: event.pilotFrequency2,
      enableSubmission: _isEnabledSubmission(
        fwdInputAttenuation: state.fwdInputAttenuation,
        fwdInputEQ: state.fwdInputEQ,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        usTGC: state.usTGC,
        splitOption: state.splitOption,
        pilotFrequencyMode: state.pilotFrequencyMode,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: event.pilotFrequency2,
      ),
    ));
  }

  bool _isEnabledSubmission({
    required String fwdInputAttenuation,
    required String fwdInputEQ,
    required String rtnInputAttenuation2,
    required String rtnInputAttenuation3,
    required String rtnInputAttenuation4,
    required String rtnOutputLevelAttenuation,
    required String rtnOutputEQ,
    required String rtnIngressSetting2,
    required String rtnIngressSetting3,
    required String rtnIngressSetting4,
    required String tgcCableLength,
    required String dsVVA2,
    required String dsSlope2,
    required String dsVVA3,
    required String dsVVA4,
    required String usTGC,
    required String splitOption,
    required String pilotFrequencyMode,
    required String firstChannelLoadingFrequency,
    required String firstChannelLoadingLevel,
    required String lastChannelLoadingFrequency,
    required String lastChannelLoadingLevel,
    required String pilotFrequency1,
    required String pilotFrequency2,
  }) {
    if (fwdInputAttenuation != state.initialValues[DataKey.inputAttenuation] ||
        fwdInputEQ != state.initialValues[DataKey.inputEqualizer] ||
        rtnInputAttenuation2 !=
            state.initialValues[DataKey.inputAttenuation2] ||
        rtnInputAttenuation3 !=
            state.initialValues[DataKey.inputAttenuation3] ||
        rtnInputAttenuation4 !=
            state.initialValues[DataKey.inputAttenuation4] ||
        rtnOutputLevelAttenuation !=
            state.initialValues[DataKey.outputAttenuation] ||
        rtnOutputEQ != state.initialValues[DataKey.outputEqualizer] ||
        rtnIngressSetting2 != state.initialValues[DataKey.ingressSetting2] ||
        rtnIngressSetting3 != state.initialValues[DataKey.ingressSetting3] ||
        rtnIngressSetting4 != state.initialValues[DataKey.ingressSetting4] ||
        tgcCableLength != state.initialValues[DataKey.tgcCableLength] ||
        dsVVA2 != state.initialValues[DataKey.dsVVA2] ||
        dsSlope2 != state.initialValues[DataKey.dsSlope2] ||
        dsVVA3 != state.initialValues[DataKey.dsVVA3] ||
        dsVVA4 != state.initialValues[DataKey.dsVVA4] ||
        usTGC != state.initialValues[DataKey.usTGC] ||
        splitOption != state.initialValues[DataKey.splitOption] ||
        firstChannelLoadingFrequency !=
            state.initialValues[DataKey.firstChannelLoadingFrequency] ||
        firstChannelLoadingLevel !=
            state.initialValues[DataKey.firstChannelLoadingLevel] ||
        lastChannelLoadingFrequency !=
            state.initialValues[DataKey.lastChannelLoadingFrequency] ||
        lastChannelLoadingLevel !=
            state.initialValues[DataKey.lastChannelLoadingLevel] ||
        pilotFrequencyMode != state.initialValues[DataKey.pilotFrequencyMode] ||
        pilotFrequency1 != state.initialValues[DataKey.pilotFrequency1] ||
        pilotFrequency2 != state.initialValues[DataKey.pilotFrequency2]) {
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

    if (state.fwdInputAttenuation !=
        state.initialValues[DataKey.inputAttenuation]) {
      bool resultOfSetForwardInputAttenuation = await _dsimRepository
          .set1p8GForwardInputAttenuation(state.fwdInputAttenuation);

      settingResult.add(
          '${DataKey.inputAttenuation.name},$resultOfSetForwardInputAttenuation');
    }

    if (state.fwdInputEQ != state.initialValues[DataKey.inputEqualizer]) {
      bool resultOfSetForwardInputEqualizer =
          await _dsimRepository.set1p8GForwardInputEqualizer(state.fwdInputEQ);

      settingResult.add(
          '${DataKey.inputEqualizer.name},$resultOfSetForwardInputEqualizer');
    }

    if (state.rtnInputAttenuation2 !=
        state.initialValues[DataKey.inputAttenuation2]) {
      bool resultOfSetReturnInputAttenuation2 = await _dsimRepository
          .set1p8GReturnInputAttenuation2(state.rtnInputAttenuation2);

      settingResult.add(
          '${DataKey.inputAttenuation2.name},$resultOfSetReturnInputAttenuation2');
    }

    if (state.rtnInputAttenuation3 !=
        state.initialValues[DataKey.inputAttenuation3]) {
      bool resultOfSetReturnInputAttenuation3 = await _dsimRepository
          .set1p8GReturnInputAttenuation3(state.rtnInputAttenuation3);

      settingResult.add(
          '${DataKey.inputAttenuation3.name},$resultOfSetReturnInputAttenuation3');
    }

    if (state.rtnInputAttenuation4 !=
        state.initialValues[DataKey.inputAttenuation4]) {
      bool resultOfSetReturnInputAttenuation4 = await _dsimRepository
          .set1p8GReturnInputAttenuation4(state.rtnInputAttenuation4);

      settingResult.add(
          '${DataKey.inputAttenuation4.name},$resultOfSetReturnInputAttenuation4');
    }

    if (state.rtnOutputLevelAttenuation !=
        state.initialValues[DataKey.outputAttenuation]) {
      bool resultOfSetReturnOutputAttenuation = await _dsimRepository
          .set1p8GReturnOutputAttenuation(state.rtnOutputLevelAttenuation);

      settingResult.add(
          '${DataKey.outputAttenuation.name},$resultOfSetReturnOutputAttenuation');
    }

    if (state.rtnOutputEQ != state.initialValues[DataKey.outputEqualizer]) {
      bool resultOfSetReturnOutputEqualizer =
          await _dsimRepository.set1p8GReturnOutputEqualizer(state.rtnOutputEQ);

      settingResult.add(
          '${DataKey.outputEqualizer.name},$resultOfSetReturnOutputEqualizer');
    }

    if (state.rtnIngressSetting2 !=
        state.initialValues[DataKey.ingressSetting2]) {
      bool resultOfSetReturnIngress2 =
          await _dsimRepository.set1p8GReturnIngress2(state.rtnIngressSetting2);

      settingResult
          .add('${DataKey.ingressSetting2.name},$resultOfSetReturnIngress2');
    }

    if (state.rtnIngressSetting3 !=
        state.initialValues[DataKey.ingressSetting3]) {
      bool resultOfSetReturnIngress3 =
          await _dsimRepository.set1p8GReturnIngress3(state.rtnIngressSetting3);

      settingResult
          .add('${DataKey.ingressSetting3.name},$resultOfSetReturnIngress3');
    }

    if (state.rtnIngressSetting4 !=
        state.initialValues[DataKey.ingressSetting4]) {
      bool resultOfSetReturnIngress4 =
          await _dsimRepository.set1p8GReturnIngress4(state.rtnIngressSetting4);

      settingResult
          .add('${DataKey.ingressSetting4.name},$resultOfSetReturnIngress4');
    }

    if (state.tgcCableLength != state.initialValues[DataKey.tgcCableLength]) {
      bool resultOfSetTGCCableLength =
          await _dsimRepository.set1p8GTGCCableLength(state.tgcCableLength);

      settingResult
          .add('${DataKey.tgcCableLength.name},$resultOfSetTGCCableLength');
    }

    if (state.dsVVA2 != state.initialValues[DataKey.dsVVA2]) {
      bool resultOfSetDSVVA2 =
          await _dsimRepository.set1p8GDSVVA2(state.dsVVA2);

      settingResult.add('${DataKey.dsVVA2.name},$resultOfSetDSVVA2');
    }

    if (state.dsSlope2 != state.initialValues[DataKey.dsSlope2]) {
      bool resultOfSetDSSlope2 =
          await _dsimRepository.set1p8GDSSlope2(state.dsSlope2);

      settingResult.add('${DataKey.dsSlope2.name},$resultOfSetDSSlope2');
    }

    if (state.dsVVA3 != state.initialValues[DataKey.dsVVA3]) {
      bool resultOfSetDSVVA3 = await _dsimRepository.set1p8DSVVA3(state.dsVVA3);

      settingResult.add('${DataKey.dsVVA3.name},$resultOfSetDSVVA3');
    }

    if (state.dsVVA4 != state.initialValues[DataKey.dsVVA4]) {
      bool resultOfSetDSVVA4 = await _dsimRepository.set1p8DSVVA4(state.dsVVA4);

      settingResult.add('${DataKey.dsVVA4.name},$resultOfSetDSVVA4');
    }

    if (state.usTGC != state.initialValues[DataKey.usTGC]) {
      bool resultOfSetUSTGC = await _dsimRepository.set1p8USTGC(state.usTGC);

      settingResult.add('${DataKey.usTGC.name},$resultOfSetUSTGC');
    }

    if (state.splitOption != state.initialValues[DataKey.splitOption]) {
      bool resultOfSetSplitOption =
          await _dsimRepository.set1p8GSplitOption(state.splitOption);

      settingResult.add('${DataKey.splitOption.name},$resultOfSetSplitOption');
    }

    if (state.pilotFrequencyMode !=
        state.initialValues[DataKey.pilotFrequencyMode]) {
      bool resultOfSetPilotFrequencyMode = await _dsimRepository
          .set1p8GPilotFrequencyMode(state.pilotFrequencyMode);

      settingResult.add(
          '${DataKey.pilotFrequencyMode.name},$resultOfSetPilotFrequencyMode');
    }

    if (state.firstChannelLoadingFrequency !=
        state.initialValues[DataKey.firstChannelLoadingFrequency]) {
      bool resultOfSetFirstChannelLoadingFrequency =
          await _dsimRepository.set1p8GFirstChannelLoadingFrequency(
              state.firstChannelLoadingFrequency);

      settingResult.add(
          '${DataKey.firstChannelLoadingFrequency.name},$resultOfSetFirstChannelLoadingFrequency');
    }

    if (state.firstChannelLoadingLevel !=
        state.initialValues[DataKey.firstChannelLoadingLevel]) {
      bool resultOfSetFirstChannelLoadingLevel = await _dsimRepository
          .set1p8GFirstChannelLoadingLevel(state.firstChannelLoadingLevel);

      settingResult.add(
          '${DataKey.firstChannelLoadingLevel.name},$resultOfSetFirstChannelLoadingLevel');
    }

    if (state.lastChannelLoadingFrequency !=
        state.initialValues[DataKey.lastChannelLoadingFrequency]) {
      bool resultOfSetLastChannelLoadingFrequency =
          await _dsimRepository.set1p8GLastChannelLoadingFrequency(
              state.lastChannelLoadingFrequency);

      settingResult.add(
          '${DataKey.lastChannelLoadingFrequency.name},$resultOfSetLastChannelLoadingFrequency');
    }

    if (state.lastChannelLoadingLevel !=
        state.initialValues[DataKey.lastChannelLoadingLevel]) {
      bool resultOfSetLastChannelLoadingLevel = await _dsimRepository
          .set1p8GLastChannelLoadingLevel(state.lastChannelLoadingLevel);

      settingResult.add(
          '${DataKey.lastChannelLoadingLevel.name},$resultOfSetLastChannelLoadingLevel');
    }

    if (state.pilotFrequency1 != state.initialValues[DataKey.pilotFrequency1]) {
      bool resultOfSetPilotFrequency1 =
          await _dsimRepository.set1p8GPilotFrequency1(state.pilotFrequency1);

      settingResult
          .add('${DataKey.pilotFrequency1.name},$resultOfSetPilotFrequency1');
    }

    if (state.pilotFrequency2 != state.initialValues[DataKey.pilotFrequency2]) {
      bool resultOfSetPilotFrequency2 =
          await _dsimRepository.set1p8GPilotFrequency2(state.pilotFrequency2);

      settingResult
          .add('${DataKey.pilotFrequency2.name},$resultOfSetPilotFrequency2');
    }

    // 等待 device 完成更新後在讀取值
    await Future.delayed(const Duration(milliseconds: 1000));

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
      enableSubmission: false,
      editMode: false,
    ));

    await _dsimRepository.updateCharacteristics();
  }
}
