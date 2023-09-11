import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_configure_event.dart';
part 'setting18_configure_state.dart';

class Setting18ConfigureBloc
    extends Bloc<Setting18ConfigureEvent, Setting18ConfigureState> {
  Setting18ConfigureBloc({
    required DsimRepository dsimRepository,
  })  : _dsimRepository = dsimRepository,
        super(const Setting18ConfigureState()) {
    on<Initialized>(_onInitialized);
    on<LocationChanged>(_onLocationChanged);
    on<CoordinatesChanged>(_onCoordinatesChanged);
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
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);
  }

  final DsimRepository _dsimRepository;

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
      fwdAGCMode: event.fwdAGCMode,
      autoLevelControl: event.autoLevelControl,
      logInterval: event.logInterval,
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
      ],
    ));
  }

  void _onLocationChanged(
    LocationChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
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
      ),
    ));
  }

  void _onCoordinatesChanged(
    CoordinatesChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
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
      ),
    ));
  }

  void _onSplitOptionChanged(
    SplitOptionChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
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
      ),
    ));
  }

  void _onFirstChannelLoadingFrequencyChanged(
    FirstChannelLoadingFrequencyChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
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
      ),
    ));
  }

  void _onFirstChannelLoadingLevelChanged(
    FirstChannelLoadingLevelChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
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
      ),
    ));
  }

  void _onLastChannelLoadingFrequencyChanged(
    LastChannelLoadingFrequencyChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
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
      ),
    ));
  }

  void _onLastChannelLoadingLevelChanged(
    LastChannelLoadingLevelChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
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
      ),
    ));
  }

  void _onPilotFrequencyModeChanged(
    PilotFrequencyModeChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
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
      ),
    ));
  }

  void _onPilotFrequency1Changed(
    PilotFrequency1Changed event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
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
      ),
    ));
  }

  void _onPilotFrequency2Changed(
    PilotFrequency2Changed event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
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
      ),
    ));
  }

  void _onFwdAGCModeChanged(
    FwdAGCModeChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
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
      ),
    ));
  }

  void _onAutoLevelControlChanged(
    AutoLevelControlChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
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
      ),
    ));
  }

  void _onLogIntervalChanged(
    LogIntervalChanged event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
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
      ),
    ));
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18ConfigureState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
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
        logInterval != state.initialValues[12]) {
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
      isInitialize: false,
      submissionStatus: SubmissionStatus.submissionInProgress,
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

    if (state.splitOption != state.initialValues[1]) {
      bool resultOfSetSplitOption =
          await _dsimRepository.set1p8GCoordinates(state.splitOption);

      settingResult.add('${DataKey.splitOption.name},$resultOfSetSplitOption');
    }

    if (state.logInterval != state.initialValues[12]) {
      bool resultOfSetLogInterval =
          await _dsimRepository.set1p8GLogInterval(state.logInterval);

      settingResult.add('${DataKey.logInterval.name},$resultOfSetLogInterval');
    }

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
      enableSubmission: false,
      editMode: false,
    ));

    await _dsimRepository.updateCharacteristics();
  }
}
