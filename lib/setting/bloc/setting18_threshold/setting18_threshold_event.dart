part of 'setting18_threshold_bloc.dart';

sealed class Setting18ThresholdEvent extends Equatable {
  const Setting18ThresholdEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18ThresholdEvent {
  const Initialized({
    required this.enableTemperatureAlarm,
    required this.minTemperature,
    required this.maxTemperature,
    required this.enableVoltageAlarm,
    required this.minVoltage,
    required this.maxVoltage,
    required this.enableRFInputPowerAlarm,
    required this.enableRFOutputPowerAlarm,
    required this.enablePilotFrequency1Alarm,
    required this.enablePilotFrequency2Alarm,
    required this.enableFirstChannelOutputLevelAlarm,
    required this.enableLastChannelOutputLevelAlarm,
  });

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

  @override
  List<Object> get props => [
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
      ];
}

class TemperatureAlarmChanged extends Setting18ThresholdEvent {
  const TemperatureAlarmChanged(this.enableTemperatureAlarm);

  final bool enableTemperatureAlarm;

  @override
  List<Object> get props => [enableTemperatureAlarm];
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
  const VoltageAlarmChanged(this.enableVoltageAlarm);

  final bool enableVoltageAlarm;

  @override
  List<Object> get props => [enableVoltageAlarm];
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

class RFInputPowerAlarmChanged extends Setting18ThresholdEvent {
  const RFInputPowerAlarmChanged(this.enableRFInputPowerAlarm);

  final bool enableRFInputPowerAlarm;

  @override
  List<Object> get props => [enableRFInputPowerAlarm];
}

class RFOutputPowerAlarmChanged extends Setting18ThresholdEvent {
  const RFOutputPowerAlarmChanged(this.enableRFOutputPowerAlarm);

  final bool enableRFOutputPowerAlarm;

  @override
  List<Object> get props => [enableRFOutputPowerAlarm];
}

class PilotFrequency1AlarmChanged extends Setting18ThresholdEvent {
  const PilotFrequency1AlarmChanged(this.enablePilotFrequency1Alarm);

  final bool enablePilotFrequency1Alarm;

  @override
  List<Object> get props => [enablePilotFrequency1Alarm];
}

class PilotFrequency2AlarmChanged extends Setting18ThresholdEvent {
  const PilotFrequency2AlarmChanged(this.enablePilotFrequency2Alarm);

  final bool enablePilotFrequency2Alarm;

  @override
  List<Object> get props => [enablePilotFrequency2Alarm];
}

class FirstChannelOutputLevelAlarmChanged extends Setting18ThresholdEvent {
  const FirstChannelOutputLevelAlarmChanged(
      this.enableFirstChannelOutputLevelAlarm);

  final bool enableFirstChannelOutputLevelAlarm;

  @override
  List<Object> get props => [enableFirstChannelOutputLevelAlarm];
}

class LastChannelOutputLevelAlarmChanged extends Setting18ThresholdEvent {
  const LastChannelOutputLevelAlarmChanged(
      this.enableLastChannelOutputLevelAlarm);

  final bool enableLastChannelOutputLevelAlarm;

  @override
  List<Object> get props => [enableLastChannelOutputLevelAlarm];
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
