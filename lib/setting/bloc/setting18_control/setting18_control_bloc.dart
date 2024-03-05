import 'package:aci_plus_app/core/data_key.dart';
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
    on<USVCA1Changed>(_onUSVCA1Changed);
    on<USVCA1Increased>(_onUSVCA1Increased);
    on<USVCA1Decreased>(_onUSVCA1Decreased);
    on<USVCA3Changed>(_onUSVCA3Changed);
    on<USVCA3Increased>(_onUSVCA3Increased);
    on<USVCA3Decreased>(_onUSVCA3Decreased);
    on<USVCA4Changed>(_onUSVCA4Changed);
    on<USVCA4Increased>(_onUSVCA4Increased);
    on<USVCA4Decreased>(_onUSVCA4Decreased);
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
    on<ResetForwardValuesRequested>(_onResetForwardValuesRequested);
    on<ResetReverseValuesRequested>(_onResetReverseValuesRequested);
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
    String usVCA1 = characteristicDataCache[DataKey.usVCA1] ?? '';
    String usVCA3 = characteristicDataCache[DataKey.usVCA3] ?? '';
    String usVCA4 = characteristicDataCache[DataKey.usVCA4] ?? '';
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
    String dsVVA5 = characteristicDataCache[DataKey.dsVVA5] ?? '';
    String dsSlope3 = characteristicDataCache[DataKey.dsSlope3] ?? '';
    String dsSlope4 = characteristicDataCache[DataKey.dsSlope4] ?? '';

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA1: dsVVA1,
      dsSlope1: dsSlope1,
      usVCA1: usVCA1,
      usVCA3: usVCA3,
      usVCA4: usVCA4,
      usVCA2: usVCA2,
      eREQ: eREQ,
      returnIngressSetting2: ingressSetting2,
      returnIngressSetting3: ingressSetting3,
      returnIngressSetting4: ingressSetting4,
      tgcCableLength: tgcCableLength,
      dsVVA2: dsVVA2,
      dsSlope2: dsSlope2,
      dsVVA3: dsVVA3,
      dsVVA4: dsVVA4,
      dsVVA5: dsVVA5,
      dsSlope3: dsSlope3,
      dsSlope4: dsSlope4,
      isInitialize: true,
      initialValues: characteristicDataCache,
    ));
  }

  String _getIncreasedNumber({
    required String value,
    required double maxValue,
  }) {
    double doubleValue = double.parse(value);
    doubleValue =
        doubleValue + 0.1 <= maxValue ? doubleValue + 0.1 : doubleValue;
    String strValue = doubleValue.toStringAsFixed(1);

    return strValue;
  }

  String _getDecreasedNumber({
    required String value,
    required double minValue,
  }) {
    double doubleValue = double.parse(value);
    doubleValue =
        doubleValue - 0.1 >= minValue ? doubleValue - 0.1 : doubleValue;
    String strValue = doubleValue.toStringAsFixed(1);

    return strValue;
  }

  void _onDSVVA1Changed(
    DSVVA1Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA1: event.dsVVA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: event.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
    String dsVVA1 = _getIncreasedNumber(
      value: state.dsVVA1,
      maxValue: event.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA1: dsVVA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
    String dsVVA1 = _getDecreasedNumber(
      value: state.dsVVA1,
      minValue: event.minValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA1: dsVVA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsSlope1: event.dsSlope1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: event.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
    String dsSlope1 = _getIncreasedNumber(
      value: state.dsSlope1,
      maxValue: event.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsSlope1: dsSlope1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
    String dsSlope1 = _getDecreasedNumber(
      value: state.dsSlope1,
      minValue: event.minValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsSlope1: dsSlope1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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

  void _onUSVCA1Changed(
    USVCA1Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA1: event.usVCA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: event.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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

  void _onUSVCA1Increased(
    USVCA1Increased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String usVCA1 = _getIncreasedNumber(
      value: state.usVCA1,
      maxValue: event.maxValue,
    );
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA1: usVCA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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

  void _onUSVCA1Decreased(
    USVCA1Decreased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String usVCA1 = _getDecreasedNumber(
      value: state.usVCA1,
      minValue: event.minValue,
    );
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA1: usVCA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA3: event.usVCA3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: event.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
    String usVCA3 = _getIncreasedNumber(
      value: state.usVCA3,
      maxValue: event.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA3: usVCA3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
    String usVCA3 = _getDecreasedNumber(
      value: state.usVCA3,
      minValue: event.minValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA3: usVCA3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA4: event.usVCA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: event.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
    String usVCA4 = _getIncreasedNumber(
      value: state.usVCA4,
      maxValue: event.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA4: usVCA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
    String usVCA4 = _getDecreasedNumber(
      value: state.usVCA4,
      minValue: event.minValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA4: usVCA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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

  void _onUSVCA2Changed(
    USVCA2Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA2: event.usVCA2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: event.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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

  void _onUSVCA2Increased(
    USVCA2Increased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String usVCA2 = _getIncreasedNumber(
      value: state.usVCA2,
      maxValue: event.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA2: usVCA2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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

  void _onUSVCA2Decreased(
    USVCA2Decreased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String usVCA2 = _getDecreasedNumber(
      value: state.usVCA2,
      minValue: event.minValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA2: usVCA2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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

  void _onEREQChanged(
    EREQChanged event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      eREQ: event.eREQ,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: event.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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

  void _onEREQIncreased(
    EREQIncreased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String eREQ = _getIncreasedNumber(
      value: state.eREQ,
      maxValue: event.maxValue,
    );
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      eREQ: eREQ,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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

  void _onEREQDecreased(
    EREQDecreased event,
    Emitter<Setting18ControlState> emit,
  ) {
    String eREQ = _getDecreasedNumber(
      value: state.eREQ,
      minValue: event.minValue,
    );
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      eREQ: eREQ,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      returnIngressSetting2: event.returnIngressSetting2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: event.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      returnIngressSetting3: event.returnIngressSetting3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: event.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      returnIngressSetting4: event.returnIngressSetting4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: event.returnIngressSetting4,
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
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      tgcCableLength: event.tgcCableLength,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA2: event.dsVVA2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsSlope2: event.dsSlope2,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA3: event.dsVVA3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA4: event.dsVVA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
    String dsVVA4 = _getIncreasedNumber(
      value: state.dsVVA4,
      maxValue: event.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA4: dsVVA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
    String dsVVA4 = _getDecreasedNumber(
      value: state.dsVVA4,
      minValue: event.minValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA4: dsVVA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA5: event.dsVVA5,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
    String dsVVA5 = _getIncreasedNumber(
      value: state.dsVVA5,
      maxValue: event.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA5: dsVVA5,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
    String dsVVA5 = _getDecreasedNumber(
      value: state.dsVVA5,
      minValue: event.minValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA5: dsVVA5,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsSlope3: event.dsSlope3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
    String dsSlope3 = _getIncreasedNumber(
      value: state.dsSlope3,
      maxValue: event.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsSlope3: dsSlope3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
    String dsSlope3 = _getDecreasedNumber(
      value: state.dsSlope3,
      minValue: event.minValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsSlope3: dsSlope3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsSlope4: event.dsSlope4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
    String dsSlope4 = _getIncreasedNumber(
      value: state.dsSlope4,
      maxValue: event.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsSlope4: dsSlope4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
    String dsSlope4 = _getDecreasedNumber(
      value: state.dsSlope4,
      minValue: event.minValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsSlope4: dsSlope4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsSlope1: state.dsSlope1,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA2: state.usVCA2,
        eREQ: state.eREQ,
        returnIngressSetting2: state.returnIngressSetting2,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
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
  //     ),
  //   ));
  // }

  void _onResetForwardValuesRequested(
    ResetForwardValuesRequested event,
    Emitter<Setting18ControlState> emit,
  ) async {
    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.submissionInProgress,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
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

  void _onResetReverseValuesRequested(
    ResetReverseValuesRequested event,
    Emitter<Setting18ControlState> emit,
  ) async {
    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
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

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
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
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      isInitialize: false,
      editMode: false,
      enableSubmission: false,
      dsVVA1: state.initialValues[DataKey.dsVVA1],
      dsSlope1: state.initialValues[DataKey.dsSlope1],
      usVCA1: state.initialValues[DataKey.usVCA1],
      usVCA3: state.initialValues[DataKey.usVCA3],
      usVCA4: state.initialValues[DataKey.usVCA4],
      usVCA2: state.initialValues[DataKey.usVCA2],
      eREQ: state.initialValues[DataKey.eREQ],
      returnIngressSetting2: state.initialValues[DataKey.ingressSetting2],
      returnIngressSetting3: state.initialValues[DataKey.ingressSetting3],
      returnIngressSetting4: state.initialValues[DataKey.ingressSetting4],
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
    required String usVCA1,
    required String usVCA3,
    required String usVCA4,
    required String usVCA2,
    required String eREQ,
    required String returnIngressSetting2,
    required String returnIngressSetting3,
    required String returnIngressSetting4,
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
            usVCA1 != state.initialValues[DataKey.usVCA1] ||
            usVCA3 != state.initialValues[DataKey.usVCA3] ||
            usVCA4 != state.initialValues[DataKey.usVCA4] ||
            usVCA2 != state.initialValues[DataKey.usVCA2] ||
            eREQ != state.initialValues[DataKey.eREQ] ||
            returnIngressSetting2 !=
                state.initialValues[DataKey.ingressSetting2] ||
            returnIngressSetting3 !=
                state.initialValues[DataKey.ingressSetting3] ||
            returnIngressSetting4 !=
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

    if (state.dsVVA4 != state.initialValues[DataKey.dsVVA4]) {
      bool resultOfDSVVA4 = await _amp18Repository.set1p8GDSVVA4(state.dsVVA4);

      settingResult.add('${DataKey.dsVVA4.name},$resultOfDSVVA4');
    }

    if (state.dsVVA5 != state.initialValues[DataKey.dsVVA5]) {
      bool resultOfDSVVA5 = await _amp18Repository.set1p8GDSVVA5(state.dsVVA5);

      settingResult.add('${DataKey.dsVVA5.name},$resultOfDSVVA5');
    }

    if (state.dsSlope3 != state.initialValues[DataKey.dsSlope3]) {
      bool resultOfSetDSSlope3 =
          await _amp18Repository.set1p8DSSlope3(state.dsSlope3);

      settingResult.add('${DataKey.dsSlope3.name},$resultOfSetDSSlope3');
    }

    if (state.dsSlope4 != state.initialValues[DataKey.dsSlope4]) {
      bool resultOfSetDSSlope4 =
          await _amp18Repository.set1p8DSSlope4(state.dsSlope4);

      settingResult.add('${DataKey.dsSlope4.name},$resultOfSetDSSlope4');
    }

    if (state.usVCA1 != state.initialValues[DataKey.usVCA1]) {
      bool resultOfSetUSVCA1Cmd =
          await _amp18Repository.set1p8GUSVCA1(state.usVCA1);

      settingResult.add('${DataKey.usVCA1.name},$resultOfSetUSVCA1Cmd');
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

    if (state.usVCA2 != state.initialValues[DataKey.usVCA2]) {
      bool resultOfSetUSVCA2 =
          await _amp18Repository.set1p8GUSVCA2(state.usVCA2);

      settingResult.add('${DataKey.usVCA2.name},$resultOfSetUSVCA2');
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
