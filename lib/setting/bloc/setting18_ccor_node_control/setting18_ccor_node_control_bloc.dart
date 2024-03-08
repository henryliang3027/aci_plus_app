import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_ccor_node_control_event.dart';
part 'setting18_ccor_node_control_state.dart';

class Setting18CCorNodeControlBloc
    extends Bloc<Setting18CCorNodeControlEvent, Setting18CCorNodeControlState> {
  Setting18CCorNodeControlBloc({
    required Amp18CCorNodeRepository amp18CCorNodeRepository,
  })  : _amp18CCorNodeRepository = amp18CCorNodeRepository,
        super(const Setting18CCorNodeControlState()) {
    on<Initialized>(_onInitialized);
    on<DSVVA1Changed>(_onDSVVA1Changed);
    on<DSVVA1Increased>(_onDSVVA1Increased);
    on<DSVVA1Decreased>(_onDSVVA1Decreased);
    on<DSVVA3Changed>(_onDSVVA3Changed);
    on<DSVVA3Increased>(_onDSVVA3Increased);
    on<DSVVA3Decreased>(_onDSVVA3Decreased);
    on<DSVVA4Changed>(_onDSVVA4Changed);
    on<DSVVA4Increased>(_onDSVVA4Increased);
    on<DSVVA4Decreased>(_onDSVVA4Decreased);
    on<DSVVA6Changed>(_onDSVVA6Changed);
    on<DSVVA6Increased>(_onDSVVA6Increased);
    on<DSVVA6Decreased>(_onDSVVA6Decreased);
    on<DSInSlope1Changed>(_onDSInSlope1Changed);
    on<DSInSlope1Increased>(_onDSInSlope1Increased);
    on<DSInSlope1Decreased>(_onDSInSlope1Decreased);
    on<DSInSlope3Changed>(_onDSInSlope3Changed);
    on<DSInSlope3Increased>(_onDSInSlope3Increased);
    on<DSInSlope3Decreased>(_onDSInSlope3Decreased);
    on<DSInSlope4Changed>(_onDSInSlope4Changed);
    on<DSInSlope4Increased>(_onDSInSlope4Increased);
    on<DSInSlope4Decreased>(_onDSInSlope4Decreased);
    on<DSInSlope6Changed>(_onDSInSlope6Changed);
    on<DSInSlope6Increased>(_onDSInSlope6Increased);
    on<DSInSlope6Decreased>(_onDSInSlope6Decreased);
    on<USVCA1Changed>(_onUSVCA1Changed);
    on<USVCA1Increased>(_onUSVCA1Increased);
    on<USVCA1Decreased>(_onUSVCA1Decreased);
    on<USVCA3Changed>(_onUSVCA3Changed);
    on<USVCA3Increased>(_onUSVCA3Increased);
    on<USVCA3Decreased>(_onUSVCA3Decreased);
    on<USVCA4Changed>(_onUSVCA4Changed);
    on<USVCA4Increased>(_onUSVCA4Increased);
    on<USVCA4Decreased>(_onUSVCA4Decreased);
    on<USVCA6Changed>(_onUSVCA6Changed);
    on<USVCA6Increased>(_onUSVCA6Increased);
    on<USVCA6Decreased>(_onUSVCA6Decreased);
    on<ReturnIngressSetting1Changed>(_onReturnIngressSetting1Changed);
    on<ReturnIngressSetting3Changed>(_onReturnIngressSetting3Changed);
    on<ReturnIngressSetting4Changed>(_onReturnIngressSetting4Changed);
    on<ReturnIngressSetting6Changed>(_onReturnIngressSetting6Changed);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);

    add(const Initialized());
  }

  final Amp18CCorNodeRepository _amp18CCorNodeRepository;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) async {
    Map<DataKey, String> characteristicDataCache =
        _amp18CCorNodeRepository.characteristicDataCache;

    String dsVVA1 = characteristicDataCache[DataKey.dsVVA1] ?? '';
    String dsVVA3 = characteristicDataCache[DataKey.dsVVA3] ?? '';
    String dsVVA4 = characteristicDataCache[DataKey.dsVVA4] ?? '';
    String dsVVA6 = characteristicDataCache[DataKey.dsVVA6] ?? '';
    String dsInSlope1 = characteristicDataCache[DataKey.dsInSlope1] ?? '';
    String dsInSlope3 = characteristicDataCache[DataKey.dsInSlope3] ?? '';
    String dsInSlope4 = characteristicDataCache[DataKey.dsInSlope4] ?? '';
    String dsInSlope6 = characteristicDataCache[DataKey.dsInSlope6] ?? '';
    String usVCA1 = characteristicDataCache[DataKey.usVCA1] ?? '';
    String usVCA3 = characteristicDataCache[DataKey.usVCA3] ?? '';
    String usVCA4 = characteristicDataCache[DataKey.usVCA4] ?? '';
    String usVCA6 = characteristicDataCache[DataKey.usVCA6] ?? '';
    String returnIngressSetting1 =
        characteristicDataCache[DataKey.ingressSetting1] ?? '';
    String returnIngressSetting3 =
        characteristicDataCache[DataKey.ingressSetting3] ?? '';
    String returnIngressSetting4 =
        characteristicDataCache[DataKey.ingressSetting4] ?? '';
    String returnIngressSetting6 =
        characteristicDataCache[DataKey.ingressSetting6] ?? '';

    emit(state.copyWith(
      dsVVA1: dsVVA1,
      dsVVA3: dsVVA3,
      dsVVA4: dsVVA4,
      dsVVA6: dsVVA6,
      dsInSlope1: dsInSlope1,
      dsInSlope3: dsInSlope3,
      dsInSlope4: dsInSlope4,
      dsInSlope6: dsInSlope6,
      usVCA1: usVCA1,
      usVCA3: usVCA3,
      usVCA4: usVCA4,
      usVCA6: usVCA6,
      returnIngressSetting1: returnIngressSetting1,
      returnIngressSetting3: returnIngressSetting3,
      returnIngressSetting4: returnIngressSetting4,
      returnIngressSetting6: returnIngressSetting6,
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
        doubleValue + 0.5 <= maxValue ? doubleValue + 0.5 : doubleValue;
    String strValue = doubleValue.toStringAsFixed(1);

    return strValue;
  }

  String _getDecreasedNumber({
    required String value,
    required double minValue,
  }) {
    double doubleValue = double.parse(value);
    doubleValue =
        doubleValue - 0.5 >= minValue ? doubleValue - 0.5 : doubleValue;
    String strValue = doubleValue.toStringAsFixed(1);

    return strValue;
  }

  void _onDSVVA1Changed(
    DSVVA1Changed event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA1: event.dsVVA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: event.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSVVA1Increased(
    DSVVA1Increased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String dsVVA1 = _getIncreasedNumber(
      value: state.dsVVA1,
      maxValue: event.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA1: dsVVA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSVVA1Decreased(
    DSVVA1Decreased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String dsVVA1 = _getDecreasedNumber(
      value: state.dsVVA1,
      minValue: event.minValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA1: dsVVA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSVVA3Changed(
    DSVVA3Changed event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA3: event.dsVVA3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: event.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSVVA3Increased(
    DSVVA3Increased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String dsVVA3 = _getIncreasedNumber(
      value: state.dsVVA3,
      maxValue: event.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA3: dsVVA3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSVVA3Decreased(
    DSVVA3Decreased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String dsVVA3 = _getDecreasedNumber(
      value: state.dsVVA3,
      minValue: event.minValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA3: dsVVA3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSVVA4Changed(
    DSVVA4Changed event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA4: event.dsVVA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: event.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSVVA4Increased(
    DSVVA4Increased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String dsVVA4 = _getIncreasedNumber(
      value: state.dsVVA4,
      maxValue: event.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA4: dsVVA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSVVA4Decreased(
    DSVVA4Decreased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String dsVVA4 = _getDecreasedNumber(
      value: state.dsVVA4,
      minValue: event.minValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA4: dsVVA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSVVA6Changed(
    DSVVA6Changed event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA6: event.dsVVA6,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: event.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSVVA6Increased(
    DSVVA6Increased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String dsVVA6 = _getIncreasedNumber(
      value: state.dsVVA6,
      maxValue: event.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA6: dsVVA6,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSVVA6Decreased(
    DSVVA6Decreased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String dsVVA6 = _getDecreasedNumber(
      value: state.dsVVA6,
      minValue: event.minValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsVVA6: dsVVA6,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSInSlope1Changed(
    DSInSlope1Changed event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsInSlope1: event.dsInSlope1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: event.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSInSlope1Increased(
    DSInSlope1Increased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String dsInSlope1 = _getIncreasedNumber(
      value: state.dsInSlope1,
      maxValue: event.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsInSlope1: dsInSlope1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSInSlope1Decreased(
    DSInSlope1Decreased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String dsInSlope1 = _getDecreasedNumber(
      value: state.dsInSlope1,
      minValue: event.minValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsInSlope1: dsInSlope1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSInSlope3Changed(
    DSInSlope3Changed event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsInSlope3: event.dsInSlope3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: event.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSInSlope3Increased(
    DSInSlope3Increased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String dsInSlope3 = _getIncreasedNumber(
      value: state.dsInSlope3,
      maxValue: event.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsInSlope3: dsInSlope3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSInSlope3Decreased(
    DSInSlope3Decreased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String dsInSlope3 = _getDecreasedNumber(
      value: state.dsInSlope3,
      minValue: event.minValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsInSlope3: dsInSlope3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSInSlope4Changed(
    DSInSlope4Changed event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsInSlope4: event.dsInSlope4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: event.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSInSlope4Increased(
    DSInSlope4Increased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String dsInSlope4 = _getIncreasedNumber(
      value: state.dsInSlope4,
      maxValue: event.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsInSlope4: dsInSlope4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSInSlope4Decreased(
    DSInSlope4Decreased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String dsInSlope4 = _getDecreasedNumber(
      value: state.dsInSlope4,
      minValue: event.minValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsInSlope4: dsInSlope4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSInSlope6Changed(
    DSInSlope6Changed event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsInSlope6: event.dsInSlope6,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: event.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSInSlope6Increased(
    DSInSlope6Increased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String dsInSlope6 = _getIncreasedNumber(
      value: state.dsInSlope6,
      maxValue: event.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsInSlope6: dsInSlope6,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onDSInSlope6Decreased(
    DSInSlope6Decreased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String dsInSlope6 = _getDecreasedNumber(
      value: state.dsInSlope6,
      minValue: event.minValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      dsInSlope6: dsInSlope6,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onUSVCA1Changed(
    USVCA1Changed event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA1: event.usVCA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: event.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onUSVCA1Increased(
    USVCA1Increased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String usVCA1 = _getIncreasedNumber(
      value: state.usVCA1,
      maxValue: event.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA1: usVCA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onUSVCA1Decreased(
    USVCA1Decreased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String usVCA1 = _getDecreasedNumber(
      value: state.usVCA1,
      minValue: event.minValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA1: usVCA1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onUSVCA3Changed(
    USVCA3Changed event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA3: event.usVCA3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: event.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onUSVCA3Increased(
    USVCA3Increased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String usVCA3 = _getIncreasedNumber(
      value: state.usVCA3,
      maxValue: event.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA3: usVCA3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onUSVCA3Decreased(
    USVCA3Decreased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String usVCA3 = _getDecreasedNumber(
      value: state.usVCA3,
      minValue: event.minValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA3: usVCA3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onUSVCA4Changed(
    USVCA4Changed event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA4: event.usVCA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: event.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onUSVCA4Increased(
    USVCA4Increased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String usVCA4 = _getIncreasedNumber(
      value: state.usVCA4,
      maxValue: event.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA4: usVCA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onUSVCA4Decreased(
    USVCA4Decreased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String usVCA4 = _getDecreasedNumber(
      value: state.usVCA4,
      minValue: event.minValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA4: usVCA4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onUSVCA6Changed(
    USVCA6Changed event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA6: event.usVCA6,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: event.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onUSVCA6Increased(
    USVCA6Increased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String usVCA6 = _getIncreasedNumber(
      value: state.usVCA6,
      maxValue: event.maxValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA6: usVCA6,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onUSVCA6Decreased(
    USVCA6Decreased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String usVCA6 = _getDecreasedNumber(
      value: state.usVCA6,
      minValue: event.minValue,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      usVCA6: usVCA6,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onReturnIngressSetting1Changed(
    ReturnIngressSetting1Changed event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnIngressSetting1: event.returnIngressSetting1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: event.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onReturnIngressSetting3Changed(
    ReturnIngressSetting3Changed event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnIngressSetting3: event.returnIngressSetting3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: event.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onReturnIngressSetting4Changed(
    ReturnIngressSetting4Changed event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnIngressSetting4: event.returnIngressSetting4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: event.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onReturnIngressSetting6Changed(
    ReturnIngressSetting6Changed event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnIngressSetting6: event.returnIngressSetting6,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        dsVVA1: state.dsVVA1,
        dsVVA3: state.dsVVA3,
        dsVVA4: state.dsVVA4,
        dsVVA6: state.dsVVA6,
        dsInSlope1: state.dsInSlope1,
        dsInSlope3: state.dsInSlope3,
        dsInSlope4: state.dsInSlope4,
        dsInSlope6: state.dsInSlope6,
        usVCA1: state.usVCA1,
        usVCA3: state.usVCA3,
        usVCA4: state.usVCA4,
        usVCA6: state.usVCA6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: event.returnIngressSetting6,
      ),
    ));
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: false,
      editMode: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: true,
      editMode: false,
      enableSubmission: false,
      dsVVA1: state.initialValues[DataKey.dsVVA1],
      dsVVA3: state.initialValues[DataKey.dsVVA3],
      dsVVA4: state.initialValues[DataKey.dsVVA4],
      dsVVA6: state.initialValues[DataKey.dsVVA6],
      dsInSlope1: state.initialValues[DataKey.dsInSlope1],
      dsInSlope3: state.initialValues[DataKey.dsInSlope3],
      dsInSlope4: state.initialValues[DataKey.dsInSlope4],
      dsInSlope6: state.initialValues[DataKey.dsInSlope6],
      usVCA1: state.initialValues[DataKey.usVCA1],
      usVCA3: state.initialValues[DataKey.usVCA3],
      usVCA4: state.initialValues[DataKey.usVCA4],
      usVCA6: state.initialValues[DataKey.usVCA6],
      returnIngressSetting1: state.initialValues[DataKey.ingressSetting1],
      returnIngressSetting3: state.initialValues[DataKey.ingressSetting3],
      returnIngressSetting4: state.initialValues[DataKey.ingressSetting4],
      returnIngressSetting6: state.initialValues[DataKey.ingressSetting6],
    ));
  }

  String _boolToStringNumber(bool value) {
    if (value) {
      // alarm enable
      return '0';
    } else {
      // alarm mask
      return '1';
    }
  }

  bool _isEnabledSubmission({
    required String dsVVA1,
    required String dsVVA3,
    required String dsVVA4,
    required String dsVVA6,
    required String dsInSlope1,
    required String dsInSlope3,
    required String dsInSlope4,
    required String dsInSlope6,
    required String usVCA1,
    required String usVCA3,
    required String usVCA4,
    required String usVCA6,
    required String returnIngressSetting1,
    required String returnIngressSetting3,
    required String returnIngressSetting4,
    required String returnIngressSetting6,
  }) {
    if (dsVVA1 != state.initialValues[DataKey.dsVVA1] ||
        dsVVA3 != state.initialValues[DataKey.dsVVA3] ||
        dsVVA4 != state.initialValues[DataKey.dsVVA4] ||
        dsVVA6 != state.initialValues[DataKey.dsVVA6] ||
        dsInSlope1 != state.initialValues[DataKey.dsInSlope1] ||
        dsInSlope3 != state.initialValues[DataKey.dsInSlope3] ||
        dsInSlope4 != state.initialValues[DataKey.dsInSlope4] ||
        dsInSlope6 != state.initialValues[DataKey.dsInSlope6] ||
        usVCA1 != state.initialValues[DataKey.usVCA1] ||
        usVCA3 != state.initialValues[DataKey.usVCA3] ||
        usVCA4 != state.initialValues[DataKey.usVCA4] ||
        usVCA6 != state.initialValues[DataKey.usVCA6] ||
        returnIngressSetting1 != state.initialValues[DataKey.ingressSetting1] ||
        returnIngressSetting3 != state.initialValues[DataKey.ingressSetting3] ||
        returnIngressSetting4 != state.initialValues[DataKey.ingressSetting4] ||
        returnIngressSetting6 != state.initialValues[DataKey.ingressSetting6]) {
      return true;
    } else {
      return false;
    }
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) async {
    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    List<String> settingResult = [];

    if (state.dsVVA1 != state.initialValues[DataKey.dsVVA1]) {
      bool resultOfSetDSVVA1 =
          await _amp18CCorNodeRepository.set1p8GCCorNodeDSVVA1(state.dsVVA1);

      settingResult.add('${DataKey.dsVVA1.name},$resultOfSetDSVVA1');
    }

    if (state.dsVVA3 != state.initialValues[DataKey.dsVVA3]) {
      bool resultOfSetDSVVA3 =
          await _amp18CCorNodeRepository.set1p8GCCorNodeDSVVA3(state.dsVVA3);

      settingResult.add('${DataKey.dsVVA3.name},$resultOfSetDSVVA3');
    }

    if (state.dsVVA4 != state.initialValues[DataKey.dsVVA4]) {
      bool resultOfSetDSVVA4 =
          await _amp18CCorNodeRepository.set1p8GCCorNodeDSVVA4(state.dsVVA4);

      settingResult.add('${DataKey.dsVVA4.name},$resultOfSetDSVVA4');
    }

    if (state.dsVVA6 != state.initialValues[DataKey.dsVVA6]) {
      bool resultOfSetDSVVA6 =
          await _amp18CCorNodeRepository.set1p8GCCorNodeDSVVA6(state.dsVVA6);

      settingResult.add('${DataKey.dsVVA6.name},$resultOfSetDSVVA6');
    }

    if (state.dsInSlope1 != state.initialValues[DataKey.dsInSlope1]) {
      bool resultOfSetDSInSlope1 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSInSlope1(state.dsInSlope1);

      settingResult.add('${DataKey.dsInSlope1.name},$resultOfSetDSInSlope1');
    }

    if (state.dsInSlope3 != state.initialValues[DataKey.dsInSlope3]) {
      bool resultOfSetDSInSlope3 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSInSlope3(state.dsInSlope3);

      settingResult.add('${DataKey.dsInSlope3.name},$resultOfSetDSInSlope3');
    }

    if (state.dsInSlope4 != state.initialValues[DataKey.dsInSlope4]) {
      bool resultOfSetDSInSlope4 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSInSlope4(state.dsInSlope4);

      settingResult.add('${DataKey.dsInSlope4.name},$resultOfSetDSInSlope4');
    }

    if (state.dsInSlope6 != state.initialValues[DataKey.dsInSlope6]) {
      bool resultOfSetDSInSlope6 = await _amp18CCorNodeRepository
          .set1p8GCCorNodeDSInSlope6(state.dsInSlope6);

      settingResult.add('${DataKey.dsInSlope6.name},$resultOfSetDSInSlope6');
    }

    if (state.usVCA1 != state.initialValues[DataKey.usVCA1]) {
      bool resultOfSetUSVCA1 =
          await _amp18CCorNodeRepository.set1p8GCCorNodeUSVCA1(state.usVCA1);

      settingResult.add('${DataKey.usVCA1.name},$resultOfSetUSVCA1');
    }

    if (state.usVCA3 != state.initialValues[DataKey.usVCA3]) {
      bool resultOfSetUSVCA3 =
          await _amp18CCorNodeRepository.set1p8GCCorNodeUSVCA3(state.usVCA3);

      settingResult.add('${DataKey.usVCA3.name},$resultOfSetUSVCA3');
    }

    if (state.usVCA4 != state.initialValues[DataKey.usVCA4]) {
      bool resultOfSetUSVCA4 =
          await _amp18CCorNodeRepository.set1p8GCCorNodeUSVCA4(state.usVCA4);

      settingResult.add('${DataKey.usVCA4.name},$resultOfSetUSVCA4');
    }

    if (state.usVCA6 != state.initialValues[DataKey.usVCA6]) {
      bool resultOfSetUSVCA6 =
          await _amp18CCorNodeRepository.set1p8GCCorNodeUSVCA6(state.usVCA6);

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
      editMode: false,
    ));
  }
}
