part of 'setting18_threshold_bloc.dart';

class Setting18ThresholdState extends Equatable {
  const Setting18ThresholdState({
    this.submissionStatus = SubmissionStatus.none,
    this.enableTemperatureAlarm = false,
    this.minTemperature = '',
    this.maxTemperature = '',
    this.enableVoltageAlarm = false,
    this.minVoltage = '',
    this.maxVoltage = '',
    this.enableRFInputPowerAlarm = false,
    this.enableRFOutputPowerAlarm = false,
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
  final bool enableVoltageAlarm;
  final String minVoltage;
  final String maxVoltage;
  final bool enableRFInputPowerAlarm;
  final bool enableRFOutputPowerAlarm;
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
    bool? enableVoltageAlarm,
    String? minVoltage,
    String? maxVoltage,
    bool? enableRFInputPowerAlarm,
    bool? enableRFOutputPowerAlarm,
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
      enableVoltageAlarm: enableVoltageAlarm ?? this.enableVoltageAlarm,
      minVoltage: minVoltage ?? this.minVoltage,
      maxVoltage: maxVoltage ?? this.maxVoltage,
      enableRFInputPowerAlarm:
          enableRFInputPowerAlarm ?? this.enableRFInputPowerAlarm,
      enableRFOutputPowerAlarm:
          enableRFOutputPowerAlarm ?? this.enableRFOutputPowerAlarm,
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
        enableVoltageAlarm,
        minVoltage,
        maxVoltage,
        enableRFInputPowerAlarm,
        enableRFOutputPowerAlarm,
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
