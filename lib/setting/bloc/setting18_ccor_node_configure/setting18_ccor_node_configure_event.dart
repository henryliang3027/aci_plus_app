part of 'setting18_ccor_node_configure_bloc.dart';

class Setting18CCorNodeConfigureEvent extends Equatable {
  const Setting18CCorNodeConfigureEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18CCorNodeConfigureEvent {
  const Initialized({
    required this.location,
    required this.coordinates,
    required this.splitOption,
    required this.logInterval,
  });

  final String location;
  final String coordinates;
  final String splitOption;
  final String logInterval;

  @override
  List<Object> get props => [
        location,
        coordinates,
        splitOption,
        logInterval,
      ];
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

class SplitOptionChanged extends Setting18CCorNodeConfigureEvent {
  const SplitOptionChanged(this.splitOption);

  final String splitOption;

  @override
  List<Object> get props => [splitOption];
}

class LogIntervalChanged extends Setting18CCorNodeConfigureEvent {
  const LogIntervalChanged(this.logInterval);

  final String logInterval;

  @override
  List<Object> get props => [logInterval];
}

class LogIntervalIncreased extends Setting18CCorNodeConfigureEvent {
  const LogIntervalIncreased();

  @override
  List<Object> get props => [];
}

class LogIntervalDecreased extends Setting18CCorNodeConfigureEvent {
  const LogIntervalDecreased();

  @override
  List<Object> get props => [];
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
