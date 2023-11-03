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
    this.rfOutputPowerAlarmState1 = false,
    this.minRFOutputPower1 = '',
    this.maxRFOutputPower1 = '',
    this.outputAttenuation1 = '',
    this.outputEqualizer1 = '',
    this.rfOutputPowerAlarmState3 = false,
    this.minRFOutputPower3 = '',
    this.maxRFOutputPower3 = '',
    this.outputAttenuation3 = '',
    this.outputEqualizer3 = '',
    this.rfOutputPowerAlarmState4 = false,
    this.minRFOutputPower4 = '',
    this.maxRFOutputPower4 = '',
    this.outputAttenuation4 = '',
    this.outputEqualizer4 = '',
    this.rfOutputPowerAlarmState6 = false,
    this.minRFOutputPower6 = '',
    this.maxRFOutputPower6 = '',
    this.outputAttenuation6 = '',
    this.outputEqualizer6 = '',
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
  final bool rfOutputPowerAlarmState1;
  final String minRFOutputPower1;
  final String maxRFOutputPower1;
  final String outputAttenuation1;
  final String outputEqualizer1;
  final bool rfOutputPowerAlarmState3;
  final String minRFOutputPower3;
  final String maxRFOutputPower3;
  final String outputAttenuation3;
  final String outputEqualizer3;
  final bool rfOutputPowerAlarmState4;
  final String minRFOutputPower4;
  final String maxRFOutputPower4;
  final String outputAttenuation4;
  final String outputEqualizer4;
  final bool rfOutputPowerAlarmState6;
  final String minRFOutputPower6;
  final String maxRFOutputPower6;
  final String outputAttenuation6;
  final String outputEqualizer6;
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
    bool? rfOutputPowerAlarmState1,
    String? minRFOutputPower1,
    String? maxRFOutputPower1,
    String? outputAttenuation1,
    String? outputEqualizer1,
    bool? rfOutputPowerAlarmState3,
    String? minRFOutputPower3,
    String? maxRFOutputPower3,
    String? outputAttenuation3,
    String? outputEqualizer3,
    bool? rfOutputPowerAlarmState4,
    String? minRFOutputPower4,
    String? maxRFOutputPower4,
    String? outputAttenuation4,
    String? outputEqualizer4,
    bool? rfOutputPowerAlarmState6,
    String? minRFOutputPower6,
    String? maxRFOutputPower6,
    String? outputAttenuation6,
    String? outputEqualizer6,
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
      rfOutputPowerAlarmState1:
          rfOutputPowerAlarmState1 ?? this.rfOutputPowerAlarmState1,
      minRFOutputPower1: minRFOutputPower1 ?? this.minRFOutputPower1,
      maxRFOutputPower1: maxRFOutputPower1 ?? this.maxRFOutputPower1,
      outputAttenuation1: outputAttenuation1 ?? this.outputAttenuation1,
      outputEqualizer1: outputEqualizer1 ?? this.outputEqualizer1,
      rfOutputPowerAlarmState3:
          rfOutputPowerAlarmState1 ?? this.rfOutputPowerAlarmState3,
      minRFOutputPower3: minRFOutputPower3 ?? this.minRFOutputPower3,
      maxRFOutputPower3: maxRFOutputPower3 ?? this.maxRFOutputPower3,
      outputAttenuation3: outputAttenuation3 ?? this.outputAttenuation3,
      outputEqualizer3: outputEqualizer3 ?? this.outputEqualizer3,
      rfOutputPowerAlarmState4:
          rfOutputPowerAlarmState4 ?? this.rfOutputPowerAlarmState4,
      minRFOutputPower4: minRFOutputPower4 ?? this.minRFOutputPower4,
      maxRFOutputPower4: maxRFOutputPower4 ?? this.maxRFOutputPower4,
      outputAttenuation4: outputAttenuation4 ?? this.outputAttenuation4,
      outputEqualizer4: outputEqualizer4 ?? this.outputEqualizer4,
      rfOutputPowerAlarmState6:
          rfOutputPowerAlarmState6 ?? this.rfOutputPowerAlarmState6,
      minRFOutputPower6: minRFOutputPower6 ?? this.minRFOutputPower6,
      maxRFOutputPower6: maxRFOutputPower6 ?? this.maxRFOutputPower6,
      outputAttenuation6: outputAttenuation6 ?? this.outputAttenuation6,
      outputEqualizer6: outputEqualizer6 ?? this.outputEqualizer6,
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
        rfOutputPowerAlarmState1,
        minRFOutputPower1,
        maxRFOutputPower1,
        outputAttenuation1,
        outputEqualizer1,
        rfOutputPowerAlarmState3,
        minRFOutputPower3,
        maxRFOutputPower3,
        outputAttenuation3,
        outputEqualizer3,
        rfOutputPowerAlarmState4,
        minRFOutputPower4,
        maxRFOutputPower4,
        outputAttenuation4,
        outputEqualizer4,
        rfOutputPowerAlarmState6,
        minRFOutputPower6,
        maxRFOutputPower6,
        outputAttenuation6,
        outputEqualizer6,
        editMode,
        enableSubmission,
        isInitialize,
        initialValues,
        settingResult,
      ];
}
