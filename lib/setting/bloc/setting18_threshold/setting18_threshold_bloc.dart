import 'package:aci_plus_app/core/command.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting18_threshold_event.dart';
part 'setting18_threshold_state.dart';

class Setting18ThresholdBloc
    extends Bloc<Setting18ThresholdEvent, Setting18ThresholdState> {
  Setting18ThresholdBloc({
    required Amp18Repository amp18repository,
    required UnitRepository unitRepository,
  })  : _amp18repository = amp18repository,
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

  final Amp18Repository _amp18repository;
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
      temperatureAlarmState: event.temperatureAlarmState,
      minTemperature: minTemperature,
      maxTemperature: maxTemperature,
      temperatureUnit: _unitRepository.temperatureUnit,
      voltageAlarmState: event.voltageAlarmState,
      minVoltage: event.minVoltage,
      maxVoltage: event.maxVoltage,
      voltageRippleAlarmState: event.voltageRippleAlarmState,
      minVoltageRipple: event.minVoltageRipple,
      maxVoltageRipple: event.maxVoltageRipple,
      rfOutputPowerAlarmState: event.rfOutputPowerAlarmState,
      minRFOutputPower: event.minRFOutputPower,
      maxRFOutputPower: event.maxRFOutputPower,
      splitOptionAlarmState: event.splitOptionAlarmState,
      pilotFrequency1AlarmState: event.pilotFrequency1AlarmState,
      pilotFrequency2AlarmState: event.pilotFrequency2AlarmState,
      firstChannelOutputLevelAlarmState:
          event.firstChannelOutputLevelAlarmState,
      lastChannelOutputLevelAlarmState: event.lastChannelOutputLevelAlarmState,
      isInitialize: true,
      initialValues: [
        event.temperatureAlarmState,
        minTemperature,
        maxTemperature,
        event.voltageAlarmState,
        event.minVoltage,
        event.maxVoltage,
        event.voltageRippleAlarmState,
        event.minVoltageRipple,
        event.maxVoltageRipple,
        event.rfOutputPowerAlarmState,
        event.minRFOutputPower,
        event.maxRFOutputPower,
        event.splitOptionAlarmState,
        event.pilotFrequency1AlarmState,
        event.pilotFrequency2AlarmState,
        event.firstChannelOutputLevelAlarmState,
        event.lastChannelOutputLevelAlarmState,
      ],
    ));
  }

  void _onTemperatureAlarmChanged(
    TemperatureAlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      temperatureAlarmState: event.temperatureAlarmState,
      isInitialize: false,
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
        pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        firstChannelOutputLevelAlarmState:
            state.firstChannelOutputLevelAlarmState,
        lastChannelOutputLevelAlarmState:
            state.lastChannelOutputLevelAlarmState,
      ),
    ));
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
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: event.minTemperature,
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
        pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        firstChannelOutputLevelAlarmState:
            state.firstChannelOutputLevelAlarmState,
        lastChannelOutputLevelAlarmState:
            state.lastChannelOutputLevelAlarmState,
      ),
    ));
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
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: event.maxTemperature,
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
        pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        firstChannelOutputLevelAlarmState:
            state.firstChannelOutputLevelAlarmState,
        lastChannelOutputLevelAlarmState:
            state.lastChannelOutputLevelAlarmState,
      ),
    ));
  }

  void _onVoltageAlarmChanged(
    VoltageAlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      voltageAlarmState: event.voltageAlarmState,
      isInitialize: false,
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
        pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        firstChannelOutputLevelAlarmState:
            state.firstChannelOutputLevelAlarmState,
        lastChannelOutputLevelAlarmState:
            state.lastChannelOutputLevelAlarmState,
      ),
    ));
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
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: event.minVoltage,
        maxVoltage: state.maxVoltage,
        voltageRippleAlarmState: state.voltageRippleAlarmState,
        minVoltageRipple: state.minVoltageRipple,
        maxVoltageRipple: state.maxVoltageRipple,
        rfOutputPowerAlarmState: state.rfOutputPowerAlarmState,
        minRFOutputPower: state.minRFOutputPower,
        maxRFOutputPower: state.maxRFOutputPower,
        splitOptionAlarmState: state.splitOptionAlarmState,
        pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        firstChannelOutputLevelAlarmState:
            state.firstChannelOutputLevelAlarmState,
        lastChannelOutputLevelAlarmState:
            state.lastChannelOutputLevelAlarmState,
      ),
    ));
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
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: event.maxVoltage,
        voltageRippleAlarmState: state.voltageRippleAlarmState,
        minVoltageRipple: state.minVoltageRipple,
        maxVoltageRipple: state.maxVoltageRipple,
        rfOutputPowerAlarmState: state.rfOutputPowerAlarmState,
        minRFOutputPower: state.minRFOutputPower,
        maxRFOutputPower: state.maxRFOutputPower,
        splitOptionAlarmState: state.splitOptionAlarmState,
        pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        firstChannelOutputLevelAlarmState:
            state.firstChannelOutputLevelAlarmState,
        lastChannelOutputLevelAlarmState:
            state.lastChannelOutputLevelAlarmState,
      ),
    ));
  }

  void _onVoltageRippleAlarmChanged(
    VoltageRippleAlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      voltageRippleAlarmState: event.voltageRippleAlarmState,
      isInitialize: false,
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
        pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        firstChannelOutputLevelAlarmState:
            state.firstChannelOutputLevelAlarmState,
        lastChannelOutputLevelAlarmState:
            state.lastChannelOutputLevelAlarmState,
      ),
    ));
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
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        voltageRippleAlarmState: state.voltageRippleAlarmState,
        minVoltageRipple: event.minVoltageRipple,
        maxVoltageRipple: state.maxVoltageRipple,
        rfOutputPowerAlarmState: state.rfOutputPowerAlarmState,
        minRFOutputPower: state.minRFOutputPower,
        maxRFOutputPower: state.maxRFOutputPower,
        splitOptionAlarmState: state.splitOptionAlarmState,
        pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        firstChannelOutputLevelAlarmState:
            state.firstChannelOutputLevelAlarmState,
        lastChannelOutputLevelAlarmState:
            state.lastChannelOutputLevelAlarmState,
      ),
    ));
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
        temperatureAlarmState: state.temperatureAlarmState,
        minTemperature: state.minTemperature,
        maxTemperature: state.maxTemperature,
        voltageAlarmState: state.voltageAlarmState,
        minVoltage: state.minVoltage,
        maxVoltage: state.maxVoltage,
        voltageRippleAlarmState: state.voltageRippleAlarmState,
        minVoltageRipple: state.minVoltageRipple,
        maxVoltageRipple: event.maxVoltageRipple,
        rfOutputPowerAlarmState: state.rfOutputPowerAlarmState,
        minRFOutputPower: state.minRFOutputPower,
        maxRFOutputPower: state.maxRFOutputPower,
        splitOptionAlarmState: state.splitOptionAlarmState,
        pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        firstChannelOutputLevelAlarmState:
            state.firstChannelOutputLevelAlarmState,
        lastChannelOutputLevelAlarmState:
            state.lastChannelOutputLevelAlarmState,
      ),
    ));
  }

  void _onRFOutputPowerAlarmChanged(
    RFOutputPowerAlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      rfOutputPowerAlarmState: event.rfOutputPowerAlarmState,
      isInitialize: false,
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
        pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        firstChannelOutputLevelAlarmState:
            state.firstChannelOutputLevelAlarmState,
        lastChannelOutputLevelAlarmState:
            state.lastChannelOutputLevelAlarmState,
      ),
    ));
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
        minRFOutputPower: event.minRFOutputPower,
        maxRFOutputPower: state.maxRFOutputPower,
        splitOptionAlarmState: state.splitOptionAlarmState,
        pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        firstChannelOutputLevelAlarmState:
            state.firstChannelOutputLevelAlarmState,
        lastChannelOutputLevelAlarmState:
            state.lastChannelOutputLevelAlarmState,
      ),
    ));
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
        maxRFOutputPower: event.maxRFOutputPower,
        splitOptionAlarmState: state.splitOptionAlarmState,
        pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        firstChannelOutputLevelAlarmState:
            state.firstChannelOutputLevelAlarmState,
        lastChannelOutputLevelAlarmState:
            state.lastChannelOutputLevelAlarmState,
      ),
    ));
  }

  void _onSplitOptionAlarmChanged(
    SplitOptionAlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      splitOptionAlarmState: event.splitOptionAlarmState,
      isInitialize: false,
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
        pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        firstChannelOutputLevelAlarmState:
            state.firstChannelOutputLevelAlarmState,
        lastChannelOutputLevelAlarmState:
            state.lastChannelOutputLevelAlarmState,
      ),
    ));
  }

  void _onPilotFrequency1AlarmChanged(
    PilotFrequency1AlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      pilotFrequency1AlarmState: event.pilotFrequency1AlarmState,
      isInitialize: false,
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
        pilotFrequency1AlarmState: event.pilotFrequency1AlarmState,
        pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        firstChannelOutputLevelAlarmState:
            state.firstChannelOutputLevelAlarmState,
        lastChannelOutputLevelAlarmState:
            state.lastChannelOutputLevelAlarmState,
      ),
    ));
  }

  void _onPilotFrequency2AlarmChanged(
    PilotFrequency2AlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      pilotFrequency2AlarmState: event.pilotFrequency2AlarmState,
      isInitialize: false,
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
        pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        pilotFrequency2AlarmState: event.pilotFrequency2AlarmState,
        firstChannelOutputLevelAlarmState:
            state.firstChannelOutputLevelAlarmState,
        lastChannelOutputLevelAlarmState:
            state.lastChannelOutputLevelAlarmState,
      ),
    ));
  }

  void _onFirstChannelOutputLevelAlarmChanged(
    FirstChannelOutputLevelAlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      firstChannelOutputLevelAlarmState:
          event.firstChannelOutputLevelAlarmState,
      isInitialize: false,
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
        pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        firstChannelOutputLevelAlarmState:
            event.firstChannelOutputLevelAlarmState,
        lastChannelOutputLevelAlarmState:
            state.lastChannelOutputLevelAlarmState,
      ),
    ));
  }

  void _onLastChannelOutputLevelAlarmChanged(
    LastChannelOutputLevelAlarmChanged event,
    Emitter<Setting18ThresholdState> emit,
  ) {
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      lastChannelOutputLevelAlarmState: event.lastChannelOutputLevelAlarmState,
      isInitialize: false,
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
        pilotFrequency1AlarmState: state.pilotFrequency1AlarmState,
        pilotFrequency2AlarmState: state.pilotFrequency2AlarmState,
        firstChannelOutputLevelAlarmState:
            state.firstChannelOutputLevelAlarmState,
        lastChannelOutputLevelAlarmState:
            event.lastChannelOutputLevelAlarmState,
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
    emit(state.copyWith(
      submissionStatus: SubmissionStatus.none,
      isInitialize: true,
      editMode: false,
      enableSubmission: false,
      temperatureAlarmState: state.initialValues[0],
      minTemperature: state.initialValues[1],
      maxTemperature: state.initialValues[2],
      temperatureUnit: _unitRepository.temperatureUnit,
      voltageAlarmState: state.initialValues[3],
      minVoltage: state.initialValues[4],
      maxVoltage: state.initialValues[5],
      voltageRippleAlarmState: state.initialValues[6],
      minVoltageRipple: state.initialValues[7],
      maxVoltageRipple: state.initialValues[8],
      rfOutputPowerAlarmState: state.initialValues[9],
      minRFOutputPower: state.initialValues[10],
      maxRFOutputPower: state.initialValues[11],
      splitOptionAlarmState: state.initialValues[12],
      pilotFrequency1AlarmState: state.initialValues[13],
      pilotFrequency2AlarmState: state.initialValues[14],
      firstChannelOutputLevelAlarmState: state.initialValues[15],
      lastChannelOutputLevelAlarmState: state.initialValues[16],
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
    required bool temperatureAlarmState,
    required String minTemperature,
    required String maxTemperature,
    required bool voltageAlarmState,
    required String minVoltage,
    required String maxVoltage,
    required bool voltageRippleAlarmState,
    required String minVoltageRipple,
    required String maxVoltageRipple,
    required bool rfOutputPowerAlarmState,
    required String minRFOutputPower,
    required String maxRFOutputPower,
    required bool splitOptionAlarmState,
    required bool pilotFrequency1AlarmState,
    required bool pilotFrequency2AlarmState,
    required bool firstChannelOutputLevelAlarmState,
    required bool lastChannelOutputLevelAlarmState,
  }) {
    if (temperatureAlarmState != state.initialValues[0] ||
        minTemperature != state.initialValues[1] ||
        maxTemperature != state.initialValues[2] ||
        voltageAlarmState != state.initialValues[3] ||
        minVoltage != state.initialValues[4] ||
        maxVoltage != state.initialValues[5] ||
        voltageRippleAlarmState != state.initialValues[6] ||
        minVoltageRipple != state.initialValues[7] ||
        maxVoltageRipple != state.initialValues[8] ||
        rfOutputPowerAlarmState != state.initialValues[9] ||
        minRFOutputPower != state.initialValues[10] ||
        maxRFOutputPower != state.initialValues[11] ||
        splitOptionAlarmState != state.initialValues[12] ||
        pilotFrequency1AlarmState != state.initialValues[13] ||
        pilotFrequency2AlarmState != state.initialValues[14] ||
        firstChannelOutputLevelAlarmState != state.initialValues[15] ||
        lastChannelOutputLevelAlarmState != state.initialValues[16]) {
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

    if (state.temperatureAlarmState != state.initialValues[0]) {
      String temperatureAlarmState =
          _boolToStringNumber(state.temperatureAlarmState);
      bool resultOfSetTemperatureAlarmState = await _amp18repository
          .set1p8GTemperatureAlarmState(temperatureAlarmState);

      settingResult.add(
          '${DataKey.temperatureAlarmState.name},$resultOfSetTemperatureAlarmState');
    }

    if (state.minTemperature != state.initialValues[1]) {
      String minTemperature = state.minTemperature;
      if (state.temperatureUnit == TemperatureUnit.fahrenheit) {
        minTemperature = _unitRepository
            .convertStrFahrenheitToCelcius(minTemperature)
            .toStringAsFixed(1);
      }

      bool resultOfSetMinTemperature =
          await _amp18repository.set1p8GMinTemperature(minTemperature);

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
          await _amp18repository.set1p8GMaxTemperature(maxTemperature);

      settingResult
          .add('${DataKey.maxTemperatureC.name},$resultOfSetMaxTemperature');
    }

    if (state.voltageAlarmState != state.initialValues[3]) {
      String voltageAlarmState = _boolToStringNumber(state.voltageAlarmState);
      bool resultOfSetVoltageAlarmState =
          await _amp18repository.set1p8GVoltageAlarmState(voltageAlarmState);

      settingResult.add(
          '${DataKey.voltageAlarmState.name},$resultOfSetVoltageAlarmState');
    }

    if (state.minVoltage != state.initialValues[4]) {
      bool resultOfSetMinVoltage =
          await _amp18repository.set1p8GMinVoltage(state.minVoltage);

      settingResult.add('${DataKey.minVoltage.name},$resultOfSetMinVoltage');
    }

    if (state.maxVoltage != state.initialValues[5]) {
      bool resultOfSetMaxVoltage =
          await _amp18repository.set1p8GMaxVoltage(state.maxVoltage);

      settingResult.add('${DataKey.maxVoltage.name},$resultOfSetMaxVoltage');
    }

    if (state.voltageRippleAlarmState != state.initialValues[6]) {
      String voltageRippleAlarmState =
          _boolToStringNumber(state.voltageRippleAlarmState);
      bool resultOfSetVoltageRippleAlarmState = await _amp18repository
          .set1p8GVoltageRippleAlarmState(voltageRippleAlarmState);

      settingResult.add(
          '${DataKey.voltageRippleAlarmState.name},$resultOfSetVoltageRippleAlarmState');
    }

    if (state.minVoltageRipple != state.initialValues[7]) {
      bool resultOfSetMinVoltageRipple = await _amp18repository
          .set1p8GMinVoltageRipple(state.minVoltageRipple);

      settingResult
          .add('${DataKey.minVoltageRipple.name},$resultOfSetMinVoltageRipple');
    }

    if (state.maxVoltageRipple != state.initialValues[8]) {
      bool resultOfSetMaxVoltageRipple = await _amp18repository
          .set1p8GMaxVoltageRipple(state.maxVoltageRipple);

      settingResult
          .add('${DataKey.maxVoltageRipple.name},$resultOfSetMaxVoltageRipple');
    }

    if (state.rfOutputPowerAlarmState != state.initialValues[9]) {
      String voltageRFOutputPowerAlarmState =
          _boolToStringNumber(state.rfOutputPowerAlarmState);
      bool resultOfSetRFOutputPowerAlarmState = await _amp18repository
          .set1p8GRFOutputPowerAlarmState(voltageRFOutputPowerAlarmState);

      settingResult.add(
          '${DataKey.rfOutputPowerAlarmState.name},$resultOfSetRFOutputPowerAlarmState');
    }

    if (state.minRFOutputPower != state.initialValues[10]) {
      bool resultOfSetMinRFOutputPower = await _amp18repository
          .set1p8GMinRFOutputPower(state.minRFOutputPower);

      settingResult
          .add('${DataKey.minRFOutputPower.name},$resultOfSetMinRFOutputPower');
    }

    if (state.maxRFOutputPower != state.initialValues[11]) {
      bool resultOfSetMaxRFOutputPower = await _amp18repository
          .set1p8GMaxRFOutputPower(state.maxRFOutputPower);

      settingResult
          .add('${DataKey.maxRFOutputPower.name},$resultOfSetMaxRFOutputPower');
    }

    if (state.splitOptionAlarmState != state.initialValues[12]) {
      String splitOptionAlarmState =
          _boolToStringNumber(state.splitOptionAlarmState);
      bool resultOfSetSplitOptionAlarmState = await _amp18repository
          .set1p8GSplitOptionAlarmState(splitOptionAlarmState);

      settingResult.add(
          '${DataKey.splitOptionAlarmState.name},$resultOfSetSplitOptionAlarmState');
    }

    if (state.pilotFrequency1AlarmState != state.initialValues[13]) {
      String voltagePilotFrequency1AlarmState =
          _boolToStringNumber(state.pilotFrequency1AlarmState);
      bool resultOfSetPilotFrequency1AlarmState =
          await _amp18repository.setInputPilotLowFrequencyAlarmState(
              voltagePilotFrequency1AlarmState);

      settingResult.add(
          '${DataKey.pilotFrequency1AlarmState.name},$resultOfSetPilotFrequency1AlarmState');
    }

    if (state.pilotFrequency2AlarmState != state.initialValues[14]) {
      String pilotFrequency2AlarmState =
          _boolToStringNumber(state.pilotFrequency2AlarmState);
      bool resultOfSetPilotFrequency2AlarmState = await _amp18repository
          .setInputPilotHighFrequencyAlarmState(pilotFrequency2AlarmState);

      settingResult.add(
          '${DataKey.pilotFrequency2AlarmState.name},$resultOfSetPilotFrequency2AlarmState');
    }

    // 等待 device 完成更新後在讀取值
    await Future.delayed(const Duration(milliseconds: 1000));

    emit(state.copyWith(
      submissionStatus: SubmissionStatus.submissionSuccess,
      settingResult: settingResult,
      enableSubmission: false,
      editMode: false,
    ));

    await _amp18repository.updateCharacteristics();
  }
}
