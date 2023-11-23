import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_ccor_node_control_event.dart';
part 'setting18_ccor_node_control_state.dart';

class Setting18CCorNodeControlBloc
    extends Bloc<Setting18CCorNodeControlEvent, Setting18CCorNodeControlState> {
  Setting18CCorNodeControlBloc({
    required Amp18CCorNodeRepository dsimRepository,
  })  : _dsimRepository = dsimRepository,
        super(const Setting18CCorNodeControlState()) {
    on<Initialized>(_onInitialized);
    on<ReturnInputAttenuation1Changed>(_onReturnInputAttenuation1Changed);
    on<ReturnInputAttenuation1Increased>(_onReturnInputAttenuation1Increased);
    on<ReturnInputAttenuation1Decreased>(_onReturnInputAttenuation1Decreased);
    on<ReturnInputAttenuation3Changed>(_onReturnInputAttenuation3Changed);
    on<ReturnInputAttenuation3Increased>(_onReturnInputAttenuation3Increased);
    on<ReturnInputAttenuation3Decreased>(_onReturnInputAttenuation3Decreased);
    on<ReturnInputAttenuation4Changed>(_onReturnInputAttenuation4Changed);
    on<ReturnInputAttenuation4Increased>(_onReturnInputAttenuation4Increased);
    on<ReturnInputAttenuation4Decreased>(_onReturnInputAttenuation4Decreased);
    on<ReturnInputAttenuation6Changed>(_onReturnInputAttenuation6Changed);
    on<ReturnInputAttenuation6Increased>(_onReturnInputAttenuation6Increased);
    on<ReturnInputAttenuation6Decreased>(_onReturnInputAttenuation6Decreased);
    on<ReturnIngressSetting1Changed>(_onReturnIngressSetting1Changed);
    on<ReturnIngressSetting3Changed>(_onReturnIngressSetting3Changed);
    on<ReturnIngressSetting4Changed>(_onReturnIngressSetting4Changed);
    on<ReturnIngressSetting6Changed>(_onReturnIngressSetting6Changed);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);
  }

  final Amp18CCorNodeRepository _dsimRepository;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) async {
    emit(state.copyWith(
      returnInputAttenuation1: event.returnInputAttenuation1,
      returnInputAttenuation3: event.returnInputAttenuation3,
      returnInputAttenuation4: event.returnInputAttenuation4,
      returnInputAttenuation6: event.returnInputAttenuation6,
      returnIngressSetting1: event.returnIngressSetting1,
      returnIngressSetting3: event.returnIngressSetting3,
      returnIngressSetting4: event.returnIngressSetting4,
      returnIngressSetting6: event.returnIngressSetting6,
      isInitialize: true,
      initialValues: [
        event.returnInputAttenuation1,
        event.returnInputAttenuation3,
        event.returnInputAttenuation4,
        event.returnInputAttenuation6,
        event.returnIngressSetting1,
        event.returnIngressSetting3,
        event.returnIngressSetting4,
        event.returnIngressSetting6,
      ],
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

  void _onReturnInputAttenuation1Changed(
    ReturnInputAttenuation1Changed event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnInputAttenuation1: event.returnInputAttenuation1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        returnInputAttenuation1: event.returnInputAttenuation1,
        returnInputAttenuation3: state.returnInputAttenuation3,
        returnInputAttenuation4: state.returnInputAttenuation4,
        returnInputAttenuation6: state.returnInputAttenuation6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onReturnInputAttenuation1Increased(
    ReturnInputAttenuation1Increased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String returnInputAttenuation1 =
        _getIncreasedNumber(state.returnInputAttenuation1);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnInputAttenuation1: returnInputAttenuation1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        returnInputAttenuation1: returnInputAttenuation1,
        returnInputAttenuation3: state.returnInputAttenuation3,
        returnInputAttenuation4: state.returnInputAttenuation4,
        returnInputAttenuation6: state.returnInputAttenuation6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onReturnInputAttenuation1Decreased(
    ReturnInputAttenuation1Decreased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String returnInputAttenuation1 =
        _getDecreasedNumber(state.returnInputAttenuation1);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnInputAttenuation1: returnInputAttenuation1,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        returnInputAttenuation1: returnInputAttenuation1,
        returnInputAttenuation3: state.returnInputAttenuation3,
        returnInputAttenuation4: state.returnInputAttenuation4,
        returnInputAttenuation6: state.returnInputAttenuation6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onReturnInputAttenuation3Changed(
    ReturnInputAttenuation3Changed event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnInputAttenuation3: event.returnInputAttenuation3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        returnInputAttenuation1: state.returnInputAttenuation1,
        returnInputAttenuation3: event.returnInputAttenuation3,
        returnInputAttenuation4: state.returnInputAttenuation4,
        returnInputAttenuation6: state.returnInputAttenuation6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onReturnInputAttenuation3Increased(
    ReturnInputAttenuation3Increased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String returnInputAttenuation3 =
        _getIncreasedNumber(state.returnInputAttenuation3);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnInputAttenuation3: returnInputAttenuation3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        returnInputAttenuation1: state.returnInputAttenuation1,
        returnInputAttenuation3: returnInputAttenuation3,
        returnInputAttenuation4: state.returnInputAttenuation4,
        returnInputAttenuation6: state.returnInputAttenuation6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onReturnInputAttenuation3Decreased(
    ReturnInputAttenuation3Decreased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String returnInputAttenuation3 =
        _getDecreasedNumber(state.returnInputAttenuation3);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnInputAttenuation3: returnInputAttenuation3,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        returnInputAttenuation1: state.returnInputAttenuation1,
        returnInputAttenuation3: returnInputAttenuation3,
        returnInputAttenuation4: state.returnInputAttenuation4,
        returnInputAttenuation6: state.returnInputAttenuation6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onReturnInputAttenuation4Changed(
    ReturnInputAttenuation4Changed event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnInputAttenuation4: event.returnInputAttenuation4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        returnInputAttenuation1: state.returnInputAttenuation1,
        returnInputAttenuation3: state.returnInputAttenuation3,
        returnInputAttenuation4: event.returnInputAttenuation4,
        returnInputAttenuation6: state.returnInputAttenuation6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onReturnInputAttenuation4Increased(
    ReturnInputAttenuation4Increased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String returnInputAttenuation4 =
        _getIncreasedNumber(state.returnInputAttenuation4);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnInputAttenuation4: returnInputAttenuation4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        returnInputAttenuation1: state.returnInputAttenuation1,
        returnInputAttenuation3: state.returnInputAttenuation3,
        returnInputAttenuation4: returnInputAttenuation4,
        returnInputAttenuation6: state.returnInputAttenuation6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onReturnInputAttenuation4Decreased(
    ReturnInputAttenuation4Decreased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String returnInputAttenuation4 =
        _getDecreasedNumber(state.returnInputAttenuation4);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnInputAttenuation4: returnInputAttenuation4,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        returnInputAttenuation1: state.returnInputAttenuation1,
        returnInputAttenuation3: state.returnInputAttenuation3,
        returnInputAttenuation4: returnInputAttenuation4,
        returnInputAttenuation6: state.returnInputAttenuation6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onReturnInputAttenuation6Changed(
    ReturnInputAttenuation6Changed event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnInputAttenuation6: event.returnInputAttenuation6,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        returnInputAttenuation1: state.returnInputAttenuation1,
        returnInputAttenuation3: state.returnInputAttenuation3,
        returnInputAttenuation4: state.returnInputAttenuation4,
        returnInputAttenuation6: event.returnInputAttenuation6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onReturnInputAttenuation6Increased(
    ReturnInputAttenuation6Increased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String returnInputAttenuation6 =
        _getIncreasedNumber(state.returnInputAttenuation6);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnInputAttenuation6: returnInputAttenuation6,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        returnInputAttenuation1: state.returnInputAttenuation1,
        returnInputAttenuation3: state.returnInputAttenuation3,
        returnInputAttenuation4: state.returnInputAttenuation4,
        returnInputAttenuation6: returnInputAttenuation6,
        returnIngressSetting1: state.returnIngressSetting1,
        returnIngressSetting3: state.returnIngressSetting3,
        returnIngressSetting4: state.returnIngressSetting4,
        returnIngressSetting6: state.returnIngressSetting6,
      ),
    ));
  }

  void _onReturnInputAttenuation6Decreased(
    ReturnInputAttenuation6Decreased event,
    Emitter<Setting18CCorNodeControlState> emit,
  ) {
    String returnInputAttenuation6 =
        _getDecreasedNumber(state.returnInputAttenuation6);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      returnInputAttenuation6: returnInputAttenuation6,
      isInitialize: false,
      enableSubmission: _isEnabledSubmission(
        returnInputAttenuation1: state.returnInputAttenuation1,
        returnInputAttenuation3: state.returnInputAttenuation3,
        returnInputAttenuation4: state.returnInputAttenuation4,
        returnInputAttenuation6: returnInputAttenuation6,
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
        returnInputAttenuation1: state.returnInputAttenuation1,
        returnInputAttenuation3: state.returnInputAttenuation3,
        returnInputAttenuation4: state.returnInputAttenuation4,
        returnInputAttenuation6: state.returnInputAttenuation6,
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
        returnInputAttenuation1: state.returnInputAttenuation1,
        returnInputAttenuation3: state.returnInputAttenuation3,
        returnInputAttenuation4: state.returnInputAttenuation4,
        returnInputAttenuation6: state.returnInputAttenuation6,
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
        returnInputAttenuation1: state.returnInputAttenuation1,
        returnInputAttenuation3: state.returnInputAttenuation3,
        returnInputAttenuation4: state.returnInputAttenuation4,
        returnInputAttenuation6: state.returnInputAttenuation6,
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
        returnInputAttenuation1: state.returnInputAttenuation1,
        returnInputAttenuation3: state.returnInputAttenuation3,
        returnInputAttenuation4: state.returnInputAttenuation4,
        returnInputAttenuation6: state.returnInputAttenuation6,
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
      returnInputAttenuation1: state.initialValues[0],
      returnInputAttenuation3: state.initialValues[1],
      returnInputAttenuation4: state.initialValues[2],
      returnInputAttenuation6: state.initialValues[3],
      returnIngressSetting1: state.initialValues[4],
      returnIngressSetting3: state.initialValues[5],
      returnIngressSetting4: state.initialValues[6],
      returnIngressSetting6: state.initialValues[7],
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
    required String returnInputAttenuation1,
    required String returnInputAttenuation3,
    required String returnInputAttenuation4,
    required String returnInputAttenuation6,
    required String returnIngressSetting1,
    required String returnIngressSetting3,
    required String returnIngressSetting4,
    required String returnIngressSetting6,
  }) {
    if (returnInputAttenuation1 != state.initialValues[0] ||
        returnInputAttenuation3 != state.initialValues[1] ||
        returnInputAttenuation4 != state.initialValues[2] ||
        returnInputAttenuation6 != state.initialValues[3] ||
        returnIngressSetting1 != state.initialValues[4] ||
        returnIngressSetting3 != state.initialValues[5] ||
        returnIngressSetting4 != state.initialValues[6] ||
        returnIngressSetting6 != state.initialValues[7]) {
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

    if (state.returnInputAttenuation1 != state.initialValues[0]) {}

    if (state.returnInputAttenuation3 != state.initialValues[1]) {}

    if (state.returnInputAttenuation4 != state.initialValues[2]) {}

    if (state.returnInputAttenuation6 != state.initialValues[3]) {}

    if (state.returnIngressSetting1 != state.initialValues[4]) {}
    if (state.returnIngressSetting3 != state.initialValues[5]) {}
    if (state.returnIngressSetting4 != state.initialValues[6]) {}
    if (state.returnIngressSetting6 != state.initialValues[7]) {}

    // 等待 device 完成更新後在讀取值
    await Future.delayed(const Duration(milliseconds: 1000));

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
      enableSubmission: false,
      editMode: false,
    ));

    await _dsimRepository.update1p8GCCorNodeCharacteristics();
  }
}
