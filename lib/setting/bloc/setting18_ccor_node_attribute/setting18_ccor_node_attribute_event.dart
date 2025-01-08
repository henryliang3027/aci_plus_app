part of 'setting18_ccor_node_attribute_bloc.dart';

class Setting18CCorNodeAttributeEvent extends Equatable {
  const Setting18CCorNodeAttributeEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18CCorNodeAttributeEvent {
  const Initialized({this.useCache = true});

  final bool useCache;

  @override
  List<Object> get props => [];
}

class LocationChanged extends Setting18CCorNodeAttributeEvent {
  const LocationChanged(this.location);

  final String location;

  @override
  List<Object> get props => [location];
}

class CoordinatesChanged extends Setting18CCorNodeAttributeEvent {
  const CoordinatesChanged(this.coordinates);

  final String coordinates;

  @override
  List<Object> get props => [coordinates];
}

class GPSCoordinatesRequested extends Setting18CCorNodeAttributeEvent {
  const GPSCoordinatesRequested();

  @override
  List<Object> get props => [];
}

class TechnicianIDChanged extends Setting18CCorNodeAttributeEvent {
  const TechnicianIDChanged(this.technicianID);

  final String technicianID;

  @override
  List<Object> get props => [technicianID];
}

// class InputSignalLevelChanged extends Setting18CCorNodeAttributeEvent {
//   const InputSignalLevelChanged(this.inputSignalLevel);

//   final String inputSignalLevel;

//   @override
//   List<Object> get props => [inputSignalLevel];
// }

// class InputAttenuationChanged extends Setting18CCorNodeAttributeEvent {
//   const InputAttenuationChanged(this.inputAttenuation);

//   final String inputAttenuation;

//   @override
//   List<Object> get props => [inputAttenuation];
// }

// class InputEqualizerChanged extends Setting18CCorNodeAttributeEvent {
//   const InputEqualizerChanged(this.inputEqualizer);

//   final String inputEqualizer;

//   @override
//   List<Object> get props => [inputEqualizer];
// }

class CascadePositionChanged extends Setting18CCorNodeAttributeEvent {
  const CascadePositionChanged(this.cascadePosition);

  final String cascadePosition;

  @override
  List<Object> get props => [cascadePosition];
}

class DeviceNameChanged extends Setting18CCorNodeAttributeEvent {
  const DeviceNameChanged(this.deviceName);

  final String deviceName;

  @override
  List<Object> get props => [deviceName];
}

class DeviceNoteChanged extends Setting18CCorNodeAttributeEvent {
  const DeviceNoteChanged(this.deviceNote);

  final String deviceNote;

  @override
  List<Object> get props => [deviceNote];
}

class EditModeEnabled extends Setting18CCorNodeAttributeEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends Setting18CCorNodeAttributeEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends Setting18CCorNodeAttributeEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}
