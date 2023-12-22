part of 'setting18_threshold_bloc.dart';

class Setting18ThresholdState extends Equatable {
  const Setting18ThresholdState({
    this.submissionStatus = SubmissionStatus.none,
    this.temperatureAlarmState = false,
    this.minTemperature = const FloatPointInput.pure(),
    this.maxTemperature = const FloatPointInput.pure(),
    this.temperatureUnit = TemperatureUnit.fahrenheit,
    this.voltageAlarmState = false,
    this.minVoltage = const FloatPointInput.pure(),
    this.maxVoltage = const FloatPointInput.pure(),
    this.voltageRippleAlarmState = false,
    this.minVoltageRipple = const IntegerInput.pure(),
    this.maxVoltageRipple = const IntegerInput.pure(),
    this.rfOutputPowerAlarmState = false,
    this.minRFOutputPower = const FloatPointInput.pure(),
    this.maxRFOutputPower = const FloatPointInput.pure(),
    this.splitOptionAlarmState = false,
    // this.pilotFrequency1AlarmState = false,
    // this.pilotFrequency2AlarmState = false,
    this.startFrequencyOutputLevelAlarmState = false,
    this.stopFrequencyOutputLevelAlarmState = false,
    this.editMode = false,
    this.enableSubmission = false,
    this.isInitialize = true,
    this.initialValues = const {},
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;

  final bool temperatureAlarmState;
  final FloatPointInput minTemperature;
  final FloatPointInput maxTemperature;
  final TemperatureUnit temperatureUnit;
  final bool voltageAlarmState;
  final FloatPointInput minVoltage;
  final FloatPointInput maxVoltage;
  final bool voltageRippleAlarmState;
  final IntegerInput minVoltageRipple;
  final IntegerInput maxVoltageRipple;
  final bool rfOutputPowerAlarmState;
  final FloatPointInput minRFOutputPower;
  final FloatPointInput maxRFOutputPower;
  final bool splitOptionAlarmState;
  // final bool pilotFrequency1AlarmState;
  // final bool pilotFrequency2AlarmState;
  final bool startFrequencyOutputLevelAlarmState;
  final bool stopFrequencyOutputLevelAlarmState;
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;
  final Map<DataKey, String> initialValues;
  final List<String> settingResult;

  Setting18ThresholdState copyWith({
    SubmissionStatus? submissionStatus,
    bool? temperatureAlarmState,
    FloatPointInput? minTemperature,
    FloatPointInput? maxTemperature,
    TemperatureUnit? temperatureUnit,
    bool? voltageAlarmState,
    FloatPointInput? minVoltage,
    FloatPointInput? maxVoltage,
    bool? voltageRippleAlarmState,
    IntegerInput? minVoltageRipple,
    IntegerInput? maxVoltageRipple,
    bool? rfOutputPowerAlarmState,
    FloatPointInput? minRFOutputPower,
    FloatPointInput? maxRFOutputPower,
    bool? splitOptionAlarmState,
    // bool? pilotFrequency1AlarmState,
    // bool? pilotFrequency2AlarmState,
    bool? startFrequencyOutputLevelAlarmState,
    bool? stopFrequencyOutputLevelAlarmState,
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
    Map<DataKey, String>? initialValues,
    List<String>? settingResult,
  }) {
    return Setting18ThresholdState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      temperatureAlarmState:
          temperatureAlarmState ?? this.temperatureAlarmState,
      minTemperature: minTemperature ?? this.minTemperature,
      maxTemperature: maxTemperature ?? this.maxTemperature,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      voltageAlarmState: voltageAlarmState ?? this.voltageAlarmState,
      minVoltage: minVoltage ?? this.minVoltage,
      maxVoltage: maxVoltage ?? this.maxVoltage,
      voltageRippleAlarmState:
          voltageRippleAlarmState ?? this.voltageRippleAlarmState,
      minVoltageRipple: minVoltageRipple ?? this.minVoltageRipple,
      maxVoltageRipple: maxVoltageRipple ?? this.maxVoltageRipple,
      rfOutputPowerAlarmState:
          rfOutputPowerAlarmState ?? this.rfOutputPowerAlarmState,
      minRFOutputPower: minRFOutputPower ?? this.minRFOutputPower,
      maxRFOutputPower: maxRFOutputPower ?? this.maxRFOutputPower,
      splitOptionAlarmState:
          splitOptionAlarmState ?? this.splitOptionAlarmState,
      // pilotFrequency1AlarmState:
      //     pilotFrequency1AlarmState ?? this.pilotFrequency1AlarmState,
      // pilotFrequency2AlarmState:
      //     pilotFrequency2AlarmState ?? this.pilotFrequency2AlarmState,
      startFrequencyOutputLevelAlarmState:
          startFrequencyOutputLevelAlarmState ??
              this.startFrequencyOutputLevelAlarmState,
      stopFrequencyOutputLevelAlarmState: stopFrequencyOutputLevelAlarmState ??
          this.stopFrequencyOutputLevelAlarmState,
      editMode: editMode ?? this.editMode,
      enableSubmission: enableSubmission ?? this.enableSubmission,
      isInitialize: isInitialize ?? this.isInitialize,
      initialValues: initialValues ?? this.initialValues,
      settingResult: settingResult ?? this.settingResult,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
        temperatureAlarmState,
        minTemperature,
        maxTemperature,
        temperatureUnit,
        voltageAlarmState,
        minVoltage,
        maxVoltage,
        voltageRippleAlarmState,
        minVoltageRipple,
        maxVoltageRipple,
        rfOutputPowerAlarmState,
        minRFOutputPower,
        maxRFOutputPower,
        splitOptionAlarmState,
        // pilotFrequency1AlarmState,
        // pilotFrequency2AlarmState,
        startFrequencyOutputLevelAlarmState,
        stopFrequencyOutputLevelAlarmState,
        editMode,
        enableSubmission,
        isInitialize,
        initialValues,
        settingResult,
      ];
}
