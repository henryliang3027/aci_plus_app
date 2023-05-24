part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.status = FormStatus.none,
    this.connectionStatus = FormStatus.none,
    this.device,
    this.typeNo = '',
    this.partNo = '',
    this.location = '',
    this.dsimMode = '',
    this.currentPilot = '',
    this.logInterval = '',
    this.serialNumber = '',
    this.softwareVersion = '',
    this.alarmRServerity = '',
    this.alarmTServerity = '',
    this.alarmPServerity = '',
    this.currentAttenuation = '',
    this.minAttenuation = '',
    this.normalAttenuation = '',
    this.maxAttenuation = '',
    this.historicalMinAttenuation = '',
    this.historicalMaxAttenuation = '',
    this.currentTemperature = '',
    this.minTemperature = '',
    this.maxTemperature = '',
    this.currentVoltage = '',
    this.minVoltage = '',
    this.maxVoltage = '',
    this.currentVoltageRipple = '',
    this.minVoltageRipple = '',
    this.maxVoltageRipple = '',
    this.errorMassage = '',
  });

  final FormStatus status;
  final FormStatus connectionStatus;
  final DiscoveredDevice? device;
  final String typeNo;
  final String partNo;
  final String location;
  final String dsimMode;
  final String currentPilot;
  final String logInterval;
  final String serialNumber;
  final String softwareVersion;
  final String alarmRServerity;
  final String alarmTServerity;
  final String alarmPServerity;
  final String currentAttenuation;
  final String minAttenuation;
  final String normalAttenuation;
  final String maxAttenuation;
  final String historicalMinAttenuation;
  final String historicalMaxAttenuation;
  final String currentTemperature;
  final String minTemperature;
  final String maxTemperature;
  final String currentVoltage;
  final String minVoltage;
  final String maxVoltage;
  final String currentVoltageRipple;
  final String minVoltageRipple;
  final String maxVoltageRipple;
  final String errorMassage;

  HomeState copyWith({
    FormStatus? status,
    FormStatus? connectionStatus,
    DiscoveredDevice? device,
    String? typeNo,
    String? partNo,
    String? location,
    String? dsimMode,
    String? currentPilot,
    String? logInterval,
    String? serialNumber,
    String? softwareVersion,
    String? alarmRServerity,
    String? alarmTServerity,
    String? alarmPServerity,
    String? currentAttenuation,
    String? minAttenuation,
    String? normalAttenuation,
    String? maxAttenuation,
    String? historicalMinAttenuation,
    String? historicalMaxAttenuation,
    String? currentTemperature,
    String? minTemperature,
    String? maxTemperature,
    String? currentVoltage,
    String? minVoltage,
    String? maxVoltage,
    String? currentVoltageRipple,
    String? minVoltageRipple,
    String? maxVoltageRipple,
    String? errorMassage,
  }) {
    return HomeState(
      status: status ?? this.status,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      device: device ?? this.device,
      typeNo: typeNo ?? this.typeNo,
      partNo: partNo ?? this.partNo,
      location: location ?? this.location,
      dsimMode: dsimMode ?? this.dsimMode,
      currentPilot: currentPilot ?? this.currentPilot,
      logInterval: logInterval ?? this.logInterval,
      serialNumber: serialNumber ?? this.serialNumber,
      softwareVersion: softwareVersion ?? this.softwareVersion,
      alarmRServerity: alarmRServerity ?? this.alarmRServerity,
      alarmTServerity: alarmTServerity ?? this.alarmTServerity,
      alarmPServerity: alarmPServerity ?? this.alarmPServerity,
      currentAttenuation: currentAttenuation ?? this.currentAttenuation,
      minAttenuation: minAttenuation ?? this.minAttenuation,
      normalAttenuation: normalAttenuation ?? this.normalAttenuation,
      maxAttenuation: maxAttenuation ?? this.maxAttenuation,
      historicalMinAttenuation:
          historicalMinAttenuation ?? this.historicalMinAttenuation,
      historicalMaxAttenuation:
          historicalMaxAttenuation ?? this.historicalMaxAttenuation,
      currentTemperature: currentTemperature ?? this.currentTemperature,
      minTemperature: minTemperature ?? this.minTemperature,
      maxTemperature: maxTemperature ?? this.maxTemperature,
      currentVoltage: currentVoltage ?? this.currentVoltage,
      minVoltage: minVoltage ?? this.minVoltage,
      maxVoltage: maxVoltage ?? this.maxVoltage,
      currentVoltageRipple: currentVoltageRipple ?? this.currentVoltageRipple,
      minVoltageRipple: minVoltageRipple ?? this.minVoltageRipple,
      maxVoltageRipple: maxVoltageRipple ?? this.maxVoltageRipple,
      errorMassage: errorMassage ?? this.errorMassage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        connectionStatus,
        device,
        typeNo,
        partNo,
        location,
        dsimMode,
        currentPilot,
        logInterval,
        serialNumber,
        softwareVersion,
        alarmRServerity,
        alarmTServerity,
        alarmPServerity,
        currentAttenuation,
        minAttenuation,
        normalAttenuation,
        maxAttenuation,
        historicalMinAttenuation,
        historicalMaxAttenuation,
        currentTemperature,
        minTemperature,
        maxTemperature,
        currentVoltage,
        minVoltage,
        maxVoltage,
        currentVoltageRipple,
        minVoltageRipple,
        maxVoltageRipple,
        errorMassage,
      ];
}
