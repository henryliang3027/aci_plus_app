part of 'setting18_ccor_node_threshold_bloc.dart';

sealed class Setting18CCorNodeThresholdEvent extends Equatable {
  const Setting18CCorNodeThresholdEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18CCorNodeThresholdEvent {
  const Initialized({
    required this.temperatureAlarmState,
    required this.minTemperature,
    required this.maxTemperature,
    required this.minTemperatureF,
    required this.maxTemperatureF,
    required this.voltageAlarmState,
    required this.minVoltage,
    required this.maxVoltage,
    required this.splitOptionAlarmState,
    required this.rfOutputPowerAlarmState1,
    required this.minRFOutputPower1,
    required this.maxRFOutputPower1,
    required this.rfOutputPowerAlarmState3,
    required this.minRFOutputPower3,
    required this.maxRFOutputPower3,
    required this.rfOutputPowerAlarmState4,
    required this.minRFOutputPower4,
    required this.maxRFOutputPower4,
    required this.rfOutputPowerAlarmState6,
    required this.minRFOutputPower6,
    required this.maxRFOutputPower6,
  });

  final bool temperatureAlarmState;
  final String minTemperature;
  final String maxTemperature;
  final String minTemperatureF;
  final String maxTemperatureF;
  final bool voltageAlarmState;
  final String minVoltage;
  final String maxVoltage;
  final bool splitOptionAlarmState;
  final bool rfOutputPowerAlarmState1;
  final String minRFOutputPower1;
  final String maxRFOutputPower1;
  final bool rfOutputPowerAlarmState3;
  final String minRFOutputPower3;
  final String maxRFOutputPower3;
  final bool rfOutputPowerAlarmState4;
  final String minRFOutputPower4;
  final String maxRFOutputPower4;
  final bool rfOutputPowerAlarmState6;
  final String minRFOutputPower6;
  final String maxRFOutputPower6;

  @override
  List<Object> get props => [
        temperatureAlarmState,
        minTemperature,
        maxTemperature,
        minTemperatureF,
        maxTemperatureF,
        voltageAlarmState,
        minVoltage,
        maxVoltage,
        splitOptionAlarmState,
        rfOutputPowerAlarmState1,
        minRFOutputPower1,
        maxRFOutputPower1,
        rfOutputPowerAlarmState3,
        minRFOutputPower3,
        maxRFOutputPower3,
        rfOutputPowerAlarmState4,
        minRFOutputPower4,
        maxRFOutputPower4,
        rfOutputPowerAlarmState6,
        minRFOutputPower6,
        maxRFOutputPower6,
      ];
}

class TemperatureAlarmChanged extends Setting18CCorNodeThresholdEvent {
  const TemperatureAlarmChanged(this.temperatureAlarmState);

  final bool temperatureAlarmState;

  @override
  List<Object> get props => [temperatureAlarmState];
}

class MinTemperatureChanged extends Setting18CCorNodeThresholdEvent {
  const MinTemperatureChanged(this.minTemperature);

  final String minTemperature;

  @override
  List<Object> get props => [minTemperature];
}

class MaxTemperatureChanged extends Setting18CCorNodeThresholdEvent {
  const MaxTemperatureChanged(this.maxTemperature);

  final String maxTemperature;

  @override
  List<Object> get props => [maxTemperature];
}

class VoltageAlarmChanged extends Setting18CCorNodeThresholdEvent {
  const VoltageAlarmChanged(this.voltageAlarmState);

  final bool voltageAlarmState;

  @override
  List<Object> get props => [voltageAlarmState];
}

class MinVoltageChanged extends Setting18CCorNodeThresholdEvent {
  const MinVoltageChanged(this.minVoltage);

  final String minVoltage;

  @override
  List<Object> get props => [minVoltage];
}

class MaxVoltageChanged extends Setting18CCorNodeThresholdEvent {
  const MaxVoltageChanged(this.maxVoltage);

  final String maxVoltage;

  @override
  List<Object> get props => [maxVoltage];
}

class SplitOptionAlarmChanged extends Setting18CCorNodeThresholdEvent {
  const SplitOptionAlarmChanged(this.splitOptionAlarmState);

  final bool splitOptionAlarmState;

  @override
  List<Object> get props => [splitOptionAlarmState];
}

// port 1
class RFOutputPowerAlarmState1Changed extends Setting18CCorNodeThresholdEvent {
  const RFOutputPowerAlarmState1Changed(this.rfOutputPowerAlarmState1);

  final bool rfOutputPowerAlarmState1;

  @override
  List<Object> get props => [rfOutputPowerAlarmState1];
}

class MinRFOutputPower1Changed extends Setting18CCorNodeThresholdEvent {
  const MinRFOutputPower1Changed(this.minRFOutputPower1);

  final String minRFOutputPower1;

  @override
  List<Object> get props => [minRFOutputPower1];
}

class MaxRFOutputPower1Changed extends Setting18CCorNodeThresholdEvent {
  const MaxRFOutputPower1Changed(this.maxRFOutputPower1);

  final String maxRFOutputPower1;

  @override
  List<Object> get props => [maxRFOutputPower1];
}
// port 1

// port 3
class RFOutputPowerAlarmState3Changed extends Setting18CCorNodeThresholdEvent {
  const RFOutputPowerAlarmState3Changed(this.rfOutputPowerAlarmState3);

  final bool rfOutputPowerAlarmState3;

  @override
  List<Object> get props => [rfOutputPowerAlarmState3];
}

class MinRFOutputPower3Changed extends Setting18CCorNodeThresholdEvent {
  const MinRFOutputPower3Changed(this.minRFOutputPower3);

  final String minRFOutputPower3;

  @override
  List<Object> get props => [minRFOutputPower3];
}

class MaxRFOutputPower3Changed extends Setting18CCorNodeThresholdEvent {
  const MaxRFOutputPower3Changed(this.maxRFOutputPower3);

  final String maxRFOutputPower3;

  @override
  List<Object> get props => [maxRFOutputPower3];
}
// port 3

// port 4
class RFOutputPowerAlarmState4Changed extends Setting18CCorNodeThresholdEvent {
  const RFOutputPowerAlarmState4Changed(this.rfOutputPowerAlarmState4);

  final bool rfOutputPowerAlarmState4;

  @override
  List<Object> get props => [rfOutputPowerAlarmState4];
}

class MinRFOutputPower4Changed extends Setting18CCorNodeThresholdEvent {
  const MinRFOutputPower4Changed(this.minRFOutputPower4);

  final String minRFOutputPower4;

  @override
  List<Object> get props => [minRFOutputPower4];
}

class MaxRFOutputPower4Changed extends Setting18CCorNodeThresholdEvent {
  const MaxRFOutputPower4Changed(this.maxRFOutputPower4);

  final String maxRFOutputPower4;

  @override
  List<Object> get props => [maxRFOutputPower4];
}
// port 4

// port 6
class RFOutputPowerAlarmState6Changed extends Setting18CCorNodeThresholdEvent {
  const RFOutputPowerAlarmState6Changed(this.rfOutputPowerAlarmState6);

  final bool rfOutputPowerAlarmState6;

  @override
  List<Object> get props => [rfOutputPowerAlarmState6];
}

class MinRFOutputPower6Changed extends Setting18CCorNodeThresholdEvent {
  const MinRFOutputPower6Changed(this.minRFOutputPower6);

  final String minRFOutputPower6;

  @override
  List<Object> get props => [minRFOutputPower6];
}

class MaxRFOutputPower6Changed extends Setting18CCorNodeThresholdEvent {
  const MaxRFOutputPower6Changed(this.maxRFOutputPower6);

  final String maxRFOutputPower6;

  @override
  List<Object> get props => [maxRFOutputPower6];
}
// port 6

class EditModeEnabled extends Setting18CCorNodeThresholdEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends Setting18CCorNodeThresholdEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends Setting18CCorNodeThresholdEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}
