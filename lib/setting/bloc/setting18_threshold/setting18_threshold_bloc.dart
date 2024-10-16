import 'dart:async';

import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:aci_plus_app/setting/model/custom_input.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'setting18_threshold_event.dart';
part 'setting18_threshold_state.dart';

class Setting18ThresholdBloc
    extends Bloc<Setting18ThresholdEvent, Setting18ThresholdState> {
  Setting18ThresholdBloc({
    required Amp18Repository amp18Repository,
    required UnitRepository unitRepository,
  })  : _amp18Repository = amp18Repository,
        _unitRepository = unitRepository,
        super(const Setting18ThresholdState()) {
    on<Initialized>(_onInitialized);
    on<TemperatureAlarmChanged>(_onTemperatureAlarmChanged);
    on<MinTemperatureChanged>(_onMinTemperatureChanged);
    on<MaxTemperatureChanged>(_onMaxTemperatureChanged);
    on<VoltageAlarmChanged>(_onVoltageAlarmChanged);
    on<MinVoltageChanged>(_onMinVoltageChanged);
    on<MaxVoltageChanged>(_onMaxVoltageChanged);
    on<VoltageRippleAlarmChanged>(_onVoltageRippleAlarmChanged);
    on<MinVoltageRippleChanged>(_onMinVoltageRippleChanged);
    on<MaxVoltageRippleChanged>(_onMaxVoltageRippleChanged);
    on<RFOutputPowerAlarmChanged>(_onRFOutputPowerAlarmChanged);
    on<MinRFOutputPowerChanged>(_onMinRFOutputPowerChanged);
    on<MaxRFOutputPowerChanged>(_onMaxRFOutputPowerChanged);
    on<SplitOptionAlarmChanged>(_onSplitOptionAlarmChanged);
    // on<PilotFrequency1AlarmChanged>(_onPilotFrequency1AlarmChanged);
    // on<PilotFrequency2AlarmChanged>(_onPilotFrequency2AlarmChanged);
    on<StartFrequencyOutputLevelAlarmStateChanged>(
        _onStartFrequencyOutputLevelAlarmStateChanged);
    on<StopFrequencyOutputLevelAlarmStateChanged>(
        _onStopFrequencyOutputLevelAlarmStateChanged);
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
  final UnitRepository _unitRepository;
  late final StreamSubscription _forwardCEQStateSubscription;

  String getMinTemperature({
    required String minTemperatureC,
    required String minTemperatureF,
  }) {
    String minTemperature = '';
    if (_unitRepository.temperatureUnit == TemperatureUnit.celsius) {
      minTemperature = minTemperatureC;
    } else {
      minTemperature = minTemperatureF;
    }

    return minTemperature;
  }

  String getMaxTemperature({
    required String maxTemperatureC,
    required String maxTemperatureF,
  }) {
    String maxTemperature = '';
    if (_unitRepository.temperatureUnit == TemperatureUnit.celsius) {
      maxTemperature = maxTemperatureC;
    } else {
      maxTemperature = maxTemperatureF;
    }

    return maxTemperature;
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

  bool _stringNumberToBool(String value) {
    return value == '1' ? false : true;
  }

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18ThresholdState> emit,
  ) async {
    if (!event.useCache) {
      await _amp18Repository.updateSettingCharacteristics();
    }

    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    String minTemperatureC =
        characteristicDataCache[DataKey.minTemperatureC] ?? '';
    String maxTemperatureC =
        characteristicDataCache[DataKey.maxTemperatureC] ?? '';
    String minTemperatureF =
        characteristicDataCache[DataKey.minTemperatureF] ?? '';
    String maxTemperatureF =
        characteristicDataCache[DataKey.maxTemperatureF] ?? '';
    String minVoltage = characteristicDataCache[DataKey.minVoltage] ?? '';
    String maxVoltage = characteristicDataCache[DataKey.maxVoltage] ?? '';
    String minVoltageRipple =
        characteristicDataCache[DataKey.minVoltageRipple] ?? '';
    String maxVoltageRipple =
        characteristicDataCache[DataKey.maxVoltageRipple] ?? '';
    String minRFOutputPower =
        characteristicDataCache[DataKey.minRFOutputPower] ?? '';
    String maxRFOutputPower =
        characteristicDataCache[DataKey.maxRFOutputPower] ?? '';

    String strTemperatureAlarmState =
        characteristicDataCache[DataKey.temperatureAlarmState] ?? '';

    String strVoltageAlarmState =
        characteristicDataCache[DataKey.voltageAlarmState] ?? '';

    String strVoltageRippleAlarmState =
        characteristicDataCache[DataKey.voltageRippleAlarmState] ?? '';

    String strRFOutputPowerAlarmState =
        characteristicDataCache[DataKey.rfOutputPowerAlarmState] ?? '';

    String strSplitOptionAlarmState =
        characteristicDataCache[DataKey.splitOptionAlarmState] ?? '';

    // String strPilotFrequency1AlarmState =
    //     characteristicDataCache[DataKey.pilotFrequency1AlarmState] ?? '';

    // String strPilotFrequency2AlarmState =
    //     characteristicDataCache[DataKey.pilotFrequency2AlarmState] ?? '';

    String strStartFrequencyOutputLevelAlarmState =
        characteristicDataCache[DataKey.rfOutputPilotLowFrequencyAlarmState] ??
            '';

    String strStopFrequencyOutputLevelAlarmState =
        characteristicDataCache[DataKey.rfOutputPilotHighFrequencyAlarmState] ??
            '';

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      temperatureAlarmState: _stringNumberToBool(strTemperatureAlarmState),
      minTemperature: FloatPointInput.dirty(
        getMinTemperature(
          minTemperatureC: minTemperatureC,
          minTemperatureF: minTemperatureF,
        ),
      ),
      maxTemperature: FloatPointInput.dirty(
        getMaxTemperature(
          maxTemperatureC: maxTemperatureC,
          maxTemperatureF: maxTemperatureF,
        ),
      ),
      temperatureUnit: _unitRepository.temperatureUnit,
      voltageAlarmState: _stringNumberToBool(strVoltageAlarmState),
      minVoltage: FloatPointInput.dirty(minVoltage),
      maxVoltage: FloatPointInput.dirty(maxVoltage),
      voltageRippleAlarmState: _stringNumberToBool(strVoltageRippleAlarmState),
      minVoltageRipple: IntegerInput.dirty(minVoltageRipple),
      maxVoltageRipple: IntegerInput.dirty(maxVoltageRipple),
      rfOutputPowerAlarmState: _stringNumberToBool(strRFOutputPowerAlarmState),
      minRFOutputPower: FloatPointInput.dirty(minRFOutputPower),
      maxRFOutputPower: FloatPointInput.dirty(maxRFOutputPower),
      splitOptionAlarmState: _stringNumberToBool(strSplitOptionAlarmState),
      // pilotFrequency1AlarmState:
      //     _stringNumberToBool(strPilotFrequency1AlarmState),
      // pilotFrequency2AlarmState:
      //     _stringNumberToBool(strPilotFrequency2AlarmState),
      startFrequencyOutputLevelAlarmState:
          _stringNumberToBool(strStartFrequencyOutputLevelAlarmState),
      stopFrequencyOutputLevelAlarmState:
          _stringNumberToBool(strStopFrequencyOutputLevelAlarmState),
      isInitialize: true,
      initialValues: characteristicDataCache,
      editMode: false,
      enableSubmission: false,
      tappedSet: const {},
      settingResult: const [],
    ));
  }

  void _onTemperatureAlarmChanged(
    TemperatureAlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.temperatureAlarmState);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      temperatureAlarmState: event.temperatureAlarmState,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: event.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        voltageRippleAlarmState: state.voltageRippleAlarmState,
        minVoltageRipple: state.minVoltageRipple,
        maxVoltageRipple: state.maxVoltageRipple,
        rfOutputPowerAlarmState: state.rfOutputPowerAlarmState,
        minRFOutputPower: state.minRFOutputPower,
        maxRFOutputPower: state.maxRFOutputPower,
        splitOptionAlarmState: state.splitOptionAlarmState,
        // pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        // pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        startFrequencyOutputLevelAlarmState:
            state.startFrequencyOutputLevelAlarmState,
        stopFrequencyOutputLevelAlarmState:
            state.stopFrequencyOutputLevelAlarmState,
      ),
    ));
  }

  void _onMinTemperatureChanged(
    MinTemperatureChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    FloatPointInput minTemperature =
        FloatPointInput.dirty(event.minTemperature);

    // 用 DataKey.minTemperatureC 來代表 ºC 或 ºF 的單位下溫度 card 被 tap
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.minTemperatureC);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      minTemperature: minTemperature,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        voltageRippleAlarmState: state.voltageRippleAlarmState,
        minVoltageRipple: state.minVoltageRipple,
        maxVoltageRipple: state.maxVoltageRipple,
        rfOutputPowerAlarmState: state.rfOutputPowerAlarmState,
        minRFOutputPower: state.minRFOutputPower,
        maxRFOutputPower: state.maxRFOutputPower,
        splitOptionAlarmState: state.splitOptionAlarmState,
        // pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        // pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        startFrequencyOutputLevelAlarmState:
            state.startFrequencyOutputLevelAlarmState,
        stopFrequencyOutputLevelAlarmState:
            state.stopFrequencyOutputLevelAlarmState,
      ),
    ));
  }

  void _onMaxTemperatureChanged(
    MaxTemperatureChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    FloatPointInput maxTemperature =
        FloatPointInput.dirty(event.maxTemperature);

    // 用 DataKey.maxTemperatureC 來代表 ºC 或 ºF 的單位下溫度 card 被 tap
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.maxTemperatureC);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      maxTemperature: maxTemperature,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        voltageRippleAlarmState: state.voltageRippleAlarmState,
        minVoltageRipple: state.minVoltageRipple,
        maxVoltageRipple: state.maxVoltageRipple,
        rfOutputPowerAlarmState: state.rfOutputPowerAlarmState,
        minRFOutputPower: state.minRFOutputPower,
        maxRFOutputPower: state.maxRFOutputPower,
        splitOptionAlarmState: state.splitOptionAlarmState,
        // pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        // pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        startFrequencyOutputLevelAlarmState:
            state.startFrequencyOutputLevelAlarmState,
        stopFrequencyOutputLevelAlarmState:
            state.stopFrequencyOutputLevelAlarmState,
      ),
    ));
  }

  void _onVoltageAlarmChanged(
    VoltageAlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.voltageAlarmState);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      voltageAlarmState: event.voltageAlarmState,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: event.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        voltageRippleAlarmState: state.voltageRippleAlarmState,
        minVoltageRipple: state.minVoltageRipple,
        maxVoltageRipple: state.maxVoltageRipple,
        rfOutputPowerAlarmState: state.rfOutputPowerAlarmState,
        minRFOutputPower: state.minRFOutputPower,
        maxRFOutputPower: state.maxRFOutputPower,
        splitOptionAlarmState: state.splitOptionAlarmState,
        // pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        // pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        startFrequencyOutputLevelAlarmState:
            state.startFrequencyOutputLevelAlarmState,
        stopFrequencyOutputLevelAlarmState:
            state.stopFrequencyOutputLevelAlarmState,
      ),
    ));
  }

  void _onMinVoltageChanged(
    MinVoltageChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    FloatPointInput minVoltage = FloatPointInput.dirty(event.minVoltage);

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.minVoltage);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      minVoltage: minVoltage,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: minVoltage,
        maxVoltage: state.maxVoltage,
        voltageRippleAlarmState: state.voltageRippleAlarmState,
        minVoltageRipple: state.minVoltageRipple,
        maxVoltageRipple: state.maxVoltageRipple,
        rfOutputPowerAlarmState: state.rfOutputPowerAlarmState,
        minRFOutputPower: state.minRFOutputPower,
        maxRFOutputPower: state.maxRFOutputPower,
        splitOptionAlarmState: state.splitOptionAlarmState,
        // pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        // pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        startFrequencyOutputLevelAlarmState:
            state.startFrequencyOutputLevelAlarmState,
        stopFrequencyOutputLevelAlarmState:
            state.stopFrequencyOutputLevelAlarmState,
      ),
    ));
  }

  void _onMaxVoltageChanged(
    MaxVoltageChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    FloatPointInput maxVoltage = FloatPointInput.dirty(event.maxVoltage);

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.maxVoltage);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      maxVoltage: maxVoltage,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: maxVoltage,
        voltageRippleAlarmState: state.voltageRippleAlarmState,
        minVoltageRipple: state.minVoltageRipple,
        maxVoltageRipple: state.maxVoltageRipple,
        rfOutputPowerAlarmState: state.rfOutputPowerAlarmState,
        minRFOutputPower: state.minRFOutputPower,
        maxRFOutputPower: state.maxRFOutputPower,
        splitOptionAlarmState: state.splitOptionAlarmState,
        // pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        // pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        startFrequencyOutputLevelAlarmState:
            state.startFrequencyOutputLevelAlarmState,
        stopFrequencyOutputLevelAlarmState:
            state.stopFrequencyOutputLevelAlarmState,
      ),
    ));
  }

  void _onVoltageRippleAlarmChanged(
    VoltageRippleAlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.voltageRippleAlarmState);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      voltageRippleAlarmState: event.voltageRippleAlarmState,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        voltageRippleAlarmState: event.voltageRippleAlarmState,
        minVoltageRipple: state.minVoltageRipple,
        maxVoltageRipple: state.maxVoltageRipple,
        rfOutputPowerAlarmState: state.rfOutputPowerAlarmState,
        minRFOutputPower: state.minRFOutputPower,
        maxRFOutputPower: state.maxRFOutputPower,
        splitOptionAlarmState: state.splitOptionAlarmState,
        // pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        // pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        startFrequencyOutputLevelAlarmState:
            state.startFrequencyOutputLevelAlarmState,
        stopFrequencyOutputLevelAlarmState:
            state.stopFrequencyOutputLevelAlarmState,
      ),
    ));
  }

  void _onMinVoltageRippleChanged(
    MinVoltageRippleChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    IntegerInput minVoltageRipple = IntegerInput.dirty(event.minVoltageRipple);

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.minVoltageRipple);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      minVoltageRipple: minVoltageRipple,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        voltageRippleAlarmState: state.voltageRippleAlarmState,
        minVoltageRipple: minVoltageRipple,
        maxVoltageRipple: state.maxVoltageRipple,
        rfOutputPowerAlarmState: state.rfOutputPowerAlarmState,
        minRFOutputPower: state.minRFOutputPower,
        maxRFOutputPower: state.maxRFOutputPower,
        splitOptionAlarmState: state.splitOptionAlarmState,
        // pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        // pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        startFrequencyOutputLevelAlarmState:
            state.startFrequencyOutputLevelAlarmState,
        stopFrequencyOutputLevelAlarmState:
            state.stopFrequencyOutputLevelAlarmState,
      ),
    ));
  }

  void _onMaxVoltageRippleChanged(
    MaxVoltageRippleChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    IntegerInput maxVoltageRipple = IntegerInput.dirty(event.maxVoltageRipple);

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.maxVoltageRipple);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      maxVoltageRipple: maxVoltageRipple,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        voltageRippleAlarmState: state.voltageRippleAlarmState,
        minVoltageRipple: state.minVoltageRipple,
        maxVoltageRipple: maxVoltageRipple,
        rfOutputPowerAlarmState: state.rfOutputPowerAlarmState,
        minRFOutputPower: state.minRFOutputPower,
        maxRFOutputPower: state.maxRFOutputPower,
        splitOptionAlarmState: state.splitOptionAlarmState,
        // pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        // pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        startFrequencyOutputLevelAlarmState:
            state.startFrequencyOutputLevelAlarmState,
        stopFrequencyOutputLevelAlarmState:
            state.stopFrequencyOutputLevelAlarmState,
      ),
    ));
  }

  void _onRFOutputPowerAlarmChanged(
    RFOutputPowerAlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.rfOutputPowerAlarmState);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rfOutputPowerAlarmState: event.rfOutputPowerAlarmState,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        voltageRippleAlarmState: state.voltageRippleAlarmState,
        minVoltageRipple: state.minVoltageRipple,
        maxVoltageRipple: state.maxVoltageRipple,
        rfOutputPowerAlarmState: event.rfOutputPowerAlarmState,
        minRFOutputPower: state.minRFOutputPower,
        maxRFOutputPower: state.maxRFOutputPower,
        splitOptionAlarmState: state.splitOptionAlarmState,
        // pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        // pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        startFrequencyOutputLevelAlarmState:
            state.startFrequencyOutputLevelAlarmState,
        stopFrequencyOutputLevelAlarmState:
            state.stopFrequencyOutputLevelAlarmState,
      ),
    ));
  }

  void _onMinRFOutputPowerChanged(
    MinRFOutputPowerChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    FloatPointInput minRFOutputPower =
        FloatPointInput.dirty(event.minRFOutputPower);

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.minRFOutputPower);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      minRFOutputPower: minRFOutputPower,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        voltageRippleAlarmState: state.voltageRippleAlarmState,
        minVoltageRipple: state.minVoltageRipple,
        maxVoltageRipple: state.maxVoltageRipple,
        rfOutputPowerAlarmState: state.rfOutputPowerAlarmState,
        minRFOutputPower: minRFOutputPower,
        maxRFOutputPower: state.maxRFOutputPower,
        splitOptionAlarmState: state.splitOptionAlarmState,
        // pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        // pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        startFrequencyOutputLevelAlarmState:
            state.startFrequencyOutputLevelAlarmState,
        stopFrequencyOutputLevelAlarmState:
            state.stopFrequencyOutputLevelAlarmState,
      ),
    ));
  }

  void _onMaxRFOutputPowerChanged(
    MaxRFOutputPowerChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    FloatPointInput maxRFOutputPower =
        FloatPointInput.dirty(event.maxRFOutputPower);

    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.maxRFOutputPower);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      maxRFOutputPower: maxRFOutputPower,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        voltageRippleAlarmState: state.voltageRippleAlarmState,
        minVoltageRipple: state.minVoltageRipple,
        maxVoltageRipple: state.maxVoltageRipple,
        rfOutputPowerAlarmState: state.rfOutputPowerAlarmState,
        minRFOutputPower: state.minRFOutputPower,
        maxRFOutputPower: maxRFOutputPower,
        splitOptionAlarmState: state.splitOptionAlarmState,
        // pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        // pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        startFrequencyOutputLevelAlarmState:
            state.startFrequencyOutputLevelAlarmState,
        stopFrequencyOutputLevelAlarmState:
            state.stopFrequencyOutputLevelAlarmState,
      ),
    ));
  }

  void _onSplitOptionAlarmChanged(
    SplitOptionAlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.splitOptionAlarmState);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      splitOptionAlarmState: event.splitOptionAlarmState,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        voltageRippleAlarmState: state.voltageRippleAlarmState,
        minVoltageRipple: state.minVoltageRipple,
        maxVoltageRipple: state.maxVoltageRipple,
        rfOutputPowerAlarmState: state.rfOutputPowerAlarmState,
        minRFOutputPower: state.minRFOutputPower,
        maxRFOutputPower: state.maxRFOutputPower,
        splitOptionAlarmState: event.splitOptionAlarmState,
        // pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        // pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        startFrequencyOutputLevelAlarmState:
            state.startFrequencyOutputLevelAlarmState,
        stopFrequencyOutputLevelAlarmState:
            state.stopFrequencyOutputLevelAlarmState,
      ),
    ));
  }

  // void _onPilotFrequency1AlarmChanged(
  //   PilotFrequency1AlarmChanged event,
  //   Emitter<Setting18ThresholdState> emit,
  // ) {
  //   emit(state.copyWith(
  //     submissionStatus: SubmissionStatus.none,
  //     pilotFrequency1AlarmState: event.pilotFrequency1AlarmState,
  //     isInitialize: false,
  //     enableSubmission: _isEnabledSubmission(
  //       temperatureAlarmState: state.temperatureAlarmState,
  //       minTemperature: state.minTemperature,
  //       maxTemperature: state.maxTemperature,
  //       voltageAlarmState: state.voltageAlarmState,
  //       minVoltage: state.minVoltage,
  //       maxVoltage: state.maxVoltage,
  //       voltageRippleAlarmState: state.voltageRippleAlarmState,
  //       minVoltageRipple: state.minVoltageRipple,
  //       maxVoltageRipple: state.maxVoltageRipple,
  //       rfOutputPowerAlarmState: state.rfOutputPowerAlarmState,
  //       minRFOutputPower: state.minRFOutputPower,
  //       maxRFOutputPower: state.maxRFOutputPower,
  //       splitOptionAlarmState: state.splitOptionAlarmState,
  //       // pilotFrequency1AlarmState: event.pilotFrequency1AlarmState,
  //       // pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
  //       startFrequencyOutputLevelAlarmState:
  //           state.startFrequencyOutputLevelAlarmState,
  //       stopFrequencyOutputLevelAlarmState:
  //           state.stopFrequencyOutputLevelAlarmState,
  //     ),
  //   ));
  // }

  // void _onPilotFrequency2AlarmChanged(
  //   PilotFrequency2AlarmChanged event,
  //   Emitter<Setting18ThresholdState> emit,
  // ) {
  //   emit(state.copyWith(
  //     submissionStatus: SubmissionStatus.none,
  //     pilotFrequency2AlarmState: event.pilotFrequency2AlarmState,
  //     isInitialize: false,
  //     enableSubmission: _isEnabledSubmission(
  //       temperatureAlarmState: state.temperatureAlarmState,
  //       minTemperature: state.minTemperature,
  //       maxTemperature: state.maxTemperature,
  //       voltageAlarmState: state.voltageAlarmState,
  //       minVoltage: state.minVoltage,
  //       maxVoltage: state.maxVoltage,
  //       voltageRippleAlarmState: state.voltageRippleAlarmState,
  //       minVoltageRipple: state.minVoltageRipple,
  //       maxVoltageRipple: state.maxVoltageRipple,
  //       rfOutputPowerAlarmState: state.rfOutputPowerAlarmState,
  //       minRFOutputPower: state.minRFOutputPower,
  //       maxRFOutputPower: state.maxRFOutputPower,
  //       splitOptionAlarmState: state.splitOptionAlarmState,
  //       // pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
  //       // pilotFrequency2AlarmState: event.pilotFrequency2AlarmState,
  //       startFrequencyOutputLevelAlarmState:
  //           state.startFrequencyOutputLevelAlarmState,
  //       stopFrequencyOutputLevelAlarmState:
  //           state.stopFrequencyOutputLevelAlarmState,
  //     ),
  //   ));
  // }

  void _onStartFrequencyOutputLevelAlarmStateChanged(
    StartFrequencyOutputLevelAlarmStateChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.rfOutputPilotLowFrequencyAlarmState);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      startFrequencyOutputLevelAlarmState:
          event.startFrequencyOutputLevelAlarmState,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        voltageRippleAlarmState: state.voltageRippleAlarmState,
        minVoltageRipple: state.minVoltageRipple,
        maxVoltageRipple: state.maxVoltageRipple,
        rfOutputPowerAlarmState: state.rfOutputPowerAlarmState,
        minRFOutputPower: state.minRFOutputPower,
        maxRFOutputPower: state.maxRFOutputPower,
        splitOptionAlarmState: state.splitOptionAlarmState,
        // pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        // pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        startFrequencyOutputLevelAlarmState:
            event.startFrequencyOutputLevelAlarmState,
        stopFrequencyOutputLevelAlarmState:
            state.stopFrequencyOutputLevelAlarmState,
      ),
    ));
  }

  void _onStopFrequencyOutputLevelAlarmStateChanged(
    StopFrequencyOutputLevelAlarmStateChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    Set<DataKey> tappedSet = Set.from(state.tappedSet);
    tappedSet.add(DataKey.rfOutputPilotHighFrequencyAlarmState);

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      stopFrequencyOutputLevelAlarmState:
          event.stopFrequencyOutputLevelAlarmState,
      isInitialize: false,
      tappedSet: tappedSet,
      enableSubmission: _isEnabledSubmission(
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        voltageRippleAlarmState: state.voltageRippleAlarmState,
        minVoltageRipple: state.minVoltageRipple,
        maxVoltageRipple: state.maxVoltageRipple,
        rfOutputPowerAlarmState: state.rfOutputPowerAlarmState,
        minRFOutputPower: state.minRFOutputPower,
        maxRFOutputPower: state.maxRFOutputPower,
        splitOptionAlarmState: state.splitOptionAlarmState,
        // pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        // pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        startFrequencyOutputLevelAlarmState:
            state.startFrequencyOutputLevelAlarmState,
        stopFrequencyOutputLevelAlarmState:
            event.stopFrequencyOutputLevelAlarmState,
      ),
    ));
  }

  void _onEditModeEnabled(
    EditModeEnabled event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: false,
      editMode: true,
    ));
  }

  void _onEditModeDisabled(
    EditModeDisabled event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    String minTemperatureC = state.initialValues[DataKey.minTemperatureC] ?? '';
    String maxTemperatureC = state.initialValues[DataKey.maxTemperatureC] ?? '';
    String minTemperatureF = state.initialValues[DataKey.minTemperatureF] ?? '';
    String maxTemperatureF = state.initialValues[DataKey.maxTemperatureF] ?? '';

    String strTemperatureAlarmState =
        state.initialValues[DataKey.temperatureAlarmState] ?? '';

    String strVoltageAlarmState =
        state.initialValues[DataKey.voltageAlarmState] ?? '';

    String strVoltageRippleAlarmState =
        state.initialValues[DataKey.voltageRippleAlarmState] ?? '';

    String strRFOutputPowerAlarmState =
        state.initialValues[DataKey.rfOutputPowerAlarmState] ?? '';

    String strSplitOptionAlarmState =
        state.initialValues[DataKey.splitOptionAlarmState] ?? '';

    // String strPilotFrequency1AlarmState =
    //     state.initialValues[DataKey.pilotFrequency1AlarmState] ?? '';

    // String strPilotFrequency2AlarmState =
    //     state.initialValues[DataKey.pilotFrequency2AlarmState] ?? '';

    String strStartFrequencyOutputLevelAlarmState =
        state.initialValues[DataKey.rfOutputPilotLowFrequencyAlarmState] ?? '';

    String strStopFrequencyOutputLevelAlarmState =
        state.initialValues[DataKey.rfOutputPilotHighFrequencyAlarmState] ?? '';

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: true,
      editMode: false,
      enableSubmission: false,
      tappedSet: const {},
      temperatureAlarmState: _stringNumberToBool(strTemperatureAlarmState),
      minTemperature: FloatPointInput.dirty(
        getMinTemperature(
          minTemperatureC: minTemperatureC,
          minTemperatureF: minTemperatureF,
        ),
      ),
      maxTemperature: FloatPointInput.dirty(
        getMaxTemperature(
          maxTemperatureC: maxTemperatureC,
          maxTemperatureF: maxTemperatureF,
        ),
      ),
      temperatureUnit: _unitRepository.temperatureUnit,
      voltageAlarmState: _stringNumberToBool(strVoltageAlarmState),
      minVoltage:
          FloatPointInput.dirty(state.initialValues[DataKey.minVoltage] ?? ''),
      maxVoltage:
          FloatPointInput.dirty(state.initialValues[DataKey.maxVoltage] ?? ''),
      voltageRippleAlarmState: _stringNumberToBool(strVoltageRippleAlarmState),
      minVoltageRipple: IntegerInput.dirty(
          state.initialValues[DataKey.minVoltageRipple] ?? ''),
      maxVoltageRipple: IntegerInput.dirty(
          state.initialValues[DataKey.maxVoltageRipple] ?? ''),
      rfOutputPowerAlarmState: _stringNumberToBool(strRFOutputPowerAlarmState),
      minRFOutputPower: FloatPointInput.dirty(
          state.initialValues[DataKey.minRFOutputPower] ?? ''),
      maxRFOutputPower: FloatPointInput.dirty(
          state.initialValues[DataKey.maxRFOutputPower] ?? ''),
      splitOptionAlarmState: _stringNumberToBool(strSplitOptionAlarmState),
      // pilotFrequency1AlarmState:
      //     _stringNumberToBool(strPilotFrequency1AlarmState),
      // pilotFrequency2AlarmState:
      //     _stringNumberToBool(strPilotFrequency2AlarmState),
      startFrequencyOutputLevelAlarmState:
          _stringNumberToBool(strStartFrequencyOutputLevelAlarmState),
      stopFrequencyOutputLevelAlarmState:
          _stringNumberToBool(strStopFrequencyOutputLevelAlarmState),
    ));
  }

  bool _isEnabledSubmission({
    required bool temperatureAlarmState,
    required FloatPointInput minTemperature,
    required FloatPointInput maxTemperature,
    required bool voltageAlarmState,
    required FloatPointInput minVoltage,
    required FloatPointInput maxVoltage,
    required bool voltageRippleAlarmState,
    required IntegerInput minVoltageRipple,
    required IntegerInput maxVoltageRipple,
    required bool rfOutputPowerAlarmState,
    required FloatPointInput minRFOutputPower,
    required FloatPointInput maxRFOutputPower,
    required bool splitOptionAlarmState,
    // required bool pilotFrequency1AlarmState,
    // required bool pilotFrequency2AlarmState,
    required bool startFrequencyOutputLevelAlarmState,
    required bool stopFrequencyOutputLevelAlarmState,
  }) {
    String minTemperatureC = state.initialValues[DataKey.minTemperatureC] ?? '';
    String maxTemperatureC = state.initialValues[DataKey.maxTemperatureC] ?? '';
    String minTemperatureF = state.initialValues[DataKey.minTemperatureF] ?? '';
    String maxTemperatureF = state.initialValues[DataKey.maxTemperatureF] ?? '';
    String strTemperatureAlarmState =
        state.initialValues[DataKey.temperatureAlarmState] ?? '';

    String strVoltageAlarmState =
        state.initialValues[DataKey.voltageAlarmState] ?? '';

    String strVoltageRippleAlarmState =
        state.initialValues[DataKey.voltageRippleAlarmState] ?? '';

    String strRFOutputPowerAlarmState =
        state.initialValues[DataKey.rfOutputPowerAlarmState] ?? '';

    String strSplitOptionAlarmState =
        state.initialValues[DataKey.splitOptionAlarmState] ?? '';

    // String strPilotFrequency1AlarmState =
    //     state.initialValues[DataKey.pilotFrequency1AlarmState] ?? '';

    // String strPilotFrequency2AlarmState =
    //     state.initialValues[DataKey.pilotFrequency2AlarmState] ?? '';

    String strStartFrequencyOutputLevelAlarmState =
        state.initialValues[DataKey.rfOutputPilotLowFrequencyAlarmState] ?? '';

    String strStopFrequencyOutputLevelAlarmState =
        state.initialValues[DataKey.rfOutputPilotHighFrequencyAlarmState] ?? '';

    bool isValid = Formz.validate([
      minTemperature,
      maxTemperature,
      minVoltage,
      maxVoltage,
      minVoltageRipple,
      maxVoltageRipple,
      minRFOutputPower,
      maxRFOutputPower,
    ]);

    if (isValid) {
      if (temperatureAlarmState !=
              _stringNumberToBool(strTemperatureAlarmState) ||
          minTemperature.value !=
              getMinTemperature(
                minTemperatureC: minTemperatureC,
                minTemperatureF: minTemperatureF,
              ) ||
          maxTemperature.value !=
              getMaxTemperature(
                maxTemperatureC: maxTemperatureC,
                maxTemperatureF: maxTemperatureF,
              ) ||
          voltageAlarmState != _stringNumberToBool(strVoltageAlarmState) ||
          minVoltage.value != state.initialValues[DataKey.minVoltage] ||
          maxVoltage.value != state.initialValues[DataKey.maxVoltage] ||
          voltageRippleAlarmState !=
              _stringNumberToBool(strVoltageRippleAlarmState) ||
          minVoltageRipple.value !=
              state.initialValues[DataKey.minVoltageRipple] ||
          maxVoltageRipple.value !=
              state.initialValues[DataKey.maxVoltageRipple] ||
          rfOutputPowerAlarmState !=
              _stringNumberToBool(strRFOutputPowerAlarmState) ||
          minRFOutputPower.value !=
              state.initialValues[DataKey.minRFOutputPower] ||
          maxRFOutputPower.value !=
              state.initialValues[DataKey.maxRFOutputPower] ||
          splitOptionAlarmState !=
              _stringNumberToBool(strSplitOptionAlarmState) ||
          // pilotFrequency1AlarmState !=
          //     _stringNumberToBool(strPilotFrequency1AlarmState) ||
          // pilotFrequency2AlarmState !=
          //     _stringNumberToBool(strPilotFrequency2AlarmState) ||
          startFrequencyOutputLevelAlarmState !=
              _stringNumberToBool(strStartFrequencyOutputLevelAlarmState) ||
          stopFrequencyOutputLevelAlarmState !=
              _stringNumberToBool(strStopFrequencyOutputLevelAlarmState)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void _onSettingSubmitted(
    SettingSubmitted event,
    Emitter<Setting18ThresholdState> emit,
  ) async {
    emit(state.copyWith(
      isInitialize: false,
      submissionStatus: SubmissionStatus.submissionInProgress,
    ));

    String minTemperatureC = state.initialValues[DataKey.minTemperatureC] ?? '';
    String maxTemperatureC = state.initialValues[DataKey.maxTemperatureC] ?? '';
    String minTemperatureF = state.initialValues[DataKey.minTemperatureF] ?? '';
    String maxTemperatureF = state.initialValues[DataKey.maxTemperatureF] ?? '';
    String minVoltage = state.initialValues[DataKey.minVoltage] ?? '';
    String maxVoltage = state.initialValues[DataKey.maxVoltage] ?? '';
    String minVoltageRipple =
        state.initialValues[DataKey.minVoltageRipple] ?? '';
    String maxVoltageRipple =
        state.initialValues[DataKey.maxVoltageRipple] ?? '';
    String minRFOutputPower =
        state.initialValues[DataKey.minRFOutputPower] ?? '';
    String maxRFOutputPower =
        state.initialValues[DataKey.maxRFOutputPower] ?? '';

    String strTemperatureAlarmState =
        state.initialValues[DataKey.temperatureAlarmState] ?? '';
    bool temperatureAlarmState = strTemperatureAlarmState == '1' ? false : true;
    String strVoltageAlarmState =
        state.initialValues[DataKey.voltageAlarmState] ?? '';
    bool voltageAlarmState = strVoltageAlarmState == '1' ? false : true;
    String strVoltageRippleAlarmState =
        state.initialValues[DataKey.voltageRippleAlarmState] ?? '';
    bool voltageRippleAlarmState =
        strVoltageRippleAlarmState == '1' ? false : true;
    String strRFOutputPowerAlarmState =
        state.initialValues[DataKey.rfOutputPowerAlarmState] ?? '';
    bool rfOutputPowerAlarmState =
        strRFOutputPowerAlarmState == '1' ? false : true;
    String strSplitOptionAlarmState =
        state.initialValues[DataKey.splitOptionAlarmState] ?? '';
    bool splitOptionAlarmState = strSplitOptionAlarmState == '1' ? false : true;

    // String strPilotFrequency1AlarmState =
    //     state.initialValues[DataKey.pilotFrequency1AlarmState] ?? '';
    // bool pilotFrequency1AlarmState =
    //     strPilotFrequency1AlarmState == '1' ? false : true;
    // String strPilotFrequency2AlarmState =
    //     state.initialValues[DataKey.pilotFrequency2AlarmState] ?? '';
    // bool pilotFrequency2AlarmState =
    //     strPilotFrequency2AlarmState == '1' ? false : true;

    String strStartFrequencyOutputLevelAlarmState =
        state.initialValues[DataKey.rfOutputPilotLowFrequencyAlarmState] ?? '';
    bool startFrequencyOutputLevelAlarmState =
        strStartFrequencyOutputLevelAlarmState == '1' ? false : true;

    String strStopFrequencyOutputLevelAlarmState =
        state.initialValues[DataKey.rfOutputPilotHighFrequencyAlarmState] ?? '';
    bool stopFrequencyOutputLevelAlarmState =
        strStopFrequencyOutputLevelAlarmState == '1' ? false : true;

    String minTemperature = getMinTemperature(
      minTemperatureC: minTemperatureC,
      minTemperatureF: minTemperatureF,
    );
    String maxTemperature = getMaxTemperature(
      maxTemperatureC: maxTemperatureC,
      maxTemperatureF: maxTemperatureF,
    );

    List<String> settingResult = [];

    if (state.temperatureAlarmState != temperatureAlarmState) {
      String temperatureAlarmState =
          _boolToStringNumber(state.temperatureAlarmState);
      bool resultOfSetTemperatureAlarmState = await _amp18Repository
          .set1p8GTemperatureAlarmState(temperatureAlarmState);

      settingResult.add(
          '${DataKey.temperatureAlarmState.name},$resultOfSetTemperatureAlarmState');
    }

    if (state.minTemperature.value != minTemperature) {
      String minTemperature = state.minTemperature.value;
      if (state.temperatureUnit == TemperatureUnit.fahrenheit) {
        minTemperature = _unitRepository
            .convertStrFahrenheitToCelcius(minTemperature)
            .toStringAsFixed(1);
      }

      bool resultOfSetMinTemperature =
          await _amp18Repository.set1p8GMinTemperature(minTemperature);

      settingResult
          .add('${DataKey.minTemperatureC.name},$resultOfSetMinTemperature');
    }

    if (state.maxTemperature.value != maxTemperature) {
      String maxTemperature = state.maxTemperature.value;
      if (state.temperatureUnit == TemperatureUnit.fahrenheit) {
        maxTemperature = _unitRepository
            .convertStrFahrenheitToCelcius(maxTemperature)
            .toStringAsFixed(1);
      }

      bool resultOfSetMaxTemperature =
          await _amp18Repository.set1p8GMaxTemperature(maxTemperature);

      settingResult
          .add('${DataKey.maxTemperatureC.name},$resultOfSetMaxTemperature');
    }

    if (state.voltageAlarmState != voltageAlarmState) {
      String voltageAlarmState = _boolToStringNumber(state.voltageAlarmState);
      bool resultOfSetVoltageAlarmState =
          await _amp18Repository.set1p8GVoltageAlarmState(voltageAlarmState);

      settingResult.add(
          '${DataKey.voltageAlarmState.name},$resultOfSetVoltageAlarmState');
    }

    if (state.minVoltage.value != minVoltage) {
      bool resultOfSetMinVoltage =
          await _amp18Repository.set1p8GMinVoltage(state.minVoltage.value);

      settingResult.add('${DataKey.minVoltage.name},$resultOfSetMinVoltage');
    }

    if (state.maxVoltage.value != maxVoltage) {
      bool resultOfSetMaxVoltage =
          await _amp18Repository.set1p8GMaxVoltage(state.maxVoltage.value);

      settingResult.add('${DataKey.maxVoltage.name},$resultOfSetMaxVoltage');
    }

    if (state.voltageRippleAlarmState != voltageRippleAlarmState) {
      String voltageRippleAlarmState =
          _boolToStringNumber(state.voltageRippleAlarmState);
      bool resultOfSetVoltageRippleAlarmState = await _amp18Repository
          .set1p8GVoltageRippleAlarmState(voltageRippleAlarmState);

      settingResult.add(
          '${DataKey.voltageRippleAlarmState.name},$resultOfSetVoltageRippleAlarmState');
    }

    if (state.minVoltageRipple.value != minVoltageRipple) {
      bool resultOfSetMinVoltageRipple = await _amp18Repository
          .set1p8GMinVoltageRipple(state.minVoltageRipple.value);

      settingResult
          .add('${DataKey.minVoltageRipple.name},$resultOfSetMinVoltageRipple');
    }

    if (state.maxVoltageRipple.value != maxVoltageRipple) {
      bool resultOfSetMaxVoltageRipple = await _amp18Repository
          .set1p8GMaxVoltageRipple(state.maxVoltageRipple.value);

      settingResult
          .add('${DataKey.maxVoltageRipple.name},$resultOfSetMaxVoltageRipple');
    }

    if (state.rfOutputPowerAlarmState != rfOutputPowerAlarmState) {
      String voltageRFOutputPowerAlarmState =
          _boolToStringNumber(state.rfOutputPowerAlarmState);
      bool resultOfSetRFOutputPowerAlarmState = await _amp18Repository
          .set1p8GRFOutputPowerAlarmState(voltageRFOutputPowerAlarmState);

      settingResult.add(
          '${DataKey.rfOutputPowerAlarmState.name},$resultOfSetRFOutputPowerAlarmState');
    }

    if (state.minRFOutputPower.value != minRFOutputPower) {
      bool resultOfSetMinRFOutputPower = await _amp18Repository
          .set1p8GMinRFOutputPower(state.minRFOutputPower.value);

      settingResult
          .add('${DataKey.minRFOutputPower.name},$resultOfSetMinRFOutputPower');
    }

    if (state.maxRFOutputPower.value != maxRFOutputPower) {
      bool resultOfSetMaxRFOutputPower = await _amp18Repository
          .set1p8GMaxRFOutputPower(state.maxRFOutputPower.value);

      settingResult
          .add('${DataKey.maxRFOutputPower.name},$resultOfSetMaxRFOutputPower');
    }

    if (state.splitOptionAlarmState != splitOptionAlarmState) {
      String splitOptionAlarmState =
          _boolToStringNumber(state.splitOptionAlarmState);
      bool resultOfSetSplitOptionAlarmState = await _amp18Repository
          .set1p8GSplitOptionAlarmState(splitOptionAlarmState);

      settingResult.add(
          '${DataKey.splitOptionAlarmState.name},$resultOfSetSplitOptionAlarmState');
    }

    // if (state.pilotFrequency1AlarmState != pilotFrequency1AlarmState) {
    //   String voltagePilotFrequency1AlarmState =
    //       _boolToStringNumber(state.pilotFrequency1AlarmState);
    //   bool resultOfSetPilotFrequency1AlarmState =
    //       await _amp18Repository.setInputPilotLowFrequencyAlarmState(
    //           voltagePilotFrequency1AlarmState);

    //   settingResult.add(
    //       '${DataKey.pilotFrequency1AlarmState.name},$resultOfSetPilotFrequency1AlarmState');
    // }

    // if (state.pilotFrequency2AlarmState != pilotFrequency2AlarmState) {
    //   String pilotFrequency2AlarmState =
    //       _boolToStringNumber(state.pilotFrequency2AlarmState);
    //   bool resultOfSetPilotFrequency2AlarmState = await _amp18Repository
    //       .setInputPilotHighFrequencyAlarmState(pilotFrequency2AlarmState);

    //   settingResult.add(
    //       '${DataKey.pilotFrequency2AlarmState.name},$resultOfSetPilotFrequency2AlarmState');
    // }

    if (state.startFrequencyOutputLevelAlarmState !=
        startFrequencyOutputLevelAlarmState) {
      String startFrequencyOutputLevelAlarmState =
          _boolToStringNumber(state.startFrequencyOutputLevelAlarmState);
      bool resultOfSetStartFrequencyOutputLevelAlarmState =
          await _amp18Repository.setOutputPilotLowFrequencyAlarmState(
              startFrequencyOutputLevelAlarmState);

      settingResult.add(
          '${DataKey.rfOutputPilotLowFrequencyAlarmState.name},$resultOfSetStartFrequencyOutputLevelAlarmState');
    }

    if (state.stopFrequencyOutputLevelAlarmState !=
        stopFrequencyOutputLevelAlarmState) {
      String stopFrequencyOutputLevelAlarmState =
          _boolToStringNumber(state.stopFrequencyOutputLevelAlarmState);
      bool resultOfSetStopFrequencyOutputLevelAlarmState =
          await _amp18Repository.setOutputPilotHighFrequencyAlarmState(
              stopFrequencyOutputLevelAlarmState);

      settingResult.add(
          '${DataKey.rfOutputPilotHighFrequencyAlarmState.name},$resultOfSetStopFrequencyOutputLevelAlarmState');
    }

    // 等待 device 完成更新後在讀取值
    await Future.delayed(const Duration(milliseconds: 1000));

    await _amp18Repository.updateCharacteristics();

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
      tappedSet: const {},
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
