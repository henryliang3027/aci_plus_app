part of 'setting18_ccor_node_regulation_bloc.dart';

class Setting18CCorNodeRegulationEvent extends Equatable {
  const Setting18CCorNodeRegulationEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18CCorNodeRegulationEvent {
  const Initialized();

  @override
  List<Object> get props => [];
}

class ForwardConfigChanged extends Setting18CCorNodeRegulationEvent {
  const ForwardConfigChanged(this.forwardConfig);

  final String forwardConfig;

  @override
  List<Object> get props => [forwardConfig];
}

class SplitOptionChanged extends Setting18CCorNodeRegulationEvent {
  const SplitOptionChanged(this.splitOption);

  final String splitOption;

  @override
  List<Object> get props => [splitOption];
}

class ForwardModeChanged extends Setting18CCorNodeRegulationEvent {
  const ForwardModeChanged(this.forwardMode);

  final String forwardMode;

  @override
  List<Object> get props => [forwardMode];
}

class LogIntervalChanged extends Setting18CCorNodeRegulationEvent {
  const LogIntervalChanged(this.logInterval);

  final String logInterval;

  @override
  List<Object> get props => [logInterval];
}

class EditModeEnabled extends Setting18CCorNodeRegulationEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends Setting18CCorNodeRegulationEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends Setting18CCorNodeRegulationEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}
