part of 'setting18_threshold_bloc.dart';

sealed class Setting18ThresholdEvent extends Equatable {
  const Setting18ThresholdEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18ThresholdEvent {
  const Initialized({
    required this.temperatureAlarmState,
    required this.minTemperature,
    required this.maxTemperature,
    required this.minTemperatureF,
    required this.maxTemperatureF,
    required this.voltageAlarmState,
    required this.minVoltage,
    required this.maxVoltage,
    required this.voltageRippleAlarmState,
    required this.minVoltageRipple,
    required this.maxVoltageRipple,
    required this.rfOutputPowerAlarmState,
    required this.minRFOutputPower,
    required this.maxRFOutputPower,
    required this.splitOptionAlarmState,
    required this.pilotFrequency1AlarmState,
    required this.pilotFrequency2AlarmState,
    required this.firstChannelOutputLevelAlarmState,
    required this.lastChannelOutputLevelAlarmState,
  });

  final bool temperatureAlarmState;
  final String minTemperature;
  final String maxTemperature;
  final String minTemperatureF;
  final String maxTemperatureF;
  final bool voltageAlarmState;
  final String minVoltage;
  final String maxVoltage;
  final bool voltageRippleAlarmState;
  final String minVoltageRipple;
  final String maxVoltageRipple;
  final bool rfOutputPowerAlarmState;
  final String minRFOutputPower;
  final String maxRFOutputPower;
  final bool splitOptionAlarmState;
  final bool pilotFrequency1AlarmState;
  final bool pilotFrequency2AlarmState;
  final bool firstChannelOutputLevelAlarmState;
  final bool lastChannelOutputLevelAlarmState;

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
        voltageRippleAlarmState,
        minVoltageRipple,
        maxVoltageRipple,
        rfOutputPowerAlarmState,
        minRFOutputPower,
        maxRFOutputPower,
        splitOptionAlarmState,
        pilotFrequency1AlarmState,
        pilotFrequency2AlarmState,
        firstChannelOutputLevelAlarmState,
        lastChannelOutputLevelAlarmState,
      ];
}

class TemperatureAlarmChanged extends Setting18ThresholdEvent {
  const TemperatureAlarmChanged(this.temperatureAlarmState);

  final bool temperatureAlarmState;

  @override
  List<Object> get props => [temperatureAlarmState];
}

class MinTemperatureChanged extends Setting18ThresholdEvent {
  const MinTemperatureChanged(this.minTemperature);

  final String minTemperature;

  @override
  List<Object> get props => [minTemperature];
}

class MaxTemperatureChanged extends Setting18ThresholdEvent {
  const MaxTemperatureChanged(this.maxTemperature);

  final String maxTemperature;

  @override
  List<Object> get props => [maxTemperature];
}

class VoltageAlarmChanged extends Setting18ThresholdEvent {
  const VoltageAlarmChanged(this.voltageAlarmState);

  final bool voltageAlarmState;

  @override
  List<Object> get props => [voltageAlarmState];
}

class MinVoltageChanged extends Setting18ThresholdEvent {
  const MinVoltageChanged(this.minVoltage);

  final String minVoltage;

  @override
  List<Object> get props => [minVoltage];
}

class MaxVoltageChanged extends Setting18ThresholdEvent {
  const MaxVoltageChanged(this.maxVoltage);

  final String maxVoltage;

  @override
  List<Object> get props => [maxVoltage];
}

class VoltageRippleAlarmChanged extends Setting18ThresholdEvent {
  const VoltageRippleAlarmChanged(this.voltageRippleAlarmState);

  final bool voltageRippleAlarmState;

  @override
  List<Object> get props => [voltageRippleAlarmState];
}

class MinVoltageRippleChanged extends Setting18ThresholdEvent {
  const MinVoltageRippleChanged(this.minVoltageRipple);

  final String minVoltageRipple;

  @override
  List<Object> get props => [minVoltageRipple];
}

class MaxVoltageRippleChanged extends Setting18ThresholdEvent {
  const MaxVoltageRippleChanged(this.maxVoltageRipple);

  final String maxVoltageRipple;

  @override
  List<Object> get props => [maxVoltageRipple];
}

class RFOutputPowerAlarmChanged extends Setting18ThresholdEvent {
  const RFOutputPowerAlarmChanged(this.rfOutputPowerAlarmState);

  final bool rfOutputPowerAlarmState;

  @override
  List<Object> get props => [rfOutputPowerAlarmState];
}

class MinRFOutputPowerChanged extends Setting18ThresholdEvent {
  const MinRFOutputPowerChanged(this.minRFOutputPower);

  final String minRFOutputPower;

  @override
  List<Object> get props => [minRFOutputPower];
}

class MaxRFOutputPowerChanged extends Setting18ThresholdEvent {
  const MaxRFOutputPowerChanged(this.maxRFOutputPower);

  final String maxRFOutputPower;

  @override
  List<Object> get props => [maxRFOutputPower];
}

class SplitOptionAlarmChanged extends Setting18ThresholdEvent {
  const SplitOptionAlarmChanged(this.splitOptionAlarmState);

  final bool splitOptionAlarmState;

  @override
  List<Object> get props => [splitOptionAlarmState];
}

class PilotFrequency1AlarmChanged extends Setting18ThresholdEvent {
  const PilotFrequency1AlarmChanged(this.pilotFrequency1AlarmState);

  final bool pilotFrequency1AlarmState;

  @override
  List<Object> get props => [pilotFrequency1AlarmState];
}

class PilotFrequency2AlarmChanged extends Setting18ThresholdEvent {
  const PilotFrequency2AlarmChanged(this.pilotFrequency2AlarmState);

  final bool pilotFrequency2AlarmState;

  @override
  List<Object> get props => [pilotFrequency2AlarmState];
}

class FirstChannelOutputLevelAlarmChanged extends Setting18ThresholdEvent {
  const FirstChannelOutputLevelAlarmChanged(
      this.firstChannelOutputLevelAlarmState);

  final bool firstChannelOutputLevelAlarmState;

  @override
  List<Object> get props => [firstChannelOutputLevelAlarmState];
}

class LastChannelOutputLevelAlarmChanged extends Setting18ThresholdEvent {
  const LastChannelOutputLevelAlarmChanged(
      this.lastChannelOutputLevelAlarmState);

  final bool lastChannelOutputLevelAlarmState;

  @override
  List<Object> get props => [lastChannelOutputLevelAlarmState];
}

class EditModeEnabled extends Setting18ThresholdEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends Setting18ThresholdEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends Setting18ThresholdEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}
