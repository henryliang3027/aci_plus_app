import 'package:aci_plus_app/core/command.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_control_event.dart';
part 'setting18_control_state.dart';

class Setting18ControlBloc
    extends Bloc<Setting18ControlEvent, Setting18ControlState> {
  Setting18ControlBloc({
    required Amp18Repository amp18Repository,
  })  : _amp18Repository = amp18Repository,
        super(const Setting18ControlState()) {
    on<Initialized>(_onInitialized);
    on<DSVVA1Changed>(_onDSVVA1Changed);
    on<DSVVA1Increased>(_onDSVVA1Increased);
    on<DSVVA1Decreased>(_onDSVVA1Decreased);
    on<DSSlope1Changed>(_onDSSlope1Changed);
    on<DSSlope1Increased>(_onDSSlope1Increased);
    on<DSSlope1Decreased>(_onDSSlope1Decreased);
    on<RtnInputAttenuation2Changed>(_onRtnInputAttenuation2Changed);
    on<RtnInputAttenuation2Increased>(_onRtnInputAttenuation2Increased);
    on<RtnInputAttenuation2Decreased>(_onRtnInputAttenuation2Decreased);
    on<USVCA3Changed>(_onUSVCA3Changed);
    on<USVCA3Increased>(_onUSVCA3Increased);
    on<USVCA3Decreased>(_onUSVCA3Decreased);
    on<USVCA4Changed>(_onUSVCA4Changed);
    on<USVCA4Increased>(_onUSVCA4Increased);
    on<USVCA4Decreased>(_onUSVCA4Decreased);
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
    on<DSVVA4Increased>(_onDSVVA4Increased);
    on<DSVVA4Decreased>(_onDSVVA4Decreased);
    on<DSVVA5Changed>(_onDSVVA5Changed);
    on<DSVVA5Increased>(_onDSVVA5Increased);
    on<DSVVA5Decreased>(_onDSVVA5Decreased);
    on<DSSlope3Changed>(_onDSSlope3Changed);
    on<DSSlope3Increased>(_onDSSlope3Increased);
    on<DSSlope3Decreased>(_onDSSlope3Decreased);
    on<DSSlope4Changed>(_onDSSlope4Changed);
    on<DSSlope4Increased>(_onDSSlope4Increased);
    on<DSSlope4Decreased>(_onDSSlope4Decreased);
    // on<USTGCChanged>(_onUSTGCChanged);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);

    add(const Initialized());
  }

  final Amp18Repository _amp18Repository;

  void _onInitialized(
    Initialized event,
    Emitter<Setting18ControlState> emit,
  ) {
    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    String dsVVA1 = characteristicDataCache[DataKey.dsVVA1] ?? '';
    String dsSlope1 = characteristicDataCache[DataKey.dsSlope1] ?? '';
    String inputAttenuation2 =
        characteristicDataCache[DataKey.inputAttenuation2] ?? '';
    String usVCA3 = characteristicDataCache[DataKey.usVCA3] ?? '';
    String usVCA4 = characteristicDataCache[DataKey.usVCA4] ?? '';
    String outputAttenuation =
        characteristicDataCache[DataKey.outputAttenuation] ?? '';
    String outputEqualizer =
        characteristicDataCache[DataKey.outputEqualizer] ?? '';
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
    String dsVVA5 = characteristicDataCache[DataKey.dsVVA5] ?? '';
    String dsSlope3 = characteristicDataCache[DataKey.dsSlope3] ?? '';

    emit(state.copyWith(
      dsVVA1: dsVVA1,
      dsSlope1: dsSlope1,
      rtnInputAttenuation2: inputAttenuation2,
      usVCA3: usVCA3,
      usVCA4: usVCA4,
      rtnOutputLevelAttenuation: outputAttenuation,
      rtnOutputEQ: outputEqualizer,
      rtnIngressSetting2: ingressSetting2,
      rtnIngressSetting3: ingressSetting3,
      rtnIngressSetting4: ingressSetting4,
      tgcCableLength: tgcCableLength,
      dsVVA2: dsVVA2,
      dsSlope2: dsSlope2,
      dsVVA3: dsVVA3,
      dsVVA4: dsVVA4,
      dsVVA5: dsVVA5,
      dsSlope3: dsSlope3,
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
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA1: event.dsVVA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: event.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onDSVVA1Increased(
    DSVVA1Increased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String dsVVA1 = _getIncreasedNumber(state.dsVVA1);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA1: dsVVA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onDSVVA1Decreased(
    DSVVA1Decreased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String dsVVA1 = _getDecreasedNumber(state.dsVVA1);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA1: dsVVA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,

        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onDSSlope1Changed(
    DSSlope1Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope1: event.dsSlope1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: event.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onDSSlope1Increased(
    DSSlope1Increased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String dsSlope1 = _getIncreasedNumber(state.dsSlope1);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope1: dsSlope1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,

        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onDSSlope1Decreased(
    DSSlope1Decreased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String dsSlope1 = _getDecreasedNumber(state.dsSlope1);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope1: dsSlope1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,

        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onRtnInputAttenuation2Changed(
    RtnInputAttenuation2Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnInputAttenuation2: event.rtnInputAttenuation2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: event.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,

        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onRtnInputAttenuation2Increased(
    RtnInputAttenuation2Increased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String rtnInputAttenuation2 =
        _getIncreasedNumber(state.rtnInputAttenuation2);
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnInputAttenuation2: rtnInputAttenuation2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,

        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onRtnInputAttenuation2Decreased(
    RtnInputAttenuation2Decreased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String rtnInputAttenuation2 =
        _getDecreasedNumber(state.rtnInputAttenuation2);
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnInputAttenuation2: rtnInputAttenuation2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onUSVCA3Changed(
    USVCA3Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA3: event.usVCA3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: event.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onUSVCA3Increased(
    USVCA3Increased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String usVCA3 = _getIncreasedNumber(state.usVCA3);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA3: usVCA3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onUSVCA3Decreased(
    USVCA3Decreased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String usVCA3 = _getDecreasedNumber(state.usVCA3);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA3: usVCA3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onUSVCA4Changed(
    USVCA4Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA4: event.usVCA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: event.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,

        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onUSVCA4Increased(
    USVCA4Increased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String usVCA4 = _getIncreasedNumber(state.usVCA4);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA4: usVCA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onUSVCA4Decreased(
    USVCA4Decreased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String usVCA4 = _getDecreasedNumber(state.usVCA4);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA4: usVCA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onRtnOutputLevelAttenuationChanged(
    RtnOutputLevelAttenuationChanged event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnOutputLevelAttenuation: event.rtnOutputLevelAttenuation,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,

        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onRtnOutputLevelAttenuationIncreased(
    RtnOutputLevelAttenuationIncreased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String rtnOutputLevelAttenuation =
        _getIncreasedNumber(state.rtnOutputLevelAttenuation);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnOutputLevelAttenuation: rtnOutputLevelAttenuation,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,

        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onRtnOutputLevelAttenuationDecreased(
    RtnOutputLevelAttenuationDecreased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String rtnOutputLevelAttenuation =
        _getDecreasedNumber(state.rtnOutputLevelAttenuation);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnOutputLevelAttenuation: rtnOutputLevelAttenuation,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,

        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onRtnOutputEQChanged(
    RtnOutputEQChanged event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnOutputEQ: event.rtnOutputEQ,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,

        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onRtnOutputEQIncreased(
    RtnOutputEQIncreased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String rtnOutputEQ = _getIncreasedNumber(state.rtnOutputEQ);
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnOutputEQ: rtnOutputEQ,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,

        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onRtnOutputEQDecreased(
    RtnOutputEQDecreased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String rtnOutputEQ = _getDecreasedNumber(state.rtnOutputEQ);
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnOutputEQ: rtnOutputEQ,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,

        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onRtnIngressSetting2Changed(
    RtnIngressSetting2Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnIngressSetting2: event.rtnIngressSetting2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,

        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onRtnIngressSetting3Changed(
    RtnIngressSetting3Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnIngressSetting3: event.rtnIngressSetting3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,

        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onRtnIngressSetting4Changed(
    RtnIngressSetting4Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rtnIngressSetting4: event.rtnIngressSetting4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,

        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onTGCCableLengthChanged(
    TGCCableLengthChanged event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      tgcCableLength: event.tgcCableLength,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,

        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onDSVVA2Changed(
    DSVVA2Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA2: event.dsVVA2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,

        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onDSSlope2Changed(
    DSSlope2Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope2: event.dsSlope2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,

        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onDSVVA3Changed(
    DSVVA3Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA3: event.dsVVA3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,

        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onDSVVA4Changed(
    DSVVA4Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA4: event.dsVVA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,

        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onDSVVA4Increased(
    DSVVA4Increased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String dsVVA4 = _getIncreasedNumber(state.dsVVA4);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA4: dsVVA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onDSVVA4Decreased(
    DSVVA4Decreased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String dsVVA4 = _getDecreasedNumber(state.dsVVA4);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA4: dsVVA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
        rtnOutputEQ: state.rtnOutputEQ,
        rtnIngressSetting2: state.rtnIngressSetting2,
        rtnIngressSetting3: state.rtnIngressSetting3,
        rtnIngressSetting4: state.rtnIngressSetting4,
        tgcCableLength: state.tgcCableLength,
        dsVVA2: state.dsVVA2,
        dsSlope2: state.dsSlope2,
        dsVVA3: state.dsVVA3,
        dsVVA4: dsVVA4,
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onDSVVA5Changed(
    DSVVA5Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA5: event.dsVVA5,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: event.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onDSVVA5Increased(
    DSVVA5Increased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String dsVVA5 = _getIncreasedNumber(state.dsVVA5);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA5: dsVVA5,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,
        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onDSVVA5Decreased(
    DSVVA5Decreased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String dsVVA5 = _getDecreasedNumber(state.dsVVA5);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA5: dsVVA5,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: state.dsSlope4,

        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onDSSlope3Changed(
    DSSlope3Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope3: event.dsSlope3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: event.dsSlope3,
        dsSlope4: state.dsSlope4,
        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onDSSlope3Increased(
    DSSlope3Increased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String dsSlope3 = _getIncreasedNumber(state.dsSlope3);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope3: dsSlope3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: dsSlope3,
        dsSlope4: state.dsSlope4,
        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onDSSlope3Decreased(
    DSSlope3Decreased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String dsSlope3 = _getDecreasedNumber(state.dsSlope3);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope3: dsSlope3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: dsSlope3,
        dsSlope4: state.dsSlope4,
        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onDSSlope4Changed(
    DSSlope4Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope4: event.dsSlope4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: event.dsSlope4,
        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onDSSlope4Increased(
    DSSlope4Increased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String dsSlope4 = _getIncreasedNumber(state.dsSlope4);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope4: dsSlope4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: dsSlope4,
        // usTGC: state.usTGC,
      ),
    ));
  }

  void _onDSSlope4Decreased(
    DSSlope4Decreased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String dsSlope4 = _getDecreasedNumber(state.dsSlope4);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsSlope4: dsSlope4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        rtnInputAttenuation2: state.rtnInputAttenuation2,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
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
        dsVVA5: state.dsVVA5,
        dsSlope3: state.dsSlope3,
        dsSlope4: dsSlope4,
        // usTGC: state.usTGC,
      ),
    ));
  }

  // void _onUSTGCChanged(
  //   USTGCChanged event,
  //   Emitter<Setting18ControlState> emit,
  // ) {
  //   emit(state.copyWith(
  //     submissionStatus: SubmissionStatus.none,
  //     usTGC: event.usTGC,
  //     isInitialize: false,
  //     enableSubmission: _isEnabledSubmission(
  //       fwdInputAttenuation: state.fwdInputAttenuation,
  //       dsSlope1: state.dsSlope1,
  //       rtnInputAttenuation2: state.rtnInputAttenuation2,
  //       rtnInputAttenuation3: state.rtnInputAttenuation3,
  //       rtnInputAttenuation4: state.rtnInputAttenuation4,
  //       rtnOutputLevelAttenuation: state.rtnOutputLevelAttenuation,
  //       rtnOutputEQ: state.rtnOutputEQ,
  //       rtnIngressSetting2: state.rtnIngressSetting2,
  //       rtnIngressSetting3: state.rtnIngressSetting3,
  //       rtnIngressSetting4: state.rtnIngressSetting4,
  //       tgcCableLength: state.tgcCableLength,
  //       dsVVA2: state.dsVVA2,
  //       dsSlope2: state.dsSlope2,
  //       dsVVA3: state.dsVVA3,
  //       dsVVA4: state.dsVVA4,
  //       usTGC: event.usTGC,
  //     ),
  //   ));
  // }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: false,
      editMode: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: false,
      editMode: false,
      enableSubmission: false,
      dsVVA1: state.initialValues[DataKey.dsVVA1],
      dsSlope1: state.initialValues[DataKey.dsSlope1],
      rtnInputAttenuation2: state.initialValues[DataKey.inputAttenuation2],
      usVCA3: state.initialValues[DataKey.usVCA3],
      usVCA4: state.initialValues[DataKey.usVCA4],
      rtnOutputLevelAttenuation: state.initialValues[DataKey.outputAttenuation],
      rtnOutputEQ: state.initialValues[DataKey.outputEqualizer],
      rtnIngressSetting2: state.initialValues[DataKey.ingressSetting2],
      rtnIngressSetting3: state.initialValues[DataKey.ingressSetting3],
      rtnIngressSetting4: state.initialValues[DataKey.ingressSetting4],
      tgcCableLength: state.initialValues[DataKey.tgcCableLength],
      dsVVA2: state.initialValues[DataKey.dsVVA2],
      dsSlope2: state.initialValues[DataKey.dsSlope2],
      dsVVA3: state.initialValues[DataKey.dsVVA3],
      dsVVA4: state.initialValues[DataKey.dsVVA4],
      dsSlope3: state.initialValues[DataKey.dsSlope3],
      // usTGC: state.initialValues[DataKey.usTGC],
    ));
  }

  bool _isEnabledSubmission({
    required String dsVVA1,
    required String dsSlope1,
    required String rtnInputAttenuation2,
    required String usVCA3,
    required String usVCA4,
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
    required String dsVVA5,
    required String dsSlope3,
    required String dsSlope4,
    // required String usTGC,
  }) {
    if (dsVVA1 != state.initialValues[DataKey.dsVVA1] ||
            dsSlope1 != state.initialValues[DataKey.dsSlope1] ||
            rtnInputAttenuation2 !=
                state.initialValues[DataKey.inputAttenuation2] ||
            usVCA3 != state.initialValues[DataKey.usVCA3] ||
            usVCA4 != state.initialValues[DataKey.usVCA4] ||
            rtnOutputLevelAttenuation !=
                state.initialValues[DataKey.outputAttenuation] ||
            rtnOutputEQ != state.initialValues[DataKey.outputEqualizer] ||
            rtnIngressSetting2 !=
                state.initialValues[DataKey.ingressSetting2] ||
            rtnIngressSetting3 !=
                state.initialValues[DataKey.ingressSetting3] ||
            rtnIngressSetting4 !=
                state.initialValues[DataKey.ingressSetting4] ||
            tgcCableLength != state.initialValues[DataKey.tgcCableLength] ||
            dsVVA2 != state.initialValues[DataKey.dsVVA2] ||
            dsSlope2 != state.initialValues[DataKey.dsSlope2] ||
            dsVVA3 != state.initialValues[DataKey.dsVVA3] ||
            dsVVA4 != state.initialValues[DataKey.dsVVA4] ||
            dsVVA5 != state.initialValues[DataKey.dsVVA5] ||
            dsSlope3 != state.initialValues[DataKey.dsSlope3] ||
            dsSlope4 != state.initialValues[DataKey.dsSlope4] ||
            usVCA3 != state.initialValues[DataKey.usVCA3] ||
            usVCA3 != state.initialValues[DataKey.usVCA4]
        // usTGC != state.initialValues[DataKey.usTGC]
        ) {
      return true;
    } else {
      return false;
    }
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18ControlState> emit,
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

    if (state.dsSlope1 != state.initialValues[DataKey.dsSlope1]) {
      bool resultOfDSSlope1 =
          await _amp18Repository.set1p8GDSSlope1(state.dsSlope1);

      settingResult.add('${DataKey.dsSlope1.name},$resultOfDSSlope1');
    }

    if (state.rtnInputAttenuation2 !=
        state.initialValues[DataKey.inputAttenuation2]) {
      bool resultOfSetReturnInputAttenuation2 = await _amp18Repository
          .set1p8GReturnInputAttenuation2(state.rtnInputAttenuation2);

      settingResult.add(
          '${DataKey.inputAttenuation2.name},$resultOfSetReturnInputAttenuation2');
    }

    if (state.usVCA3 != state.initialValues[DataKey.usVCA3]) {
      bool resultOfSetReturnUSVCA3 =
          await _amp18Repository.set1p8GUSVCA3(state.usVCA3);

      settingResult.add('${DataKey.usVCA3.name},$resultOfSetReturnUSVCA3');
    }

    if (state.usVCA4 != state.initialValues[DataKey.usVCA4]) {
      bool resultOfSetUSVCA4 =
          await _amp18Repository.set1p8GUSVCA4(state.usVCA4);

      settingResult.add('${DataKey.usVCA4.name},$resultOfSetUSVCA4');
    }

    if (state.rtnOutputLevelAttenuation !=
        state.initialValues[DataKey.outputAttenuation]) {
      bool resultOfSetReturnOutputAttenuation = await _amp18Repository
          .set1p8GReturnOutputAttenuation(state.rtnOutputLevelAttenuation);

      settingResult.add(
          '${DataKey.outputAttenuation.name},$resultOfSetReturnOutputAttenuation');
    }

    if (state.rtnOutputEQ != state.initialValues[DataKey.outputEqualizer]) {
      bool resultOfSetReturnOutputEqualizer = await _amp18Repository
          .set1p8GReturnOutputEqualizer(state.rtnOutputEQ);

      settingResult.add(
          '${DataKey.outputEqualizer.name},$resultOfSetReturnOutputEqualizer');
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
          await _amp18Repository.set1p8DSVVA4(state.dsVVA4);

      settingResult.add('${DataKey.dsVVA4.name},$resultOfSetDSVVA4');
    }

    if (state.dsSlope3 != state.initialValues[DataKey.dsSlope3]) {
      bool resultOfSetDSSlope3 =
          await _amp18Repository.set1p8DSSlope3(state.dsSlope3);

      settingResult.add('${DataKey.dsSlope3.name},$resultOfSetDSSlope3');
    }

    // if (state.usTGC != state.initialValues[DataKey.usTGC]) {
    //   bool resultOfSetUSTGC = await _amp18Repository.set1p8USTGC(state.usTGC);

    //   settingResult.add('${DataKey.usTGC.name},$resultOfSetUSTGC');
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
