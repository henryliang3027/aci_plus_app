part of 'setting18_ccor_node_threshold_bloc.dart';

class Setting18CCorNodeThresholdState extends Equatable {
  const Setting18CCorNodeThresholdState({
    this.submissionStatus = SubmissionStatus.none,
    this.temperatureAlarmState = false,
    this.minTemperature = const FloatPointInput.pure(),
    this.maxTemperature = const FloatPointInput.pure(),
    this.temperatureUnit = TemperatureUnit.fahrenheit,
    this.voltageAlarmState = false,
    this.minVoltage = const FloatPointInput.pure(),
    this.maxVoltage = const FloatPointInput.pure(),
    this.splitOptionAlarmState = false,
    this.rfOutputPower1AlarmState = false,
    this.minRFOutputPower1 = const FloatPointInput.pure(),
    this.maxRFOutputPower1 = const FloatPointInput.pure(),
    this.rfOutputPower3AlarmState = false,
    this.minRFOutputPower3 = const FloatPointInput.pure(),
    this.maxRFOutputPower3 = const FloatPointInput.pure(),
    this.rfOutputPower4AlarmState = false,
    this.minRFOutputPower4 = const FloatPointInput.pure(),
    this.maxRFOutputPower4 = const FloatPointInput.pure(),
    this.rfOutputPower6AlarmState = false,
    this.minRFOutputPower6 = const FloatPointInput.pure(),
    this.maxRFOutputPower6 = const FloatPointInput.pure(),
    this.editMode = false,
    this.enableSubmission = false,
    this.isInitialize = true,
    this.initialValues = const {},
    this.tappedSet = const {},
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
  final bool splitOptionAlarmState;
  final bool rfOutputPower1AlarmState;
  final FloatPointInput minRFOutputPower1;
  final FloatPointInput maxRFOutputPower1;
  final bool rfOutputPower3AlarmState;
  final FloatPointInput minRFOutputPower3;
  final FloatPointInput maxRFOutputPower3;
  final bool rfOutputPower4AlarmState;
  final FloatPointInput minRFOutputPower4;
  final FloatPointInput maxRFOutputPower4;
  final bool rfOutputPower6AlarmState;
  final FloatPointInput minRFOutputPower6;
  final FloatPointInput maxRFOutputPower6;
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;
  final Map<DataKey, String> initialValues;
  final Set<DataKey> tappedSet;
  final List<String> settingResult;

  Setting18CCorNodeThresholdState copyWith({
    SubmissionStatus? submissionStatus,
    bool? temperatureAlarmState,
    FloatPointInput? minTemperature,
    FloatPointInput? maxTemperature,
    TemperatureUnit? temperatureUnit,
    bool? voltageAlarmState,
    FloatPointInput? minVoltage,
    FloatPointInput? maxVoltage,
    bool? splitOptionAlarmState,
    bool? rfOutputPower1AlarmState,
    FloatPointInput? minRFOutputPower1,
    FloatPointInput? maxRFOutputPower1,
    bool? rfOutputPower3AlarmState,
    FloatPointInput? minRFOutputPower3,
    FloatPointInput? maxRFOutputPower3,
    bool? rfOutputPower4AlarmState,
    FloatPointInput? minRFOutputPower4,
    FloatPointInput? maxRFOutputPower4,
    bool? rfOutputPower6AlarmState,
    FloatPointInput? minRFOutputPower6,
    FloatPointInput? maxRFOutputPower6,
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
    Map<DataKey, String>? initialValues,
    Set<DataKey>? tappedSet,
    List<String>? settingResult,
  }) {
    return Setting18CCorNodeThresholdState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      temperatureAlarmState:
          temperatureAlarmState ?? this.temperatureAlarmState,
      minTemperature: minTemperature ?? this.minTemperature,
      maxTemperature: maxTemperature ?? this.maxTemperature,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      voltageAlarmState: voltageAlarmState ?? this.voltageAlarmState,
      minVoltage: minVoltage ?? this.minVoltage,
      maxVoltage: maxVoltage ?? this.maxVoltage,
      splitOptionAlarmState:
          splitOptionAlarmState ?? this.splitOptionAlarmState,
      rfOutputPower1AlarmState:
          rfOutputPower1AlarmState ?? this.rfOutputPower1AlarmState,
      minRFOutputPower1: minRFOutputPower1 ?? this.minRFOutputPower1,
      maxRFOutputPower1: maxRFOutputPower1 ?? this.maxRFOutputPower1,
      rfOutputPower3AlarmState:
          rfOutputPower3AlarmState ?? this.rfOutputPower3AlarmState,
      minRFOutputPower3: minRFOutputPower3 ?? this.minRFOutputPower3,
      maxRFOutputPower3: maxRFOutputPower3 ?? this.maxRFOutputPower3,
      rfOutputPower4AlarmState:
          rfOutputPower4AlarmState ?? this.rfOutputPower4AlarmState,
      minRFOutputPower4: minRFOutputPower4 ?? this.minRFOutputPower4,
      maxRFOutputPower4: maxRFOutputPower4 ?? this.maxRFOutputPower4,
      rfOutputPower6AlarmState:
          rfOutputPower6AlarmState ?? this.rfOutputPower6AlarmState,
      minRFOutputPower6: minRFOutputPower6 ?? this.minRFOutputPower6,
      maxRFOutputPower6: maxRFOutputPower6 ?? this.maxRFOutputPower6,
      editMode: editMode ?? this.editMode,
      enableSubmission: enableSubmission ?? this.enableSubmission,
      isInitialize: isInitialize ?? this.isInitialize,
      initialValues: initialValues ?? this.initialValues,
      tappedSet: tappedSet ?? this.tappedSet,
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
        splitOptionAlarmState,
        rfOutputPower1AlarmState,
        minRFOutputPower1,
        maxRFOutputPower1,
        rfOutputPower3AlarmState,
        minRFOutputPower3,
        maxRFOutputPower3,
        rfOutputPower4AlarmState,
        minRFOutputPower4,
        maxRFOutputPower4,
        rfOutputPower6AlarmState,
        minRFOutputPower6,
        maxRFOutputPower6,
        editMode,
        enableSubmission,
        isInitialize,
        initialValues,
        tappedSet,
        settingResult,
      ];
}
