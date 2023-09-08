part of 'setting18_threshold_bloc.dart';

class Setting18ThresholdState extends Equatable {
  const Setting18ThresholdState({
    this.submissionStatus = SubmissionStatus.none,
    this.enableTemperatureAlarm = false,
    this.minTemperature = '',
    this.maxTemperature = '',
    this.temperatureUnit = TemperatureUnit.fahrenheit,
    this.enableVoltageAlarm = false,
    this.minVoltage = '',
    this.maxVoltage = '',
    this.enableVoltageRippleAlarm = false,
    this.minVoltageRipple = '',
    this.maxVoltageRipple = '',
    this.enableRFOutputPowerAlarm = false,
    this.minRFOutputPower = '',
    this.maxRFOutputPower = '',
    this.enablePilotFrequency1Alarm = false,
    this.enablePilotFrequency2Alarm = false,
    this.enableFirstChannelOutputLevelAlarm = false,
    this.enableLastChannelOutputLevelAlarm = false,
    this.editMode = false,
    this.enableSubmission = false,
    this.isInitialize = true,
    this.initialValues = const [],
    this.settingResult = const [],
  });

  final SubmissionStatus submissionStatus;

  final bool enableTemperatureAlarm;
  final String minTemperature;
  final String maxTemperature;
  final TemperatureUnit temperatureUnit;
  final bool enableVoltageAlarm;
  final String minVoltage;
  final String maxVoltage;
  final bool enableVoltageRippleAlarm;
  final String minVoltageRipple;
  final String maxVoltageRipple;
  final bool enableRFOutputPowerAlarm;
  final String minRFOutputPower;
  final String maxRFOutputPower;
  final bool enablePilotFrequency1Alarm;
  final bool enablePilotFrequency2Alarm;
  final bool enableFirstChannelOutputLevelAlarm;
  final bool enableLastChannelOutputLevelAlarm;
  final bool editMode;
  final bool enableSubmission;
  final bool isInitialize;
  final List<dynamic> initialValues;
  final List<String> settingResult;

  Setting18ThresholdState copyWith({
    SubmissionStatus? submissionStatus,
    bool? enableTemperatureAlarm,
    String? minTemperature,
    String? maxTemperature,
    TemperatureUnit? temperatureUnit,
    bool? enableVoltageAlarm,
    String? minVoltage,
    String? maxVoltage,
    bool? enableVoltageRippleAlarm,
    String? minVoltageRipple,
    String? maxVoltageRipple,
    bool? enableRFOutputPowerAlarm,
    String? minRFOutputPower,
    String? maxRFOutputPower,
    bool? enablePilotFrequency1Alarm,
    bool? enablePilotFrequency2Alarm,
    bool? enableFirstChannelOutputLevelAlarm,
    bool? enableLastChannelOutputLevelAlarm,
    bool? editMode,
    bool? enableSubmission,
    bool? isInitialize,
    List<dynamic>? initialValues,
    List<String>? settingResult,
  }) {
    return Setting18ThresholdState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      enableTemperatureAlarm:
          enableTemperatureAlarm ?? this.enableTemperatureAlarm,
      minTemperature: minTemperature ?? this.minTemperature,
      maxTemperature: maxTemperature ?? this.maxTemperature,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      enableVoltageAlarm: enableVoltageAlarm ?? this.enableVoltageAlarm,
      minVoltage: minVoltage ?? this.minVoltage,
      maxVoltage: maxVoltage ?? this.maxVoltage,
      enableVoltageRippleAlarm:
          enableVoltageRippleAlarm ?? this.enableVoltageRippleAlarm,
      minVoltageRipple: minVoltageRipple ?? this.minVoltageRipple,
      maxVoltageRipple: maxVoltageRipple ?? this.maxVoltageRipple,
      enableRFOutputPowerAlarm:
          enableRFOutputPowerAlarm ?? this.enableRFOutputPowerAlarm,
      minRFOutputPower: minRFOutputPower ?? this.minRFOutputPower,
      maxRFOutputPower: maxRFOutputPower ?? this.maxRFOutputPower,
      enablePilotFrequency1Alarm:
          enablePilotFrequency1Alarm ?? this.enablePilotFrequency1Alarm,
      enablePilotFrequency2Alarm:
          enablePilotFrequency2Alarm ?? this.enablePilotFrequency2Alarm,
      enableFirstChannelOutputLevelAlarm: enableFirstChannelOutputLevelAlarm ??
          this.enableFirstChannelOutputLevelAlarm,
      enableLastChannelOutputLevelAlarm: enableLastChannelOutputLevelAlarm ??
          this.enableLastChannelOutputLevelAlarm,
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
        enableTemperatureAlarm,
        minTemperature,
        maxTemperature,
        temperatureUnit,
        enableVoltageAlarm,
        minVoltage,
        maxVoltage,
        enableVoltageRippleAlarm,
        minVoltageRipple,
        maxVoltageRipple,
        enableRFOutputPowerAlarm,
        minRFOutputPower,
        maxRFOutputPower,
        enablePilotFrequency1Alarm,
        enablePilotFrequency2Alarm,
        enableFirstChannelOutputLevelAlarm,
        enableLastChannelOutputLevelAlarm,
        editMode,
        enableSubmission,
        isInitialize,
        initialValues,
        settingResult,
      ];
}
