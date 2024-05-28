part of 'setting18_ccor_node_configure_bloc.dart';

class Setting18CCorNodeConfigureEvent extends Equatable {
  const Setting18CCorNodeConfigureEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18CCorNodeConfigureEvent {
  const Initialized();

  @override
  List<Object> get props => [];
}

class LocationChanged extends Setting18CCorNodeConfigureEvent {
  const LocationChanged(this.location);

  final String location;

  @override
  List<Object> get props => [location];
}

class CoordinatesChanged extends Setting18CCorNodeConfigureEvent {
  const CoordinatesChanged(this.coordinates);

  final String coordinates;

  @override
  List<Object> get props => [coordinates];
}

class GPSCoordinatesRequested extends Setting18CCorNodeConfigureEvent {
  const GPSCoordinatesRequested();

  @override
  List<Object> get props => [];
}

class ForwardConfigChanged extends Setting18CCorNodeConfigureEvent {
  const ForwardConfigChanged(this.forwardConfig);

  final String forwardConfig;

  @override
  List<Object> get props => [forwardConfig];
}

class SplitOptionChanged extends Setting18CCorNodeConfigureEvent {
  const SplitOptionChanged(this.splitOption);

  final String splitOption;

  @override
  List<Object> get props => [splitOption];
}

class ForwardModeChanged extends Setting18CCorNodeConfigureEvent {
  const ForwardModeChanged(this.forwardMode);

  final String forwardMode;

  @override
  List<Object> get props => [forwardMode];
}

class LogIntervalChanged extends Setting18CCorNodeConfigureEvent {
  const LogIntervalChanged(this.logInterval);

  final String logInterval;

  @override
  List<Object> get props => [logInterval];
}

class EditModeEnabled extends Setting18CCorNodeConfigureEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends Setting18CCorNodeConfigureEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends Setting18CCorNodeConfigureEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}
