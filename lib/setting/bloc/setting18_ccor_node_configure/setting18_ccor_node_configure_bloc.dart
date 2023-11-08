import 'package:aci_plus_app/core/command.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_ccor_node_configure_event.dart';
part 'setting18_ccor_node_configure_state.dart';

class Setting18CCorNodeConfigureBloc extends Bloc<
    Setting18CCorNodeConfigureEvent, Setting18CCorNodeConfigureState> {
  Setting18CCorNodeConfigureBloc({
    required DsimRepository dsimRepository,
  })  : _dsimRepository = dsimRepository,
        super(const Setting18CCorNodeConfigureState()) {
    on<Initialized>(_onInitialized);
    on<LocationChanged>(_onLocationChanged);
    on<CoordinatesChanged>(_onCoordinatesChanged);
    on<GPSCoordinatesRequested>(_onGPSCoordinatesRequested);
    on<SplitOptionChanged>(_onSplitOptionChanged);
    on<LogIntervalChanged>(_onLogIntervalChanged);
    on<LogIntervalIncreased>(_onLogIntervalIncreased);
    on<LogIntervalDecreased>(_onLogIntervalDecreased);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);
  }

  final DsimRepository _dsimRepository;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18CCorNodeConfigureState> emit,
  ) async {
    emit(state.copyWith(
      location: event.location,
      coordinates: event.coordinates,
      splitOption: event.splitOption,
      logInterval: event.logInterval,
      isInitialize: true,
      initialValues: [
        event.location,
        event.coordinates,
        event.splitOption,
        event.logInterval,
      ],
    ));
  }

  void _onLocationChanged(
    LocationChanged event,
    Emitter<Setting18CCorNodeConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      location: event.location,
      enableSubmission: _isEnabledSubmission(
        location: event.location,
        coordinates: state.coordinates,
        splitOption: state.splitOption,
        logInterval: state.logInterval,
      ),
    ));
  }

  void _onCoordinatesChanged(
    CoordinatesChanged event,
    Emitter<Setting18CCorNodeConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      coordinates: event.coordinates,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: event.coordinates,
        splitOption: state.splitOption,
        logInterval: state.logInterval,
      ),
    ));
  }

  Future<void> _onGPSCoordinatesRequested(
    GPSCoordinatesRequested event,
    Emitter<Setting18CCorNodeConfigureState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.requestInProgress,
    ));

    try {
      String coordinates = await _dsimRepository.getGPSCoordinates();
      emit(state.copyWith(
        gpsStatus: FormStatus.requestSuccess,
        coordinates: coordinates,
        enableSubmission: _isEnabledSubmission(
          location: state.location,
          coordinates: coordinates,
          splitOption: state.splitOption,
          logInterval: state.logInterval,
        ),
      ));
    } catch (error) {
      emit(state.copyWith(
        gpsStatus: FormStatus.requestFailure,
        gpsCoordinateErrorMessage: error.toString(),
        enableSubmission: _isEnabledSubmission(
          location: state.location,
          coordinates: state.coordinates,
          splitOption: state.splitOption,
          logInterval: state.logInterval,
        ),
      ));
    }
  }

  void _onSplitOptionChanged(
    SplitOptionChanged event,
    Emitter<Setting18CCorNodeConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      splitOption: event.splitOption,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: state.coordinates,
        splitOption: event.splitOption,
        logInterval: state.logInterval,
      ),
    ));
  }

  void _onLogIntervalChanged(
    LogIntervalChanged event,
    Emitter<Setting18CCorNodeConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      logInterval: event.logInterval,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: state.coordinates,
        splitOption: state.splitOption,
        logInterval: event.logInterval,
      ),
    ));
  }

  String _getIncreasedNumber(String value) {
    double doubleValue = double.parse(value);
    doubleValue = doubleValue + 1.0 <= 60.0 ? doubleValue + 1.0 : doubleValue;
    String strValue = doubleValue.toStringAsFixed(0);

    return strValue;
  }

  String _getDecreasedNumber(String value) {
    double doubleValue = double.parse(value);
    doubleValue = doubleValue - 1.0 >= 1.0 ? doubleValue - 1.0 : doubleValue;
    String strValue = doubleValue.toStringAsFixed(0);

    return strValue;
  }

  void _onLogIntervalIncreased(
    LogIntervalIncreased event,
    Emitter<Setting18CCorNodeConfigureState> emit,
  ) {
    String logInterval = _getIncreasedNumber(state.logInterval);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      logInterval: logInterval,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: state.coordinates,
        splitOption: state.splitOption,
        logInterval: logInterval,
      ),
    ));
  }

  void _onLogIntervalDecreased(
    LogIntervalDecreased event,
    Emitter<Setting18CCorNodeConfigureState> emit,
  ) {
    String logInterval = _getDecreasedNumber(state.logInterval);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      logInterval: logInterval,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: state.coordinates,
        splitOption: state.splitOption,
        logInterval: logInterval,
      ),
    ));
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18CCorNodeConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      isInitialize: false,
      editMode: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<Setting18CCorNodeConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      isInitialize: true,
      editMode: false,
      enableSubmission: false,
      location: state.initialValues[0],
      coordinates: state.initialValues[1],
      splitOption: state.initialValues[2],
      logInterval: state.initialValues[3],
    ));
  }

  bool _isEnabledSubmission({
    required String location,
    required String coordinates,
    required String splitOption,
    required String logInterval,
  }) {
    if (location != state.initialValues[0] ||
        coordinates != state.initialValues[1] ||
        splitOption != state.initialValues[2] ||
        logInterval != state.initialValues[3]) {
      return true;
    } else {
      return false;
    }
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18CCorNodeConfigureState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
      gpsStatus: FormStatus.none,
      isInitialize: false,
    ));

    List<String> settingResult = [];

    if (state.location != state.initialValues[0]) {
      bool resultOfSetLocation =
          await _dsimRepository.set1p8GLocation(state.location);

      settingResult.add('${DataKey.location.name},$resultOfSetLocation');
    }

    if (state.coordinates != state.initialValues[1]) {
      bool resultOfSetCoordinates =
          await _dsimRepository.set1p8GCoordinates(state.coordinates);

      settingResult.add('${DataKey.coordinates.name},$resultOfSetCoordinates');
    }

    if (state.splitOption != state.initialValues[2]) {
      bool resultOfSetSplitOption =
          await _dsimRepository.set1p8GSplitOption(state.splitOption);

      settingResult.add('${DataKey.splitOption.name},$resultOfSetSplitOption');
    }

    if (state.logInterval != state.initialValues[12]) {
      bool resultOfSetLogInterval =
          await _dsimRepository.set1p8GLogInterval(state.logInterval);

      settingResult.add('${DataKey.logInterval.name},$resultOfSetLogInterval');
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
