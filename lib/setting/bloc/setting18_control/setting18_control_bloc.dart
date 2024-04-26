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
    on<DSSlope1Changed>(_onDSSlope1Changed);
    on<USVCA1Changed>(_onUSVCA1Changed);
    on<USVCA3Changed>(_onUSVCA3Changed);
    on<USVCA4Changed>(_onUSVCA4Changed);
    on<USVCA2Changed>(_onUSVCA2Changed);
    on<EREQChanged>(_onEREQChanged);
    on<RtnIngressSetting2Changed>(_onRtnIngressSetting2Changed);
    on<RtnIngressSetting3Changed>(_onRtnIngressSetting3Changed);
    on<RtnIngressSetting4Changed>(_onRtnIngressSetting4Changed);
    on<TGCCableLengthChanged>(_onTGCCableLengthChanged);
    on<DSVVA2Changed>(_onDSVVA2Changed);
    on<DSSlope2Changed>(_onDSSlope2Changed);
    on<DSVVA3Changed>(_onDSVVA3Changed);
    on<DSVVA4Changed>(_onDSVVA4Changed);
    on<DSVVA5Changed>(_onDSVVA5Changed);
    on<DSSlope3Changed>(_onDSSlope3Changed);
    on<DSSlope4Changed>(_onDSSlope4Changed);
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
      initialValues: characteristicDataCache,
    ));
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

  void _onDSSlope1Changed(
    DSSlope1Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsSlope1: event.dsSlope1,
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

  void _onUSVCA1Changed(
    USVCA1Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA1: event.usVCA1,
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

  void _onUSVCA3Changed(
    USVCA3Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA3: event.usVCA3,
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

  void _onUSVCA4Changed(
    USVCA4Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA4: event.usVCA4,
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

  void _onUSVCA2Changed(
    USVCA2Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      usVCA2: event.usVCA2,
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

  void _onEREQChanged(
    EREQChanged event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      eREQ: event.eREQ,
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

  void _onRtnIngressSetting2Changed(
    RtnIngressSetting2Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      returnIngressSetting2: event.returnIngressSetting2,
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

  void _onDSVVA5Changed(
    DSVVA5Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsVVA5: event.dsVVA5,
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

  void _onDSSlope3Changed(
    DSSlope3Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsSlope3: event.dsSlope3,
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

  void _onDSSlope4Changed(
    DSSlope4Changed event,
    Emitter<Setting18ControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      resetForwardValuesSubmissionStatus: SubmissionStatus.none,
      resetReverseValuesSubmissionStatus: SubmissionStatus.none,
      dsSlope4: event.dsSlope4,
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

  // void _onUSTGCChanged(
  //   USTGCChanged event,
  //   Emitter<Setting18ControlState> emit,
  // ) {
  //   emit(state.copyWith(
  //     submissionStatus: SubmissionStatus.none,
  //     usTGC: event.usTGC,
  //
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
    if (dsVVA1.isEmpty ||
        dsSlope1.isEmpty ||
        usVCA1.isEmpty ||
        usVCA3.isEmpty ||
        usVCA4.isEmpty ||
        usVCA2.isEmpty ||
        eREQ.isEmpty ||
        dsVVA2.isEmpty ||
        dsSlope2.isEmpty ||
        dsVVA3.isEmpty ||
        dsVVA4.isEmpty ||
        dsVVA5.isEmpty ||
        dsSlope3.isEmpty ||
        dsSlope4.isEmpty ||
        usVCA3.isEmpty ||
        usVCA3.isEmpty) {
      return false;
    } else {
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
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18ControlState> emit,
  ) async {
    emit(state.copyWith(
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
