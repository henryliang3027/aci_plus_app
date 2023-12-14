import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
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
    on<DSVVA1Increased>(_onDSVVA1Increased);
    on<DSVVA1Decreased>(_onDSVVA1Decreased);
    on<DSSlope1Changed>(_onDSSlope1Changed);
    on<DSSlope1Increased>(_onDSSlope1Increased);
    on<DSSlope1Decreased>(_onDSSlope1Decreased);
    on<USVCA1Changed>(_onUSVCA1Changed);
    on<USVCA1Increased>(_onUSVCA1Increased);
    on<USVCA1Decreased>(_onUSVCA1Decreased);
    on<RtnInputAttenuation3Changed>(_onRtnInputAttenuation3Changed);
    on<RtnInputAttenuation3Increased>(_onRtnInputAttenuation3Increased);
    on<RtnInputAttenuation3Decreased>(_onRtnInputAttenuation3Decreased);
    on<RtnInputAttenuation4Changed>(_onRtnInputAttenuation4Changed);
    on<RtnInputAttenuation4Increased>(_onRtnInputAttenuation4Increased);
    on<RtnInputAttenuation4Decreased>(_onRtnInputAttenuation4Decreased);
    on<USVCA2Changed>(_onUSVCA2Changed);
    on<USVCA2Increased>(_onUSVCA2Increased);
    on<USVCA2Decreased>(_onUSVCA2Decreased);
    on<EREQChanged>(_onEREQChanged);
    on<EREQIncreased>(_onEREQIncreased);
    on<EREQDecreased>(_onEREQDecreased);
    on<RtnIngressSetting2Changed>(_onRtnIngressSetting2Changed);
    on<RtnIngressSetting3Changed>(_onRtnIngressSetting3Changed);
    on<RtnIngressSetting4Changed>(_onRtnIngressSetting4Changed);
    on<TGCCableLengthChanged>(_onTGCCableLengthChanged);
    on<DSVVA2Changed>(_onDSVVA2Changed);
    on<DSSlope2Changed>(_onDSSlope2Changed);
    on<DSVVA3Changed>(_onDSVVA3Changed);
    on<DSVVA4Changed>(_onDSVVA4Changed);
    // on<USTGCChanged>(_onUSTGCChanged);
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
    String dsSlope1 = characteristicDataCache[DataKey.dsSlope1] ?? '';
    String inputAttenuation2 = characteristicDataCache[DataKey.usVCA1] ?? '';
    String inputAttenuation3 = characteristicDataCache[DataKey.usVCA3] ?? '';
    String inputAttenuation4 = characteristicDataCache[DataKey.usVCA4] ?? '';
    String usVCA2 = characteristicDataCache[DataKey.usVCA2] ?? '';
    String eREQ = characteristicDataCache[DataKey.eREQ] ?? '';
    String ingressSetting2 =
        characteristicDataCache[DataKey.ingressSetting2] ?? '';
    String ingressSetting3 =
        characteristicDataCache[DataKey.ingressSetting3] ?? '';
    String ingressSetting4 =
        characteristicDataCache[DataKey.ingressSetting4] ?? '';
    String tgcCableLength =
        characteristicDataCache[DataKey.tgcCableLength] ?? '';
    String dsVVA2 = characteristicDataCache[DataKey.dsVVA2] ?? '';
    String dsSlope2 = characteristicDataCache[DataKey.dsSlope2] ?? '';
    String dsVVA3 = characteristicDataCache[DataKey.dsVVA3] ?? '';
    String dsVVA4 = characteristicDataCache[DataKey.dsVVA4] ?? '';
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

    emit(state.copyWith(
      dsVVA1: dsVVA1,
      dsSlope1: dsSlope1,
      usVCA1: inputAttenuation2,
      rtnInputAttenuation3: inputAttenuation3,
      rtnInputAttenuation4: inputAttenuation4,
      usVCA2: usVCA2,
      eREQ: eREQ,
      rtnIngressSetting2: ingressSetting2,
      rtnIngressSetting3: ingressSetting3,
      rtnIngressSetting4: ingressSetting4,
      tgcCableLength: tgcCableLength,
      dsVVA2: dsVVA2,
      dsSlope2: dsSlope2,
      dsVVA3: dsVVA3,
      dsVVA4: dsVVA4,
      // usTGC: usTGC,
      splitOption: splitOption,
      pilotFrequencyMode: pilotFrequencyMode,
      firstChannelLoadingFrequency: firstChannelLoadingFrequency,
      lastChannelLoadingFrequency: lastChannelLoadingFrequency,
      firstChannelLoadingLevel: firstChannelLoadingLevel,
      lastChannelLoadingLevel: lastChannelLoadingLevel,
      pilotFrequency1: pilotFrequency1,
      pilotFrequency2: pilotFrequency2,
      manualModePilot1RFOutputPower: manualModePilot1RFOutputPower,
      manualModePilot2RFOutputPower: manualModePilot2RFOutputPower,
      isInitialize: true,
      initialValues: characteristicDataCache,
    ));
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
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // // usTGC: state.usTGC,
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

  void _onDSVVA1Increased(
    DSVVA1Increased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String dsVVA1 = _getIncreasedNumber(state.dsVVA1);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA1: dsVVA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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

  void _onDSVVA1Decreased(
    DSVVA1Decreased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String dsVVA1 = _getDecreasedNumber(state.dsVVA1);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA1: dsVVA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
        dsSlope1: event.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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

  void _onDSSlope1Increased(
    DSSlope1Increased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String dsSlope1 = _getIncreasedNumber(state.dsSlope1);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope1: dsSlope1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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

  void _onDSSlope1Decreased(
    DSSlope1Decreased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String dsSlope1 = _getDecreasedNumber(state.dsSlope1);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope1: dsSlope1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
        dsSlope1: state.dsSlope1,
        usVCA1: event.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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

  void _onUSVCA1Increased(
    USVCA1Increased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String usVCA1 = _getIncreasedNumber(state.usVCA1);
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA1: usVCA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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

  void _onUSVCA1Decreased(
    USVCA1Decreased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String usVCA1 = _getDecreasedNumber(state.usVCA1);
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA1: usVCA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: event.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: event.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: event.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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

  void _onUSVCA2Increased(
    USVCA2Increased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String usVCA2 = _getIncreasedNumber(state.usVCA2);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA2: usVCA2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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

  void _onUSVCA2Decreased(
    USVCA2Decreased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String usVCA2 = _getDecreasedNumber(state.usVCA2);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA2: usVCA2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: event.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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

  void _onEREQIncreased(
    EREQIncreased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String eREQ = _getIncreasedNumber(state.eREQ);
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      eREQ: eREQ,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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

  void _onEREQDecreased(
    EREQDecreased event,
    Emitter<Setting18GraphModuleState> emit,
  ) {
    String eREQ = _getDecreasedNumber(state.eREQ);
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      eREQ: eREQ,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: event.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: event.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: event.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: event.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: event.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: event.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: event.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: event.dsVVA4,
        // usTGC: state.usTGC,
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
  //       rtnInputAttenuation3: state.rtnInputAttenuation3,
  //       rtnInputAttenuation4: state.rtnInputAttenuation4,
  //       usVCA2: state.usVCA2,
  //       eREQ: state.eREQ,
  //       rtnIngressSetting2: state.rtnIngressSetting2,
  //       rtnIngressSetting3: state.rtnIngressSetting3,
  //       rtnIngressSetting4: state.rtnIngressSetting4,
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
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        rtnInputAttenuation3: state.rtnInputAttenuation3,
        rtnInputAttenuation4: state.rtnInputAttenuation4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        // usTGC: state.usTGC,
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
    required String dsVVA1,
    required String dsSlope1,
    required String usVCA1,
    required String rtnInputAttenuation3,
    required String rtnInputAttenuation4,
    required String usVCA2,
    required String eREQ,
    required String rtnIngressSetting2,
    required String rtnIngressSetting3,
    required String rtnIngressSetting4,
    required String tgcCableLength,
    required String dsVVA2,
    required String dsSlope2,
    required String dsVVA3,
    required String dsVVA4,
    // required String usTGC,
    required String splitOption,
    required String pilotFrequencyMode,
    required String firstChannelLoadingFrequency,
    required String firstChannelLoadingLevel,
    required String lastChannelLoadingFrequency,
    required String lastChannelLoadingLevel,
    required String pilotFrequency1,
    required String pilotFrequency2,
  }) {
    if (dsVVA1 != state.initialValues[DataKey.dsVVA1] ||
        dsSlope1 != state.initialValues[DataKey.dsSlope1] ||
        usVCA1 != state.initialValues[DataKey.usVCA1] ||
        rtnInputAttenuation3 != state.initialValues[DataKey.usVCA3] ||
        rtnInputAttenuation4 != state.initialValues[DataKey.usVCA4] ||
        usVCA2 != state.initialValues[DataKey.usVCA2] ||
        eREQ != state.initialValues[DataKey.eREQ] ||
        rtnIngressSetting2 != state.initialValues[DataKey.ingressSetting2] ||
        rtnIngressSetting3 != state.initialValues[DataKey.ingressSetting3] ||
        rtnIngressSetting4 != state.initialValues[DataKey.ingressSetting4] ||
        tgcCableLength != state.initialValues[DataKey.tgcCableLength] ||
        dsVVA2 != state.initialValues[DataKey.dsVVA2] ||
        dsSlope2 != state.initialValues[DataKey.dsSlope2] ||
        dsVVA3 != state.initialValues[DataKey.dsVVA3] ||
        dsVVA4 != state.initialValues[DataKey.dsVVA4] ||
        // usTGC != state.initialValues[DataKey.usTGC] ||
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

    if (state.dsVVA1 != state.initialValues[DataKey.dsVVA1]) {
      bool resultOfSet1p8GDSVVA1 =
          await _amp18Repository.set1p8GDSVVA1(state.dsVVA1);

      settingResult.add('${DataKey.dsVVA1.name},$resultOfSet1p8GDSVVA1');
    }

    if (state.dsSlope1 != state.initialValues[DataKey.dsSlope1]) {
      bool resultOfSetForwardInputEqualizer =
          await _amp18Repository.set1p8GDSSlope1(state.dsSlope1);

      settingResult
          .add('${DataKey.dsSlope1.name},$resultOfSetForwardInputEqualizer');
    }

    if (state.usVCA1 != state.initialValues[DataKey.usVCA1]) {
      bool resultOfSetReturnInputAttenuation2 =
          await _amp18Repository.set1p8GUSVCA1(state.usVCA1);

      settingResult
          .add('${DataKey.usVCA1.name},$resultOfSetReturnInputAttenuation2');
    }

    if (state.rtnInputAttenuation3 != state.initialValues[DataKey.usVCA3]) {
      bool resultOfSetReturnInputAttenuation3 =
          await _amp18Repository.set1p8GUSVCA3(state.rtnInputAttenuation3);

      settingResult
          .add('${DataKey.usVCA3.name},$resultOfSetReturnInputAttenuation3');
    }

    if (state.rtnInputAttenuation4 != state.initialValues[DataKey.usVCA4]) {
      bool resultOfSetReturnInputAttenuation4 =
          await _amp18Repository.set1p8GUSVCA4(state.rtnInputAttenuation4);

      settingResult
          .add('${DataKey.usVCA4.name},$resultOfSetReturnInputAttenuation4');
    }

    if (state.usVCA2 != state.initialValues[DataKey.usVCA2]) {
      bool resultOfSetUSVCA2 =
          await _amp18Repository.set1p8GUSVCA2(state.usVCA2);

      settingResult.add('${DataKey.usVCA2.name},$resultOfSetUSVCA2');
    }

    if (state.eREQ != state.initialValues[DataKey.eREQ]) {
      bool resultOfSetEREQ = await _amp18Repository.set1p8GEREQ(state.eREQ);

      settingResult.add('${DataKey.eREQ.name},$resultOfSetEREQ');
    }

    if (state.rtnIngressSetting2 !=
        state.initialValues[DataKey.ingressSetting2]) {
      bool resultOfSetReturnIngress2 = await _amp18Repository
          .set1p8GReturnIngress2(state.rtnIngressSetting2);

      settingResult
          .add('${DataKey.ingressSetting2.name},$resultOfSetReturnIngress2');
    }

    if (state.rtnIngressSetting3 !=
        state.initialValues[DataKey.ingressSetting3]) {
      bool resultOfSetReturnIngress3 = await _amp18Repository
          .set1p8GReturnIngress3(state.rtnIngressSetting3);

      settingResult
          .add('${DataKey.ingressSetting3.name},$resultOfSetReturnIngress3');
    }

    if (state.rtnIngressSetting4 !=
        state.initialValues[DataKey.ingressSetting4]) {
      bool resultOfSetReturnIngress4 = await _amp18Repository
          .set1p8GReturnIngress4(state.rtnIngressSetting4);

      settingResult
          .add('${DataKey.ingressSetting4.name},$resultOfSetReturnIngress4');
    }

    if (state.tgcCableLength != state.initialValues[DataKey.tgcCableLength]) {
      bool resultOfSetTGCCableLength =
          await _amp18Repository.set1p8GTGCCableLength(state.tgcCableLength);

      settingResult
          .add('${DataKey.tgcCableLength.name},$resultOfSetTGCCableLength');
    }

    if (state.dsVVA2 != state.initialValues[DataKey.dsVVA2]) {
      bool resultOfSetDSVVA2 =
          await _amp18Repository.set1p8GDSVVA2(state.dsVVA2);

      settingResult.add('${DataKey.dsVVA2.name},$resultOfSetDSVVA2');
    }

    if (state.dsSlope2 != state.initialValues[DataKey.dsSlope2]) {
      bool resultOfSetDSSlope2 =
          await _amp18Repository.set1p8GDSSlope2(state.dsSlope2);

      settingResult.add('${DataKey.dsSlope2.name},$resultOfSetDSSlope2');
    }

    if (state.dsVVA3 != state.initialValues[DataKey.dsVVA3]) {
      bool resultOfSetDSVVA3 =
          await _amp18Repository.set1p8DSVVA3(state.dsVVA3);

      settingResult.add('${DataKey.dsVVA3.name},$resultOfSetDSVVA3');
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

    if (state.firstChannelLoadingFrequency !=
        state.initialValues[DataKey.firstChannelLoadingFrequency]) {
      bool resultOfSetFirstChannelLoadingFrequency =
          await _amp18Repository.set1p8GFirstChannelLoadingFrequency(
              state.firstChannelLoadingFrequency);

      settingResult.add(
          '${DataKey.firstChannelLoadingFrequency.name},$resultOfSetFirstChannelLoadingFrequency');
    }

    if (state.firstChannelLoadingLevel !=
        state.initialValues[DataKey.firstChannelLoadingLevel]) {
      bool resultOfSetFirstChannelLoadingLevel = await _amp18Repository
          .set1p8GFirstChannelLoadingLevel(state.firstChannelLoadingLevel);

      settingResult.add(
          '${DataKey.firstChannelLoadingLevel.name},$resultOfSetFirstChannelLoadingLevel');
    }

    if (state.lastChannelLoadingFrequency !=
        state.initialValues[DataKey.lastChannelLoadingFrequency]) {
      bool resultOfSetLastChannelLoadingFrequency =
          await _amp18Repository.set1p8GLastChannelLoadingFrequency(
              state.lastChannelLoadingFrequency);

      settingResult.add(
          '${DataKey.lastChannelLoadingFrequency.name},$resultOfSetLastChannelLoadingFrequency');
    }

    if (state.lastChannelLoadingLevel !=
        state.initialValues[DataKey.lastChannelLoadingLevel]) {
      bool resultOfSetLastChannelLoadingLevel = await _amp18Repository
          .set1p8GLastChannelLoadingLevel(state.lastChannelLoadingLevel);

      settingResult.add(
          '${DataKey.lastChannelLoadingLevel.name},$resultOfSetLastChannelLoadingLevel');
    }

    if (state.pilotFrequency1 != state.initialValues[DataKey.pilotFrequency1]) {
      bool resultOfSetPilotFrequency1 =
          await _amp18Repository.set1p8GPilotFrequency1(state.pilotFrequency1);

      settingResult
          .add('${DataKey.pilotFrequency1.name},$resultOfSetPilotFrequency1');
    }

    if (state.pilotFrequency2 != state.initialValues[DataKey.pilotFrequency2]) {
      bool resultOfSetPilotFrequency2 =
          await _amp18Repository.set1p8GPilotFrequency2(state.pilotFrequency2);

      settingResult
          .add('${DataKey.pilotFrequency2.name},$resultOfSetPilotFrequency2');
    }

    // 等待 device 完成更新後在讀取值
    await Future.delayed(const Duration(milliseconds: 1000));

    await _amp18Repository.updateCharacteristics();

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
      enableSubmission: false,
      editMode: false,
      isInitialize: true,
      initialValues: _amp18Repository.characteristicDataCache,
    ));
  }
}
