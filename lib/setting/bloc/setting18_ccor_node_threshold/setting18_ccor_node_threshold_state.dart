part of 'setting18_ccor_node_threshold_bloc.dart';

class Setting18CCorNodeThresholdState extends Equatable {
  const Setting18CCorNodeThresholdState({
    this.submissionStatus = SubmissionStatus.none,
    this.temperatureAlarmState = false,
    this.minTemperature = '',
    this.maxTemperature = '',
    this.temperatureUnit = TemperatureUnit.fahrenheit,
    this.voltageAlarmState = false,
    this.minVoltage = '',
    this.maxVoltage = '',
    this.splitOptionAlarmState = false,
    this.rfOutputPower1AlarmState = false,
    this.minRFOutputPower1 = '',
    this.maxRFOutputPower1 = '',
    this.rfOutputPower3AlarmState = false,
    this.minRFOutputPower3 = '',
    this.maxRFOutputPower3 = '',
    this.rfOutputPower4AlarmState = false,
    this.minRFOutputPower4 = '',
    this.maxRFOutputPower4 = '',
    this.rfOutputPower6AlarmState = false,
    this.minRFOutputPower6 = '',
    this.maxRFOutputPower6 = '',
    this.editMode = false,
    this.enableSubmission = false,
    this.isInitialize = true,
    this.initialValues = const [],
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;
  final bool temperatureAlarmState;
  final String minTemperature;
  final String maxTemperature;
  final TemperatureUnit temperatureUnit;
  final bool voltageAlarmState;
  final String minVoltage;
  final String maxVoltage;
  final bool splitOptionAlarmState;
  final bool rfOutputPower1AlarmState;
  final String minRFOutputPower1;
  final String maxRFOutputPower1;
  final bool rfOutputPower3AlarmState;
  final String minRFOutputPower3;
  final String maxRFOutputPower3;
  final bool rfOutputPower4AlarmState;
  final String minRFOutputPower4;
  final String maxRFOutputPower4;
  final bool rfOutputPower6AlarmState;
  final String minRFOutputPower6;
  final String maxRFOutputPower6;
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;
  final List<dynamic> initialValues;
  final List<String> settingResult;

  Setting18CCorNodeThresholdState copyWith({
    SubmissionStatus? submissionStatus,
    bool? temperatureAlarmState,
    String? minTemperature,
    String? maxTemperature,
    TemperatureUnit? temperatureUnit,
    bool? voltageAlarmState,
    String? minVoltage,
    String? maxVoltage,
    bool? splitOptionAlarmState,
    bool? rfOutputPower1AlarmState,
    String? minRFOutputPower1,
    String? maxRFOutputPower1,
    bool? rfOutputPower3AlarmState,
    String? minRFOutputPower3,
    String? maxRFOutputPower3,
    bool? rfOutputPower4AlarmState,
    String? minRFOutputPower4,
    String? maxRFOutputPower4,
    bool? rfOutputPower6AlarmState,
    String? minRFOutputPower6,
    String? maxRFOutputPower6,
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
    List<dynamic>? initialValues,
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
        settingResult,
      ];
}
