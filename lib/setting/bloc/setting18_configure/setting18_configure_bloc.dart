import 'package:aci_plus_app/core/command.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:aci_plus_app/repositories/gps_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_configure_event.dart';
part 'setting18_configure_state.dart';

class Setting18ConfigureBloc
    extends Bloc<Setting18ConfigureEvent, Setting18ConfigureState> {
  Setting18ConfigureBloc({
    required DsimRepository dsimRepository,
    required GPSRepository gpsRepository,
  })  : _dsimRepository = dsimRepository,
        _gpsRepository = gpsRepository,
        super(const Setting18ConfigureState()) {
    on<Initialized>(_onInitialized);
    on<LocationChanged>(_onLocationChanged);
    on<CoordinatesChanged>(_onCoordinatesChanged);
    on<GPSCoordinatesRequested>(_onGPSCoordinatesRequested);
    on<SplitOptionChanged>(_onSplitOptionChanged);
    on<FirstChannelLoadingFrequencyChanged>(
        _onFirstChannelLoadingFrequencyChanged);
    on<FirstChannelLoadingLevelChanged>(_onFirstChannelLoadingLevelChanged);
    on<LastChannelLoadingFrequencyChanged>(
        _onLastChannelLoadingFrequencyChanged);
    on<LastChannelLoadingLevelChanged>(_onLastChannelLoadingLevelChanged);
    on<PilotFrequencyModeChanged>(_onPilotFrequencyModeChanged);
    on<PilotFrequency1Changed>(_onPilotFrequency1Changed);
    on<PilotFrequency2Changed>(_onPilotFrequency2Changed);
    on<FwdAGCModeChanged>(_onFwdAGCModeChanged);
    on<AutoLevelControlChanged>(_onAutoLevelControlChanged);
    on<LogIntervalChanged>(_onLogIntervalChanged);
    on<LogIntervalIncreased>(_onLogIntervalIncreased);
    on<LogIntervalDecreased>(_onLogIntervalDecreased);
    on<TGCCableLengthChanged>(_onTGCCableLengthChanged);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);
  }

  final DsimRepository _dsimRepository;
  final GPSRepository _gpsRepository;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18ConfigureState> emit,
  ) async {
    emit(state.copyWith(
      location: event.location,
      coordinates: event.coordinates,
      splitOption: event.splitOption,
      firstChannelLoadingFrequency: event.firstChannelLoadingFrequency,
      firstChannelLoadingLevel: event.firstChannelLoadingLevel,
      lastChannelLoadingFrequency: event.lastChannelLoadingFrequency,
      lastChannelLoadingLevel: event.lastChannelLoadingLevel,
      pilotFrequencyMode: event.pilotFrequencyMode,
      pilotFrequency1: event.pilotFrequency1,
      pilotFrequency2: event.pilotFrequency2,
      manualModePilot1RFOutputPower: event.manualModePilot1RFOutputPower,
      manualModePilot2RFOutputPower: event.manualModePilot2RFOutputPower,
      fwdAGCMode: event.fwdAGCMode,
      autoLevelControl: event.autoLevelControl,
      logInterval: event.logInterval,
      tgcCableLength: event.tgcCableLength,
      isInitialize: true,
      initialValues: [
        event.location,
        event.coordinates,
        event.splitOption,
        event.firstChannelLoadingFrequency,
        event.firstChannelLoadingLevel,
        event.lastChannelLoadingFrequency,
        event.lastChannelLoadingLevel,
        event.pilotFrequencyMode,
        event.pilotFrequency1,
        event.pilotFrequency2,
        event.fwdAGCMode,
        event.autoLevelControl,
        event.logInterval,
        event.tgcCableLength,
      ],
    ));
  }

  void _onLocationChanged(
    LocationChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      location: event.location,
      enableSubmission: _isEnabledSubmission(
        location: event.location,
        coordinates: state.coordinates,
        splitOption: state.splitOption,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequencyMode: state.pilotFrequencyMode,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        fwdAGCMode: state.fwdAGCMode,
        autoLevelControl: state.autoLevelControl,
        logInterval: state.logInterval,
        tgcCableLength: state.tgcCableLength,
      ),
    ));
  }

  void _onCoordinatesChanged(
    CoordinatesChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      coordinates: event.coordinates,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: event.coordinates,
        splitOption: state.splitOption,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequencyMode: state.pilotFrequencyMode,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        fwdAGCMode: state.fwdAGCMode,
        autoLevelControl: state.autoLevelControl,
        logInterval: state.logInterval,
        tgcCableLength: state.tgcCableLength,
      ),
    ));
  }

  Future<void> _onGPSCoordinatesRequested(
    GPSCoordinatesRequested event,
    Emitter<Setting18ConfigureState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.requestInProgress,
    ));

    try {
      String coordinates = await _gpsRepository.getGPSCoordinates();
      emit(state.copyWith(
        gpsStatus: FormStatus.requestSuccess,
        coordinates: coordinates,
        enableSubmission: _isEnabledSubmission(
          location: state.location,
          coordinates: coordinates,
          splitOption: state.splitOption,
          firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
          firstChannelLoadingLevel: state.firstChannelLoadingLevel,
          lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
          lastChannelLoadingLevel: state.lastChannelLoadingLevel,
          pilotFrequencyMode: state.pilotFrequencyMode,
          pilotFrequency1: state.pilotFrequency1,
          pilotFrequency2: state.pilotFrequency2,
          fwdAGCMode: state.fwdAGCMode,
          autoLevelControl: state.autoLevelControl,
          logInterval: state.logInterval,
          tgcCableLength: state.tgcCableLength,
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
          firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
          firstChannelLoadingLevel: state.firstChannelLoadingLevel,
          lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
          lastChannelLoadingLevel: state.lastChannelLoadingLevel,
          pilotFrequencyMode: state.pilotFrequencyMode,
          pilotFrequency1: state.pilotFrequency1,
          pilotFrequency2: state.pilotFrequency2,
          fwdAGCMode: state.fwdAGCMode,
          autoLevelControl: state.autoLevelControl,
          logInterval: state.logInterval,
          tgcCableLength: state.tgcCableLength,
        ),
      ));
    }
  }

  void _onSplitOptionChanged(
    SplitOptionChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      splitOption: event.splitOption,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: state.coordinates,
        splitOption: event.splitOption,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequencyMode: state.pilotFrequencyMode,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        fwdAGCMode: state.fwdAGCMode,
        autoLevelControl: state.autoLevelControl,
        logInterval: state.logInterval,
        tgcCableLength: state.tgcCableLength,
      ),
    ));
  }

  void _onFirstChannelLoadingFrequencyChanged(
    FirstChannelLoadingFrequencyChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      firstChannelLoadingFrequency: event.firstChannelLoadingFrequency,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: state.coordinates,
        splitOption: state.splitOption,
        firstChannelLoadingFrequency: event.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequencyMode: state.pilotFrequencyMode,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        fwdAGCMode: state.fwdAGCMode,
        autoLevelControl: state.autoLevelControl,
        logInterval: state.logInterval,
        tgcCableLength: state.tgcCableLength,
      ),
    ));
  }

  void _onFirstChannelLoadingLevelChanged(
    FirstChannelLoadingLevelChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      firstChannelLoadingLevel: event.firstChannelLoadingLevel,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: state.coordinates,
        splitOption: state.splitOption,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: event.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequencyMode: state.pilotFrequencyMode,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        fwdAGCMode: state.fwdAGCMode,
        autoLevelControl: state.autoLevelControl,
        logInterval: state.logInterval,
        tgcCableLength: state.tgcCableLength,
      ),
    ));
  }

  void _onLastChannelLoadingFrequencyChanged(
    LastChannelLoadingFrequencyChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      lastChannelLoadingFrequency: event.lastChannelLoadingFrequency,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: state.coordinates,
        splitOption: state.splitOption,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: event.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequencyMode: state.pilotFrequencyMode,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        fwdAGCMode: state.fwdAGCMode,
        autoLevelControl: state.autoLevelControl,
        logInterval: state.logInterval,
        tgcCableLength: state.tgcCableLength,
      ),
    ));
  }

  void _onLastChannelLoadingLevelChanged(
    LastChannelLoadingLevelChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      lastChannelLoadingLevel: event.lastChannelLoadingLevel,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: state.coordinates,
        splitOption: state.splitOption,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: event.lastChannelLoadingLevel,
        pilotFrequencyMode: state.pilotFrequencyMode,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        fwdAGCMode: state.fwdAGCMode,
        autoLevelControl: state.autoLevelControl,
        logInterval: state.logInterval,
        tgcCableLength: state.tgcCableLength,
      ),
    ));
  }

  void _onPilotFrequencyModeChanged(
    PilotFrequencyModeChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      pilotFrequencyMode: event.pilotFrequencyMode,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: state.coordinates,
        splitOption: state.splitOption,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequencyMode: event.pilotFrequencyMode,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        fwdAGCMode: state.fwdAGCMode,
        autoLevelControl: state.autoLevelControl,
        logInterval: state.logInterval,
        tgcCableLength: state.tgcCableLength,
      ),
    ));
  }

  void _onPilotFrequency1Changed(
    PilotFrequency1Changed event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      pilotFrequency1: event.pilotFrequency1,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: state.coordinates,
        splitOption: state.splitOption,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequencyMode: state.pilotFrequencyMode,
        pilotFrequency1: event.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        fwdAGCMode: state.fwdAGCMode,
        autoLevelControl: state.autoLevelControl,
        logInterval: state.logInterval,
        tgcCableLength: state.tgcCableLength,
      ),
    ));
  }

  void _onPilotFrequency2Changed(
    PilotFrequency2Changed event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      pilotFrequency2: event.pilotFrequency2,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: state.coordinates,
        splitOption: state.splitOption,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequencyMode: state.pilotFrequencyMode,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: event.pilotFrequency2,
        fwdAGCMode: state.fwdAGCMode,
        autoLevelControl: state.autoLevelControl,
        logInterval: state.logInterval,
        tgcCableLength: state.tgcCableLength,
      ),
    ));
  }

  void _onFwdAGCModeChanged(
    FwdAGCModeChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      fwdAGCMode: event.fwdAGCMode,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: state.coordinates,
        splitOption: state.splitOption,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequencyMode: state.pilotFrequencyMode,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        fwdAGCMode: event.fwdAGCMode,
        autoLevelControl: state.autoLevelControl,
        logInterval: state.logInterval,
        tgcCableLength: state.tgcCableLength,
      ),
    ));
  }

  void _onAutoLevelControlChanged(
    AutoLevelControlChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      autoLevelControl: event.autoLevelControl,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: state.coordinates,
        splitOption: state.splitOption,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequencyMode: state.pilotFrequencyMode,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        fwdAGCMode: state.fwdAGCMode,
        autoLevelControl: event.autoLevelControl,
        logInterval: state.logInterval,
        tgcCableLength: state.tgcCableLength,
      ),
    ));
  }

  void _onLogIntervalChanged(
    LogIntervalChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      logInterval: event.logInterval,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: state.coordinates,
        splitOption: state.splitOption,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequencyMode: state.pilotFrequencyMode,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        fwdAGCMode: state.fwdAGCMode,
        autoLevelControl: state.autoLevelControl,
        logInterval: event.logInterval,
        tgcCableLength: state.tgcCableLength,
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
    Emitter<Setting18ConfigureState> emit,
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
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequencyMode: state.pilotFrequencyMode,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        fwdAGCMode: state.fwdAGCMode,
        autoLevelControl: state.autoLevelControl,
        logInterval: logInterval,
        tgcCableLength: state.tgcCableLength,
      ),
    ));
  }

  void _onLogIntervalDecreased(
    LogIntervalDecreased event,
    Emitter<Setting18ConfigureState> emit,
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
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequencyMode: state.pilotFrequencyMode,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        fwdAGCMode: state.fwdAGCMode,
        autoLevelControl: state.autoLevelControl,
        logInterval: logInterval,
        tgcCableLength: state.tgcCableLength,
      ),
    ));
  }

  void _onTGCCableLengthChanged(
    TGCCableLengthChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      tgcCableLength: event.tgcCableLength,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: state.coordinates,
        splitOption: state.splitOption,
        firstChannelLoadingFrequency: state.firstChannelLoadingFrequency,
        firstChannelLoadingLevel: state.firstChannelLoadingLevel,
        lastChannelLoadingFrequency: state.lastChannelLoadingFrequency,
        lastChannelLoadingLevel: state.lastChannelLoadingLevel,
        pilotFrequencyMode: state.pilotFrequencyMode,
        pilotFrequency1: state.pilotFrequency1,
        pilotFrequency2: state.pilotFrequency2,
        fwdAGCMode: state.fwdAGCMode,
        autoLevelControl: state.autoLevelControl,
        logInterval: state.logInterval,
        tgcCableLength: event.tgcCableLength,
      ),
    ));
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18ConfigureState> emit,
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
    Emitter<Setting18ConfigureState> emit,
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
      firstChannelLoadingFrequency: state.initialValues[3],
      firstChannelLoadingLevel: state.initialValues[4],
      lastChannelLoadingFrequency: state.initialValues[5],
      lastChannelLoadingLevel: state.initialValues[6],
      pilotFrequencyMode: state.initialValues[7],
      pilotFrequency1: state.initialValues[8],
      pilotFrequency2: state.initialValues[9],
      fwdAGCMode: state.initialValues[10],
      autoLevelControl: state.initialValues[11],
      logInterval: state.initialValues[12],
      tgcCableLength: state.initialValues[13],
    ));
  }

  bool _isEnabledSubmission({
    required String location,
    required String coordinates,
    required String splitOption,
    required String firstChannelLoadingFrequency,
    required String firstChannelLoadingLevel,
    required String lastChannelLoadingFrequency,
    required String lastChannelLoadingLevel,
    required String pilotFrequencyMode,
    required String pilotFrequency1,
    required String pilotFrequency2,
    required String fwdAGCMode,
    required String autoLevelControl,
    required String logInterval,
    required String tgcCableLength,
  }) {
    if (location != state.initialValues[0] ||
        coordinates != state.initialValues[1] ||
        splitOption != state.initialValues[2] ||
        firstChannelLoadingFrequency != state.initialValues[3] ||
        firstChannelLoadingLevel != state.initialValues[4] ||
        lastChannelLoadingFrequency != state.initialValues[5] ||
        lastChannelLoadingLevel != state.initialValues[6] ||
        pilotFrequencyMode != state.initialValues[7] ||
        pilotFrequency1 != state.initialValues[8] ||
        pilotFrequency2 != state.initialValues[9] ||
        fwdAGCMode != state.initialValues[10] ||
        autoLevelControl != state.initialValues[11] ||
        logInterval != state.initialValues[12] ||
        tgcCableLength != state.initialValues[13]) {
      return true;
    } else {
      return false;
    }
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18ConfigureState> emit,
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

    if (state.firstChannelLoadingFrequency != state.initialValues[3]) {
      bool resultOfSetFirstChannelLoadingFrequency =
          await _dsimRepository.set1p8GFirstChannelLoadingFrequency(
              state.firstChannelLoadingFrequency);

      settingResult.add(
          '${DataKey.firstChannelLoadingFrequency.name},$resultOfSetFirstChannelLoadingFrequency');
    }

    if (state.firstChannelLoadingLevel != state.initialValues[4]) {
      bool resultOfSetFirstChannelLoadingLevel = await _dsimRepository
          .set1p8GFirstChannelLoadingLevel(state.firstChannelLoadingLevel);

      settingResult.add(
          '${DataKey.firstChannelLoadingLevel.name},$resultOfSetFirstChannelLoadingLevel');
    }

    if (state.lastChannelLoadingFrequency != state.initialValues[5]) {
      bool resultOfSetLastChannelLoadingFrequency =
          await _dsimRepository.set1p8GLastChannelLoadingFrequency(
              state.lastChannelLoadingFrequency);

      settingResult.add(
          '${DataKey.lastChannelLoadingFrequency.name},$resultOfSetLastChannelLoadingFrequency');
    }

    if (state.lastChannelLoadingLevel != state.initialValues[6]) {
      bool resultOfSetLastChannelLoadingLevel = await _dsimRepository
          .set1p8GLastChannelLoadingLevel(state.lastChannelLoadingLevel);

      settingResult.add(
          '${DataKey.lastChannelLoadingLevel.name},$resultOfSetLastChannelLoadingLevel');
    }

    if (state.pilotFrequencyMode != state.initialValues[7]) {
      bool resultOfSetPilotFrequencyMode = await _dsimRepository
          .set1p8GPilotFrequencyMode(state.pilotFrequencyMode);

      settingResult.add(
          '${DataKey.pilotFrequencyMode.name},$resultOfSetPilotFrequencyMode');
    }

    if (state.pilotFrequency1 != state.initialValues[8]) {
      bool resultOfSetPilotFrequency1 =
          await _dsimRepository.set1p8GPilotFrequency1(state.pilotFrequency1);

      settingResult
          .add('${DataKey.pilotFrequency1.name},$resultOfSetPilotFrequency1');
    }

    if (state.pilotFrequency2 != state.initialValues[9]) {
      bool resultOfSetPilotFrequency2 =
          await _dsimRepository.set1p8GPilotFrequency2(state.pilotFrequency2);

      settingResult
          .add('${DataKey.pilotFrequency2.name},$resultOfSetPilotFrequency2');
    }

    if (state.fwdAGCMode != state.initialValues[10]) {
      bool resultOfSetForwardAGCMode =
          await _dsimRepository.set1p8GForwardAGCMode(state.fwdAGCMode);

      settingResult.add('${DataKey.agcMode.name},$resultOfSetForwardAGCMode');
    }

    if (state.autoLevelControl != state.initialValues[11]) {
      bool resultOfSetALCMode =
          await _dsimRepository.set1p8GALCMode(state.autoLevelControl);

      settingResult.add('${DataKey.alcMode.name},$resultOfSetALCMode');
    }

    if (state.logInterval != state.initialValues[12]) {
      bool resultOfSetLogInterval =
          await _dsimRepository.set1p8GLogInterval(state.logInterval);

      settingResult.add('${DataKey.logInterval.name},$resultOfSetLogInterval');
    }

    if (state.tgcCableLength != state.initialValues[13]) {
      bool resultOfSetTGCCableLength =
          await _dsimRepository.set1p8GTGCCableLength(state.tgcCableLength);

      settingResult
          .add('${DataKey.tgcCableLength.name},$resultOfSetTGCCableLength');
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
