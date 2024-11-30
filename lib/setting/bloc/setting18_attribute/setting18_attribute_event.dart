part of 'setting18_attribute_bloc.dart';

class Setting18AttributeEvent extends Equatable {
  const Setting18AttributeEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18AttributeEvent {
  const Initialized({this.useCache = true});

  final bool useCache;

  @override
  List<Object> get props => [];
}

class LocationChanged extends Setting18AttributeEvent {
  const LocationChanged(this.location);

  final String location;

  @override
  List<Object> get props => [location];
}

class CoordinatesChanged extends Setting18AttributeEvent {
  const CoordinatesChanged(this.coordinates);

  final String coordinates;

  @override
  List<Object> get props => [coordinates];
}

class GPSCoordinatesRequested extends Setting18AttributeEvent {
  const GPSCoordinatesRequested();

  @override
  List<Object> get props => [];
}

class InputSignalLevelChanged extends Setting18AttributeEvent {
  const InputSignalLevelChanged(this.inputSignalLevel);

  final String inputSignalLevel;

  @override
  List<Object> get props => [inputSignalLevel];
}

class CascadePositionChanged extends Setting18AttributeEvent {
  const CascadePositionChanged(this.cascadePosition);

  final String cascadePosition;

  @override
  List<Object> get props => [cascadePosition];
}

class DeviceNameChanged extends Setting18AttributeEvent {
  const DeviceNameChanged(this.deviceName);

  final String deviceName;

  @override
  List<Object> get props => [deviceName];
}

class DeviceNoteChanged extends Setting18AttributeEvent {
  const DeviceNoteChanged(this.deviceNote);

  final String deviceNote;

  @override
  List<Object> get props => [deviceNote];
}

class EditModeEnabled extends Setting18AttributeEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends Setting18AttributeEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends Setting18AttributeEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}
