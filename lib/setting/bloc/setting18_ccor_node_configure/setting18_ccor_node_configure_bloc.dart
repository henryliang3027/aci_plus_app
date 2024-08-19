import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';

import 'package:aci_plus_app/repositories/gps_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_ccor_node_configure_event.dart';
part 'setting18_ccor_node_configure_state.dart';

class Setting18CCorNodeConfigureBloc extends Bloc<
    Setting18CCorNodeConfigureEvent, Setting18CCorNodeConfigureState> {
  Setting18CCorNodeConfigureBloc({
    required Amp18CCorNodeRepository amp18CCorNodeRepository,
    required GPSRepository gpsRepository,
  })  : _amp18CCorNodeRepository = amp18CCorNodeRepository,
        _gpsRepository = gpsRepository,
        super(const Setting18CCorNodeConfigureState()) {
    on<Initialized>(_onInitialized);
    on<LocationChanged>(_onLocationChanged);
    on<CoordinatesChanged>(_onCoordinatesChanged);
    on<GPSCoordinatesRequested>(_onGPSCoordinatesRequested);
    on<ForwardModeChanged>(_onForwardModeChanged);
    on<ForwardConfigChanged>(_onForwardConfigChanged);
    on<SplitOptionChanged>(_onSplitOptionChanged);
    on<LogIntervalChanged>(_onLogIntervalChanged);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);

    add(const Initialized());
  }

  final Amp18CCorNodeRepository _amp18CCorNodeRepository;
  final GPSRepository _gpsRepository;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18CCorNodeConfigureState> emit,
  ) async {
    Map<DataKey, String> characteristicDataCache =
        _amp18CCorNodeRepository.characteristicDataCache;

    String location = characteristicDataCache[DataKey.location] ?? '';
    String coordinates = characteristicDataCache[DataKey.coordinates] ?? '';
    String forwardMode = characteristicDataCache[DataKey.forwardMode] ?? '';
    String forwardConfig = characteristicDataCache[DataKey.forwardConfig] ?? '';
    String splitOption = characteristicDataCache[DataKey.splitOption] ?? '';
    String logInterval = characteristicDataCache[DataKey.logInterval] ?? '';

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      location: location,
      coordinates: coordinates,
      forwardMode: forwardMode,
      forwardConfig: forwardConfig,
      splitOption: splitOption,
      logInterval: logInterval,
      isInitialize: true,
      initialValues: characteristicDataCache,
      editMode: false,
      enableSubmission: false,
      settingResult: const [],
      tappedSet: const {},
      gpsCoordinateErrorMessage: '',
    ));
  }

  void _onLocationChanged(
    LocationChanged event,
    Emitter<Setting18CCorNodeConfigureState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.location);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      location: event.location,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        location: event.location,
        coordinates: state.coordinates,
        forwardMode: state.forwardMode,
        forwardConfig: state.forwardConfig,
        splitOption: state.splitOption,
        logInterval: state.logInterval,
      ),
    ));
  }

  void _onCoordinatesChanged(
    CoordinatesChanged event,
    Emitter<Setting18CCorNodeConfigureState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.coordinates);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      coordinates: event.coordinates,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: event.coordinates,
        forwardMode: state.forwardMode,
        forwardConfig: state.forwardConfig,
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
      isInitialize: false,
    ));

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.coordinates);

    try {
      String coordinates = await _gpsRepository.getGPSCoordinates();
      emit(state.copyWith(
        gpsStatus: FormStatus.requestSuccess,
        coordinates: coordinates,
        tappedSet: tappedSet,
        enableSubmission: _isEnabledSubmission(
          location: state.location,
          coordinates: coordinates,
          forwardMode: state.forwardMode,
          forwardConfig: state.forwardConfig,
          splitOption: state.splitOption,
          logInterval: state.logInterval,
        ),
      ));
    } catch (error) {
      emit(state.copyWith(
        gpsStatus: FormStatus.requestFailure,
        gpsCoordinateErrorMessage: error.toString(),
        tappedSet: tappedSet,
        enableSubmission: _isEnabledSubmission(
          location: state.location,
          coordinates: state.coordinates,
          forwardMode: state.forwardMode,
          forwardConfig: state.forwardConfig,
          splitOption: state.splitOption,
          logInterval: state.logInterval,
        ),
      ));
    }
  }

  void _onForwardModeChanged(
    ForwardModeChanged event,
    Emitter<Setting18CCorNodeConfigureState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.forwardMode);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      forwardMode: event.forwardMode,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: state.coordinates,
        forwardMode: event.forwardMode,
        forwardConfig: state.forwardConfig,
        splitOption: state.splitOption,
        logInterval: state.logInterval,
      ),
    ));
  }

  void _onForwardConfigChanged(
    ForwardConfigChanged event,
    Emitter<Setting18CCorNodeConfigureState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.forwardConfig);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      forwardConfig: event.forwardConfig,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: state.coordinates,
        forwardMode: state.forwardMode,
        forwardConfig: event.forwardConfig,
        splitOption: state.splitOption,
        logInterval: state.logInterval,
      ),
    ));
  }

  void _onSplitOptionChanged(
    SplitOptionChanged event,
    Emitter<Setting18CCorNodeConfigureState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.splitOption);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      splitOption: event.splitOption,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: state.coordinates,
        forwardMode: state.forwardMode,
        forwardConfig: state.forwardConfig,
        splitOption: event.splitOption,
        logInterval: state.logInterval,
      ),
    ));
  }

  void _onLogIntervalChanged(
    LogIntervalChanged event,
    Emitter<Setting18CCorNodeConfigureState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.logInterval);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      logInterval: event.logInterval,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        location: state.location,
        coordinates: state.coordinates,
        forwardMode: state.forwardMode,
        forwardConfig: state.forwardConfig,
        splitOption: state.splitOption,
        logInterval: event.logInterval,
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
      tappedSet: const {},
      location: state.initialValues[DataKey.location],
      coordinates: state.initialValues[DataKey.coordinates],
      forwardMode: state.initialValues[DataKey.forwardMode],
      forwardConfig: state.initialValues[DataKey.forwardConfig],
      splitOption: state.initialValues[DataKey.splitOption],
      logInterval: state.initialValues[DataKey.logInterval],
    ));
  }

  bool _isEnabledSubmission({
    required String location,
    required String coordinates,
    required String forwardMode,
    required String forwardConfig,
    required String splitOption,
    required String logInterval,
  }) {
    if (location != state.initialValues[DataKey.location] ||
        coordinates != state.initialValues[DataKey.coordinates] ||
        forwardMode != state.initialValues[DataKey.forwardMode] ||
        forwardConfig != state.initialValues[DataKey.forwardConfig] ||
        splitOption != state.initialValues[DataKey.splitOption] ||
        logInterval != state.initialValues[DataKey.logInterval]) {
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

    if (state.location != state.initialValues[DataKey.location]) {
      bool resultOfSetLocation = await _amp18CCorNodeRepository
          .set1p8GCCorNodeLocation(state.location);

      settingResult.add('${DataKey.location.name},$resultOfSetLocation');
    }

    if (state.coordinates != state.initialValues[DataKey.coordinates]) {
      bool resultOfSetCoordinates = await _amp18CCorNodeRepository
          .set1p8GCCorNodeCoordinates(state.coordinates);

      settingResult.add('${DataKey.coordinates.name},$resultOfSetCoordinates');
    }

    if (state.forwardMode != state.initialValues[DataKey.forwardMode]) {
      bool resultOfSetForwardMode = await _amp18CCorNodeRepository
          .set1p8GCCorNodeForwardMode(state.forwardMode);

      settingResult.add('${DataKey.forwardMode.name},$resultOfSetForwardMode');
    }

    if (state.forwardConfig != state.initialValues[DataKey.forwardConfig]) {
      bool resultOfSetForwardConfig = await _amp18CCorNodeRepository
          .set1p8GCCorNodeForwardConfig(state.forwardConfig);

      settingResult
          .add('${DataKey.forwardConfig.name},$resultOfSetForwardConfig');
    }

    if (state.splitOption != state.initialValues[DataKey.splitOption]) {
      bool resultOfSetSplitOption = await _amp18CCorNodeRepository
          .set1p8GCCorNodeSplitOption(state.splitOption);

      settingResult.add('${DataKey.splitOption.name},$resultOfSetSplitOption');
    }

    if (state.logInterval != state.initialValues[DataKey.logInterval]) {
      bool resultOfSetLogInterval = await _amp18CCorNodeRepository
          .set1p8GCCorNodeLogInterval(state.logInterval);

      settingResult.add('${DataKey.logInterval.name},$resultOfSetLogInterval');
    }

    // 等待 device 完成更新後在讀取值
    await Future.delayed(const Duration(milliseconds: 1000));

    await _amp18CCorNodeRepository.update1p8GCCorNodeCharacteristics();

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
      tappedSet: const {},
      enableSubmission: false,
      editMode: false,
    ));
  }
}
