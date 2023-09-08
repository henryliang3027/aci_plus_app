import 'dart:math';

import 'package:dsim_app/core/command.dart';
import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:dsim_app/repositories/unit_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_threshold_event.dart';
part 'setting18_threshold_state.dart';

class Setting18ThresholdBloc
    extends Bloc<Setting18ThresholdEvent, Setting18ThresholdState> {
  Setting18ThresholdBloc({
    required DsimRepository dsimRepository,
    required UnitRepository unitRepository,
  })  : _dsimRepository = dsimRepository,
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
    on<PilotFrequency1AlarmChanged>(_onPilotFrequency1AlarmChanged);
    on<PilotFrequency2AlarmChanged>(_onPilotFrequency2AlarmChanged);
    on<FirstChannelOutputLevelAlarmChanged>(
        _onFirstChannelOutputLevelAlarmChanged);
    on<LastChannelOutputLevelAlarmChanged>(
        _onLastChannelOutputLevelAlarmChanged);
    on<EditModeEnabled>(_onEditModeEnabled);
    on<EditModeDisabled>(_onEditModeDisabled);
    on<SettingSubmitted>(_onSettingSubmitted);
  }

  final DsimRepository _dsimRepository;
  final UnitRepository _unitRepository;

  Future<void> _onInitialized(
    Initialized event,
    Emitter<Setting18ThresholdState> emit,
  ) async {
    String minTemperature = '';
    String maxTemperature = '';

    if (_unitRepository.temperatureUnit == TemperatureUnit.celsius) {
      minTemperature = event.minTemperature;
      maxTemperature = event.maxTemperature;
    } else {
      minTemperature = event.minTemperatureF;
      maxTemperature = event.maxTemperatureF;
    }

    emit(state.copyWith(
      enableTemperatureAlarm: event.enableTemperatureAlarm,
      minTemperature: minTemperature,
      maxTemperature: maxTemperature,
      temperatureUnit: _unitRepository.temperatureUnit,
      enableVoltageAlarm: event.enableVoltageAlarm,
      minVoltage: event.minVoltage,
      maxVoltage: event.maxVoltage,
      enableVoltageRippleAlarm: event.enableVoltageRippleAlarm,
      minVoltageRipple: event.minVoltageRipple,
      maxVoltageRipple: event.maxVoltageRipple,
      enableRFOutputPowerAlarm: event.enableRFOutputPowerAlarm,
      minRFOutputPower: event.minRFOutputPower,
      maxRFOutputPower: event.maxRFOutputPower,
      enablePilotFrequency1Alarm: event.enablePilotFrequency1Alarm,
      enablePilotFrequency2Alarm: event.enablePilotFrequency2Alarm,
      enableFirstChannelOutputLevelAlarm:
          event.enableFirstChannelOutputLevelAlarm,
      enableLastChannelOutputLevelAlarm:
          event.enableLastChannelOutputLevelAlarm,
      isInitialize: true,
      initialValues: [
        event.enableTemperatureAlarm,
        minTemperature,
        maxTemperature,
        event.enableVoltageAlarm,
        event.minVoltage,
        event.maxVoltage,
        event.enableVoltageRippleAlarm,
        event.minVoltageRipple,
        event.maxVoltageRipple,
        event.enableRFOutputPowerAlarm,
        event.minRFOutputPower,
        event.maxRFOutputPower,
        event.enablePilotFrequency1Alarm,
        event.enablePilotFrequency2Alarm,
        event.enableFirstChannelOutputLevelAlarm,
        event.enableLastChannelOutputLevelAlarm,
      ],
    ));
  }

  void _onTemperatureAlarmChanged(
    TemperatureAlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        enableTemperatureAlarm: event.enableTemperatureAlarm,
        isInitialize: false,
        enableSubmission: _isEnabledSubmission(
          enableTemperatureAlarm: event.enableTemperatureAlarm,
          minTemperature: state.minTemperature,
          maxTemperature: state.maxTemperature,
          enableVoltageAlarm: state.enableVoltageAlarm,
          minVoltage: state.minVoltage,
          maxVoltage: state.maxVoltage,
          enableVoltageRippleAlarm: state.enableVoltageRippleAlarm,
          minVoltageRipple: state.minVoltageRipple,
          maxVoltageRipple: state.maxVoltageRipple,
          enableRFOutputPowerAlarm: state.enableRFOutputPowerAlarm,
          minRFOutputPower: state.minRFOutputPower,
          maxRFOutputPower: state.maxRFOutputPower,
          enablePilotFrequency1Alarm: state.enablePilotFrequency1Alarm,
          enablePilotFrequency2Alarm: state.enablePilotFrequency2Alarm,
          enableFirstChannelOutputLevelAlarm:
              state.enableFirstChannelOutputLevelAlarm,
          enableLastChannelOutputLevelAlarm:
              state.enableLastChannelOutputLevelAlarm,
        )));
  }

  void _onMinTemperatureChanged(
    MinTemperatureChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        minTemperature: event.minTemperature,
        isInitialize: false,
        enableSubmission: _isEnabledSubmission(
          enableTemperatureAlarm: state.enableTemperatureAlarm,
          minTemperature: event.minTemperature,
          maxTemperature: state.maxTemperature,
          enableVoltageAlarm: state.enableVoltageAlarm,
          minVoltage: state.minVoltage,
          maxVoltage: state.maxVoltage,
          enableVoltageRippleAlarm: state.enableVoltageRippleAlarm,
          minVoltageRipple: state.minVoltageRipple,
          maxVoltageRipple: state.maxVoltageRipple,
          enableRFOutputPowerAlarm: state.enableRFOutputPowerAlarm,
          minRFOutputPower: state.minRFOutputPower,
          maxRFOutputPower: state.maxRFOutputPower,
          enablePilotFrequency1Alarm: state.enablePilotFrequency1Alarm,
          enablePilotFrequency2Alarm: state.enablePilotFrequency2Alarm,
          enableFirstChannelOutputLevelAlarm:
              state.enableFirstChannelOutputLevelAlarm,
          enableLastChannelOutputLevelAlarm:
              state.enableLastChannelOutputLevelAlarm,
        )));
  }

  void _onMaxTemperatureChanged(
    MaxTemperatureChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        maxTemperature: event.maxTemperature,
        isInitialize: false,
        enableSubmission: _isEnabledSubmission(
          enableTemperatureAlarm: state.enableTemperatureAlarm,
          minTemperature: state.minTemperature,
          maxTemperature: event.maxTemperature,
          enableVoltageAlarm: state.enableVoltageAlarm,
          minVoltage: state.minVoltage,
          maxVoltage: state.maxVoltage,
          enableVoltageRippleAlarm: state.enableVoltageRippleAlarm,
          minVoltageRipple: state.minVoltageRipple,
          maxVoltageRipple: state.maxVoltageRipple,
          enableRFOutputPowerAlarm: state.enableRFOutputPowerAlarm,
          minRFOutputPower: state.minRFOutputPower,
          maxRFOutputPower: state.maxRFOutputPower,
          enablePilotFrequency1Alarm: state.enablePilotFrequency1Alarm,
          enablePilotFrequency2Alarm: state.enablePilotFrequency2Alarm,
          enableFirstChannelOutputLevelAlarm:
              state.enableFirstChannelOutputLevelAlarm,
          enableLastChannelOutputLevelAlarm:
              state.enableLastChannelOutputLevelAlarm,
        )));
  }

  void _onVoltageAlarmChanged(
    VoltageAlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        enableVoltageAlarm: event.enableVoltageAlarm,
        isInitialize: false,
        enableSubmission: _isEnabledSubmission(
          enableTemperatureAlarm: state.enableTemperatureAlarm,
          minTemperature: state.minTemperature,
          maxTemperature: state.maxTemperature,
          enableVoltageAlarm: event.enableVoltageAlarm,
          minVoltage: state.minVoltage,
          maxVoltage: state.maxVoltage,
          enableVoltageRippleAlarm: state.enableVoltageRippleAlarm,
          minVoltageRipple: state.minVoltageRipple,
          maxVoltageRipple: state.maxVoltageRipple,
          enableRFOutputPowerAlarm: state.enableRFOutputPowerAlarm,
          minRFOutputPower: state.minRFOutputPower,
          maxRFOutputPower: state.maxRFOutputPower,
          enablePilotFrequency1Alarm: state.enablePilotFrequency1Alarm,
          enablePilotFrequency2Alarm: state.enablePilotFrequency2Alarm,
          enableFirstChannelOutputLevelAlarm:
              state.enableFirstChannelOutputLevelAlarm,
          enableLastChannelOutputLevelAlarm:
              state.enableLastChannelOutputLevelAlarm,
        )));
  }

  void _onMinVoltageChanged(
    MinVoltageChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        minVoltage: event.minVoltage,
        isInitialize: false,
        enableSubmission: _isEnabledSubmission(
          enableTemperatureAlarm: state.enableTemperatureAlarm,
          minTemperature: state.minTemperature,
          maxTemperature: state.maxTemperature,
          enableVoltageAlarm: state.enableVoltageAlarm,
          minVoltage: event.minVoltage,
          maxVoltage: state.maxVoltage,
          enableVoltageRippleAlarm: state.enableVoltageRippleAlarm,
          minVoltageRipple: state.minVoltageRipple,
          maxVoltageRipple: state.maxVoltageRipple,
          enableRFOutputPowerAlarm: state.enableRFOutputPowerAlarm,
          minRFOutputPower: state.minRFOutputPower,
          maxRFOutputPower: state.maxRFOutputPower,
          enablePilotFrequency1Alarm: state.enablePilotFrequency1Alarm,
          enablePilotFrequency2Alarm: state.enablePilotFrequency2Alarm,
          enableFirstChannelOutputLevelAlarm:
              state.enableFirstChannelOutputLevelAlarm,
          enableLastChannelOutputLevelAlarm:
              state.enableLastChannelOutputLevelAlarm,
        )));
  }

  void _onMaxVoltageChanged(
    MaxVoltageChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        maxVoltage: event.maxVoltage,
        isInitialize: false,
        enableSubmission: _isEnabledSubmission(
          enableTemperatureAlarm: state.enableTemperatureAlarm,
          minTemperature: state.minTemperature,
          maxTemperature: state.maxTemperature,
          enableVoltageAlarm: state.enableVoltageAlarm,
          minVoltage: state.minVoltage,
          maxVoltage: event.maxVoltage,
          enableVoltageRippleAlarm: state.enableVoltageRippleAlarm,
          minVoltageRipple: state.minVoltageRipple,
          maxVoltageRipple: state.maxVoltageRipple,
          enableRFOutputPowerAlarm: state.enableRFOutputPowerAlarm,
          minRFOutputPower: state.minRFOutputPower,
          maxRFOutputPower: state.maxRFOutputPower,
          enablePilotFrequency1Alarm: state.enablePilotFrequency1Alarm,
          enablePilotFrequency2Alarm: state.enablePilotFrequency2Alarm,
          enableFirstChannelOutputLevelAlarm:
              state.enableFirstChannelOutputLevelAlarm,
          enableLastChannelOutputLevelAlarm:
              state.enableLastChannelOutputLevelAlarm,
        )));
  }

  void _onVoltageRippleAlarmChanged(
    VoltageRippleAlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        enableVoltageRippleAlarm: event.enableVoltageRippleAlarm,
        isInitialize: false,
        enableSubmission: _isEnabledSubmission(
          enableTemperatureAlarm: state.enableTemperatureAlarm,
          minTemperature: state.minTemperature,
          maxTemperature: state.maxTemperature,
          enableVoltageAlarm: state.enableVoltageAlarm,
          minVoltage: state.minVoltage,
          maxVoltage: state.maxVoltage,
          enableVoltageRippleAlarm: event.enableVoltageRippleAlarm,
          minVoltageRipple: state.minVoltageRipple,
          maxVoltageRipple: state.maxVoltageRipple,
          enableRFOutputPowerAlarm: state.enableRFOutputPowerAlarm,
          minRFOutputPower: state.minRFOutputPower,
          maxRFOutputPower: state.maxRFOutputPower,
          enablePilotFrequency1Alarm: state.enablePilotFrequency1Alarm,
          enablePilotFrequency2Alarm: state.enablePilotFrequency2Alarm,
          enableFirstChannelOutputLevelAlarm:
              state.enableFirstChannelOutputLevelAlarm,
          enableLastChannelOutputLevelAlarm:
              state.enableLastChannelOutputLevelAlarm,
        )));
  }

  void _onMinVoltageRippleChanged(
    MinVoltageRippleChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        minVoltageRipple: event.minVoltageRipple,
        isInitialize: false,
        enableSubmission: _isEnabledSubmission(
          enableTemperatureAlarm: state.enableTemperatureAlarm,
          minTemperature: state.minTemperature,
          maxTemperature: state.maxTemperature,
          enableVoltageAlarm: state.enableVoltageAlarm,
          minVoltage: state.minVoltage,
          maxVoltage: state.maxVoltage,
          enableVoltageRippleAlarm: state.enableVoltageRippleAlarm,
          minVoltageRipple: event.minVoltageRipple,
          maxVoltageRipple: state.maxVoltageRipple,
          enableRFOutputPowerAlarm: state.enableRFOutputPowerAlarm,
          minRFOutputPower: state.minRFOutputPower,
          maxRFOutputPower: state.maxRFOutputPower,
          enablePilotFrequency1Alarm: state.enablePilotFrequency1Alarm,
          enablePilotFrequency2Alarm: state.enablePilotFrequency2Alarm,
          enableFirstChannelOutputLevelAlarm:
              state.enableFirstChannelOutputLevelAlarm,
          enableLastChannelOutputLevelAlarm:
              state.enableLastChannelOutputLevelAlarm,
        )));
  }

  void _onMaxVoltageRippleChanged(
    MaxVoltageRippleChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        maxVoltageRipple: event.maxVoltageRipple,
        isInitialize: false,
        enableSubmission: _isEnabledSubmission(
          enableTemperatureAlarm: state.enableTemperatureAlarm,
          minTemperature: state.minTemperature,
          maxTemperature: state.maxTemperature,
          enableVoltageAlarm: state.enableVoltageAlarm,
          minVoltage: state.minVoltage,
          maxVoltage: state.maxVoltage,
          enableVoltageRippleAlarm: state.enableVoltageRippleAlarm,
          minVoltageRipple: state.minVoltageRipple,
          maxVoltageRipple: event.maxVoltageRipple,
          enableRFOutputPowerAlarm: state.enableRFOutputPowerAlarm,
          minRFOutputPower: state.minRFOutputPower,
          maxRFOutputPower: state.maxRFOutputPower,
          enablePilotFrequency1Alarm: state.enablePilotFrequency1Alarm,
          enablePilotFrequency2Alarm: state.enablePilotFrequency2Alarm,
          enableFirstChannelOutputLevelAlarm:
              state.enableFirstChannelOutputLevelAlarm,
          enableLastChannelOutputLevelAlarm:
              state.enableLastChannelOutputLevelAlarm,
        )));
  }

  void _onRFOutputPowerAlarmChanged(
    RFOutputPowerAlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        enableRFOutputPowerAlarm: event.enableRFOutputPowerAlarm,
        isInitialize: false,
        enableSubmission: _isEnabledSubmission(
          enableTemperatureAlarm: state.enableTemperatureAlarm,
          minTemperature: state.minTemperature,
          maxTemperature: state.maxTemperature,
          enableVoltageAlarm: state.enableVoltageAlarm,
          minVoltage: state.minVoltage,
          maxVoltage: state.maxVoltage,
          enableVoltageRippleAlarm: state.enableVoltageRippleAlarm,
          minVoltageRipple: state.minVoltageRipple,
          maxVoltageRipple: state.maxVoltageRipple,
          enableRFOutputPowerAlarm: event.enableRFOutputPowerAlarm,
          minRFOutputPower: state.minRFOutputPower,
          maxRFOutputPower: state.maxRFOutputPower,
          enablePilotFrequency1Alarm: state.enablePilotFrequency1Alarm,
          enablePilotFrequency2Alarm: state.enablePilotFrequency2Alarm,
          enableFirstChannelOutputLevelAlarm:
              state.enableFirstChannelOutputLevelAlarm,
          enableLastChannelOutputLevelAlarm:
              state.enableLastChannelOutputLevelAlarm,
        )));
  }

  void _onMinRFOutputPowerChanged(
    MinRFOutputPowerChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        minRFOutputPower: event.minRFOutputPower,
        isInitialize: false,
        enableSubmission: _isEnabledSubmission(
          enableTemperatureAlarm: state.enableTemperatureAlarm,
          minTemperature: state.minTemperature,
          maxTemperature: state.maxTemperature,
          enableVoltageAlarm: state.enableVoltageAlarm,
          minVoltage: state.minVoltage,
          maxVoltage: state.maxVoltage,
          enableVoltageRippleAlarm: state.enableVoltageRippleAlarm,
          minVoltageRipple: state.minVoltageRipple,
          maxVoltageRipple: state.maxVoltageRipple,
          enableRFOutputPowerAlarm: state.enableRFOutputPowerAlarm,
          minRFOutputPower: event.minRFOutputPower,
          maxRFOutputPower: state.maxRFOutputPower,
          enablePilotFrequency1Alarm: state.enablePilotFrequency1Alarm,
          enablePilotFrequency2Alarm: state.enablePilotFrequency2Alarm,
          enableFirstChannelOutputLevelAlarm:
              state.enableFirstChannelOutputLevelAlarm,
          enableLastChannelOutputLevelAlarm:
              state.enableLastChannelOutputLevelAlarm,
        )));
  }

  void _onMaxRFOutputPowerChanged(
    MaxRFOutputPowerChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        maxRFOutputPower: event.maxRFOutputPower,
        isInitialize: false,
        enableSubmission: _isEnabledSubmission(
          enableTemperatureAlarm: state.enableTemperatureAlarm,
          minTemperature: state.minTemperature,
          maxTemperature: state.maxTemperature,
          enableVoltageAlarm: state.enableVoltageAlarm,
          minVoltage: state.minVoltage,
          maxVoltage: state.maxVoltage,
          enableVoltageRippleAlarm: state.enableVoltageRippleAlarm,
          minVoltageRipple: state.minVoltageRipple,
          maxVoltageRipple: state.maxVoltageRipple,
          enableRFOutputPowerAlarm: state.enableRFOutputPowerAlarm,
          minRFOutputPower: state.minRFOutputPower,
          maxRFOutputPower: event.maxRFOutputPower,
          enablePilotFrequency1Alarm: state.enablePilotFrequency1Alarm,
          enablePilotFrequency2Alarm: state.enablePilotFrequency2Alarm,
          enableFirstChannelOutputLevelAlarm:
              state.enableFirstChannelOutputLevelAlarm,
          enableLastChannelOutputLevelAlarm:
              state.enableLastChannelOutputLevelAlarm,
        )));
  }

  void _onPilotFrequency1AlarmChanged(
    PilotFrequency1AlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        enablePilotFrequency1Alarm: event.enablePilotFrequency1Alarm,
        isInitialize: false,
        enableSubmission: _isEnabledSubmission(
          enableTemperatureAlarm: state.enableTemperatureAlarm,
          minTemperature: state.minTemperature,
          maxTemperature: state.maxTemperature,
          enableVoltageAlarm: state.enableVoltageAlarm,
          minVoltage: state.minVoltage,
          maxVoltage: state.maxVoltage,
          enableVoltageRippleAlarm: state.enableVoltageRippleAlarm,
          minVoltageRipple: state.minVoltageRipple,
          maxVoltageRipple: state.maxVoltageRipple,
          enableRFOutputPowerAlarm: state.enableRFOutputPowerAlarm,
          minRFOutputPower: state.minRFOutputPower,
          maxRFOutputPower: state.maxRFOutputPower,
          enablePilotFrequency1Alarm: event.enablePilotFrequency1Alarm,
          enablePilotFrequency2Alarm: state.enablePilotFrequency2Alarm,
          enableFirstChannelOutputLevelAlarm:
              state.enableFirstChannelOutputLevelAlarm,
          enableLastChannelOutputLevelAlarm:
              state.enableLastChannelOutputLevelAlarm,
        )));
  }

  void _onPilotFrequency2AlarmChanged(
    PilotFrequency2AlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        enablePilotFrequency2Alarm: event.enablePilotFrequency2Alarm,
        isInitialize: false,
        enableSubmission: _isEnabledSubmission(
          enableTemperatureAlarm: state.enableTemperatureAlarm,
          minTemperature: state.minTemperature,
          maxTemperature: state.maxTemperature,
          enableVoltageAlarm: state.enableVoltageAlarm,
          minVoltage: state.minVoltage,
          maxVoltage: state.maxVoltage,
          enableVoltageRippleAlarm: state.enableVoltageRippleAlarm,
          minVoltageRipple: state.minVoltageRipple,
          maxVoltageRipple: state.maxVoltageRipple,
          enableRFOutputPowerAlarm: state.enableRFOutputPowerAlarm,
          minRFOutputPower: state.minRFOutputPower,
          maxRFOutputPower: state.maxRFOutputPower,
          enablePilotFrequency1Alarm: state.enablePilotFrequency1Alarm,
          enablePilotFrequency2Alarm: event.enablePilotFrequency2Alarm,
          enableFirstChannelOutputLevelAlarm:
              state.enableFirstChannelOutputLevelAlarm,
          enableLastChannelOutputLevelAlarm:
              state.enableLastChannelOutputLevelAlarm,
        )));
  }

  void _onFirstChannelOutputLevelAlarmChanged(
    FirstChannelOutputLevelAlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        enableFirstChannelOutputLevelAlarm:
            event.enableFirstChannelOutputLevelAlarm,
        isInitialize: false,
        enableSubmission: _isEnabledSubmission(
          enableTemperatureAlarm: state.enableTemperatureAlarm,
          minTemperature: state.minTemperature,
          maxTemperature: state.maxTemperature,
          enableVoltageAlarm: state.enableVoltageAlarm,
          minVoltage: state.minVoltage,
          maxVoltage: state.maxVoltage,
          enableVoltageRippleAlarm: state.enableVoltageRippleAlarm,
          minVoltageRipple: state.minVoltageRipple,
          maxVoltageRipple: state.maxVoltageRipple,
          enableRFOutputPowerAlarm: state.enableRFOutputPowerAlarm,
          minRFOutputPower: state.minRFOutputPower,
          maxRFOutputPower: state.maxRFOutputPower,
          enablePilotFrequency1Alarm: state.enablePilotFrequency1Alarm,
          enablePilotFrequency2Alarm: state.enablePilotFrequency2Alarm,
          enableFirstChannelOutputLevelAlarm:
              event.enableFirstChannelOutputLevelAlarm,
          enableLastChannelOutputLevelAlarm:
              state.enableLastChannelOutputLevelAlarm,
        )));
  }

  void _onLastChannelOutputLevelAlarmChanged(
    LastChannelOutputLevelAlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
        submissionStatus: SubmissionStatus.none,
        enableLastChannelOutputLevelAlarm:
            event.enableLastChannelOutputLevelAlarm,
        isInitialize: false,
        enableSubmission: _isEnabledSubmission(
          enableTemperatureAlarm: state.enableTemperatureAlarm,
          minTemperature: state.minTemperature,
          maxTemperature: state.maxTemperature,
          enableVoltageAlarm: state.enableVoltageAlarm,
          minVoltage: state.minVoltage,
          maxVoltage: state.maxVoltage,
          enableVoltageRippleAlarm: state.enableVoltageRippleAlarm,
          minVoltageRipple: state.minVoltageRipple,
          maxVoltageRipple: state.maxVoltageRipple,
          enableRFOutputPowerAlarm: state.enableRFOutputPowerAlarm,
          minRFOutputPower: state.minRFOutputPower,
          maxRFOutputPower: state.maxRFOutputPower,
          enablePilotFrequency1Alarm: state.enablePilotFrequency1Alarm,
          enablePilotFrequency2Alarm: state.enablePilotFrequency2Alarm,
          enableFirstChannelOutputLevelAlarm:
              state.enableFirstChannelOutputLevelAlarm,
          enableLastChannelOutputLevelAlarm:
              event.enableLastChannelOutputLevelAlarm,
        )));
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
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: true,
      editMode: false,
      enableSubmission: false,
      enableTemperatureAlarm: state.initialValues[0],
      minTemperature: state.initialValues[1],
      maxTemperature: state.initialValues[2],
      temperatureUnit: _unitRepository.temperatureUnit,
      enableVoltageAlarm: state.initialValues[3],
      minVoltage: state.initialValues[4],
      maxVoltage: state.initialValues[5],
      enableVoltageRippleAlarm: state.initialValues[6],
      minVoltageRipple: state.initialValues[7],
      maxVoltageRipple: state.initialValues[8],
      enableRFOutputPowerAlarm: state.initialValues[9],
      minRFOutputPower: state.initialValues[10],
      maxRFOutputPower: state.initialValues[11],
      enablePilotFrequency1Alarm: state.initialValues[12],
      enablePilotFrequency2Alarm: state.initialValues[13],
      enableFirstChannelOutputLevelAlarm: state.initialValues[14],
      enableLastChannelOutputLevelAlarm: state.initialValues[15],
    ));
  }

  bool _isEnabledSubmission({
    required bool enableTemperatureAlarm,
    required String minTemperature,
    required String maxTemperature,
    required bool enableVoltageAlarm,
    required String minVoltage,
    required String maxVoltage,
    required bool enableVoltageRippleAlarm,
    required String minVoltageRipple,
    required String maxVoltageRipple,
    required bool enableRFOutputPowerAlarm,
    required String minRFOutputPower,
    required String maxRFOutputPower,
    required bool enablePilotFrequency1Alarm,
    required bool enablePilotFrequency2Alarm,
    required bool enableFirstChannelOutputLevelAlarm,
    required bool enableLastChannelOutputLevelAlarm,
  }) {
    if (enableTemperatureAlarm != state.initialValues[0] ||
        minTemperature != state.initialValues[1] ||
        maxTemperature != state.initialValues[2] ||
        enableVoltageAlarm != state.initialValues[3] ||
        minVoltage != state.initialValues[4] ||
        maxVoltage != state.initialValues[5] ||
        enableVoltageRippleAlarm != state.initialValues[6] ||
        minVoltageRipple != state.initialValues[7] ||
        maxVoltageRipple != state.initialValues[8] ||
        enableRFOutputPowerAlarm != state.initialValues[9] ||
        minRFOutputPower != state.initialValues[10] ||
        maxRFOutputPower != state.initialValues[11] ||
        enablePilotFrequency1Alarm != state.initialValues[12] ||
        enablePilotFrequency2Alarm != state.initialValues[13] ||
        enableFirstChannelOutputLevelAlarm != state.initialValues[14] ||
        enableLastChannelOutputLevelAlarm != state.initialValues[15]) {
      return true;
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

    List<String> settingResult = [];

    if (state.minTemperature != state.initialValues[1]) {
      String minTemperature = state.minTemperature;
      if (state.temperatureUnit == TemperatureUnit.fahrenheit) {
        minTemperature = _unitRepository
            .convertStrFahrenheitToCelcius(minTemperature)
            .toStringAsFixed(1);
      }

      bool resultOfSetMinTemperature =
          await _dsimRepository.set1p8GMinTemperature(minTemperature);

      settingResult
          .add('${DataKey.minTemperatureC.name},$resultOfSetMinTemperature');
    }

    if (state.maxTemperature != state.initialValues[2]) {
      String maxTemperature = state.maxTemperature;
      if (state.temperatureUnit == TemperatureUnit.fahrenheit) {
        maxTemperature = _unitRepository
            .convertStrFahrenheitToCelcius(maxTemperature)
            .toStringAsFixed(1);
      }

      bool resultOfSetMaxTemperature =
          await _dsimRepository.set1p8GMaxTemperature(maxTemperature);

      settingResult
          .add('${DataKey.maxTemperatureC.name},$resultOfSetMaxTemperature');
    }

    if (state.minVoltage != state.initialValues[4]) {
      bool resultOfSetMinVoltage =
          await _dsimRepository.set1p8GMinVoltage(state.minVoltage);

      settingResult.add('${DataKey.minVoltage.name},$resultOfSetMinVoltage');
    }

    if (state.maxVoltage != state.initialValues[5]) {
      bool resultOfSetMaxVoltage =
          await _dsimRepository.set1p8GMaxVoltage(state.maxVoltage);

      settingResult.add('${DataKey.maxVoltage.name},$resultOfSetMaxVoltage');
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
