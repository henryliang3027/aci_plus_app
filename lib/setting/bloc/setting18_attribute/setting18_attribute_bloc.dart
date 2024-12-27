import 'dart:async';

import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/gps_repository.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_attribute_event.dart';
part 'setting18_attribute_state.dart';

class Setting18AttributeBloc
    extends Bloc<Setting18AttributeEvent, Setting18AttributeState> {
  Setting18AttributeBloc({
    required Amp18Repository amp18Repository,
    required GPSRepository gpsRepository,
  })  : _amp18Repository = amp18Repository,
        _gpsRepository = gpsRepository,
        super(const Setting18AttributeState()) {
    on<Initialized>(_onInitialized);
    on<LocationChanged>(_onLocationChanged);
    on<CoordinatesChanged>(_onCoordinatesChanged);
    on<GPSCoordinatesRequested>(_onGPSCoordinatesRequested);
    on<TechnicianIDChanged>(_onTechnicianIDChanged);
    on<InputSignalLevelChanged>(_onInputSignalLevelChanged);
    on<InputAttenuationChanged>(_onInputAttenuationChanged);
    on<InputEqualizerChanged>(_onInputEqualizerChanged);
    on<CascadePositionChanged>(_onCascadePositionChanged);
    on<DeviceNameChanged>(_onDeviceNameChanged);
    on<DeviceNoteChanged>(_onDeviceNoteChanged);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);

    add(const Initialized());

    _forwardCEQStateSubscription =
        _amp18Repository.forwardCEQStateStream.listen((bool isChanged) {
      add(const Initialized(useCache: false));
    });
  }

  final Amp18Repository _amp18Repository;
  final GPSRepository _gpsRepository;
  late final StreamSubscription _forwardCEQStateSubscription;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18AttributeState> emit,
  ) async {
    if (!event.useCache) {
      await _amp18Repository.updateSettingCharacteristics();
    }
    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    String location = characteristicDataCache[DataKey.location] ?? '';
    String coordinatesStr = characteristicDataCache[DataKey.coordinates] ?? '';
    CoordinateInput coordinates = CoordinateInput.dirty(coordinatesStr);
    String technicianID = characteristicDataCache[DataKey.technicianID] ?? '';
    String inputSignalLevel =
        characteristicDataCache[DataKey.inputSignalLevel] ?? '';
    String inputAttenuation =
        characteristicDataCache[DataKey.inputAttenuation] ?? '';
    String inputEqualizer =
        characteristicDataCache[DataKey.inputEqualizer] ?? '';
    String cascadePosition =
        characteristicDataCache[DataKey.cascadePosition] ?? '';
    String deviceName = characteristicDataCache[DataKey.deviceName] ?? '';
    String deviceNote = characteristicDataCache[DataKey.deviceNote] ?? '';

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      location: location,
      coordinates: coordinates,
      technicianID: technicianID,
      inputSignalLevel: inputSignalLevel,
      inputAttenuation: inputAttenuation,
      inputEqualizer: inputEqualizer,
      cascadePosition: cascadePosition,
      deviceName: deviceName,
      deviceNote: deviceNote,
      isInitialize: true,
      initialValues: characteristicDataCache,
      editMode: false,
      enableSubmission: false,
      tappedSet: const {},
      settingResult: const [],
      gpsCoordinateErrorMessage: '',
    ));
  }

  void _onLocationChanged(
    LocationChanged event,
    Emitter<Setting18AttributeState> emit,
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
      ),
    ));
  }

  void _onCoordinatesChanged(
    CoordinatesChanged event,
    Emitter<Setting18AttributeState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.coordinates);

    CoordinateInput coordinates = CoordinateInput.dirty(
      event.coordinates,
    );

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      coordinates: coordinates,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        coordinates: coordinates,
      ),
    ));
  }

  Future<void> _onGPSCoordinatesRequested(
    GPSCoordinatesRequested event,
    Emitter<Setting18AttributeState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.requestInProgress,
    ));

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.coordinates);

    try {
      String coordinatesStr = await _gpsRepository.getGPSCoordinates();

      CoordinateInput coordinates = CoordinateInput.dirty(
        coordinatesStr,
      );

      emit(state.copyWith(
        gpsStatus: FormStatus.requestSuccess,
        coordinates: coordinates,
        isInitialize: false,
        tappedSet: tappedSet,
        enableSubmission: _isEnabledSubmission(
          coordinates: coordinates,
        ),
      ));
    } catch (error) {
      emit(state.copyWith(
        gpsStatus: FormStatus.requestFailure,
        gpsCoordinateErrorMessage: error.toString(),
        isInitialize: false,
        tappedSet: tappedSet,
        enableSubmission: _isEnabledSubmission(
          coordinates: state.coordinates,
        ),
      ));
    }
  }

  void _onTechnicianIDChanged(
    TechnicianIDChanged event,
    Emitter<Setting18AttributeState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.technicianID);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      technicianID: event.technicianID,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        technicianID: event.technicianID,
      ),
    ));
  }

  void _onInputSignalLevelChanged(
    InputSignalLevelChanged event,
    Emitter<Setting18AttributeState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.inputSignalLevel);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      inputSignalLevel: event.inputSignalLevel,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        inputSignalLevel: event.inputSignalLevel,
      ),
    ));
  }

  void _onInputAttenuationChanged(
    InputAttenuationChanged event,
    Emitter<Setting18AttributeState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.inputAttenuation);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      inputAttenuation: event.inputAttenuation,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        inputAttenuation: event.inputAttenuation,
      ),
    ));
  }

  void _onInputEqualizerChanged(
    InputEqualizerChanged event,
    Emitter<Setting18AttributeState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.inputEqualizer);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      inputEqualizer: event.inputEqualizer,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        inputEqualizer: event.inputEqualizer,
      ),
    ));
  }

  void _onCascadePositionChanged(
    CascadePositionChanged event,
    Emitter<Setting18AttributeState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.cascadePosition);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      cascadePosition: event.cascadePosition,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        cascadePosition: event.cascadePosition,
      ),
    ));
  }

  void _onDeviceNameChanged(
    DeviceNameChanged event,
    Emitter<Setting18AttributeState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.deviceName);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      deviceName: event.deviceName,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        deviceName: event.deviceName,
      ),
    ));
  }

  void _onDeviceNoteChanged(
    DeviceNoteChanged event,
    Emitter<Setting18AttributeState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.deviceNote);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      deviceNote: event.deviceNote,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        deviceNote: event.deviceNote,
      ),
    ));
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18AttributeState> emit,
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
    Emitter<Setting18AttributeState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      gpsStatus: FormStatus.none,
      isInitialize: true,
      editMode: false,
      enableSubmission: false,
      tappedSet: {},
      location: state.initialValues[DataKey.location],
      coordinates:
          CoordinateInput.dirty(state.initialValues[DataKey.coordinates] ?? ''),
      technicianID: state.initialValues[DataKey.technicianID],
      inputSignalLevel: state.initialValues[DataKey.inputSignalLevel],
      inputAttenuation: state.initialValues[DataKey.inputAttenuation],
      inputEqualizer: state.initialValues[DataKey.inputEqualizer],
      cascadePosition: state.initialValues[DataKey.cascadePosition],
      deviceName: state.initialValues[DataKey.deviceName],
      deviceNote: state.initialValues[DataKey.deviceNote],
    ));
  }

  bool _isEnabledSubmission({
    String? location,
    CoordinateInput? coordinates,
    String? technicianID,
    String? inputSignalLevel,
    String? inputAttenuation,
    String? inputEqualizer,
    String? cascadePosition,
    String? deviceName,
    String? deviceNote,
  }) {
    location ??= state.location;
    coordinates ??= state.coordinates;
    technicianID ??= state.technicianID;
    inputSignalLevel ??= state.inputSignalLevel;
    inputAttenuation ??= state.inputAttenuation;
    inputEqualizer ??= state.inputEqualizer;
    cascadePosition ??= state.cascadePosition;
    deviceName ??= state.deviceName;
    deviceNote ??= state.deviceNote;

    if (coordinates.isNotValid) {
      return false;
    } else {
      if (location != state.initialValues[DataKey.location] ||
          coordinates.value != state.initialValues[DataKey.coordinates] ||
          technicianID != state.initialValues[DataKey.technicianID] ||
          inputSignalLevel != state.initialValues[DataKey.inputSignalLevel] ||
          inputAttenuation != state.initialValues[DataKey.inputAttenuation] ||
          inputEqualizer != state.initialValues[DataKey.inputEqualizer] ||
          cascadePosition != state.initialValues[DataKey.cascadePosition] ||
          deviceName != state.initialValues[DataKey.deviceName] ||
          deviceNote != state.initialValues[DataKey.deviceNote]) {
        return true;
      } else {
        return false;
      }
    }
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18AttributeState> emit,
  ) async {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionInProgress,
      gpsStatus: FormStatus.none,
      isInitialize: false,
    ));

    List<String> settingResult = [];

    if (state.location != state.initialValues[DataKey.location]) {
      bool resultOfSetLocation =
          await _amp18Repository.set1p8GLocation(state.location);

      settingResult.add('${DataKey.location.name},$resultOfSetLocation');
    }

    if (state.coordinates.value != state.initialValues[DataKey.coordinates]) {
      bool resultOfSetCoordinates =
          await _amp18Repository.set1p8GCoordinates(state.coordinates.value);

      settingResult.add('${DataKey.coordinates.name},$resultOfSetCoordinates');
    }

    List<DataKey> userAttributes = [];

    int firmwareVersion = convertFirmwareVersionStringToInt(
        state.initialValues[DataKey.firmwareVersion] ?? '0');

    if (firmwareVersion >= 148) {
      if (state.technicianID != state.initialValues[DataKey.technicianID]) {
        userAttributes.add(DataKey.technicianID);
      }

      if (state.inputSignalLevel !=
          state.initialValues[DataKey.inputSignalLevel]) {
        userAttributes.add(DataKey.inputSignalLevel);
      }

      if (state.inputAttenuation !=
          state.initialValues[DataKey.inputAttenuation]) {
        userAttributes.add(DataKey.inputAttenuation);
      }

      if (state.inputEqualizer != state.initialValues[DataKey.inputEqualizer]) {
        userAttributes.add(DataKey.inputEqualizer);
      }

      if (state.cascadePosition !=
          state.initialValues[DataKey.cascadePosition]) {
        userAttributes.add(DataKey.cascadePosition);
      }
      if (state.deviceName != state.initialValues[DataKey.deviceName]) {
        userAttributes.add(DataKey.deviceName);
      }
      if (state.deviceNote != state.initialValues[DataKey.deviceNote]) {
        userAttributes.add(DataKey.deviceNote);
      }

      if (userAttributes.isNotEmpty) {
        bool resultOfSetUserAttribute =
            await _amp18Repository.set1p8GUserAttribute(
          technicianID: state.technicianID,
          inputSignalLevel: state.inputSignalLevel,
          inputAttenuation: state.inputAttenuation,
          inputEqualizer: state.inputEqualizer,
          cascadePosition: state.cascadePosition,
          deviceName: state.deviceName,
          deviceNote: state.deviceNote,
        );

        for (DataKey dataKey in userAttributes) {
          settingResult.add('${dataKey.name},$resultOfSetUserAttribute');
        }
      }
    }

    // 等待 device 完成更新後在讀取值
    await Future.delayed(const Duration(milliseconds: 1000));

    await _amp18Repository.updateCharacteristics();

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
      tappedSet: {},
      enableSubmission: false,
      editMode: false,
    ));
  }

  @override
  Future<void> close() {
    _forwardCEQStateSubscription.cancel();
    return super.close();
  }
}
