part of 'setting18_configure_bloc.dart';

class Setting18ConfigureEvent extends Equatable {
  const Setting18ConfigureEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends Setting18ConfigureEvent {
  const Initialized({this.useCache = true});

  final bool useCache;

  @override
  List<Object> get props => [];
}

class LocationChanged extends Setting18ConfigureEvent {
  const LocationChanged(this.location);

  final String location;

  @override
  List<Object> get props => [location];
}

class CoordinatesChanged extends Setting18ConfigureEvent {
  const CoordinatesChanged(this.coordinates);

  final String coordinates;

  @override
  List<Object> get props => [coordinates];
}

class GPSCoordinatesRequested extends Setting18ConfigureEvent {
  const GPSCoordinatesRequested();

  @override
  List<Object> get props => [];
}

class SplitOptionChanged extends Setting18ConfigureEvent {
  const SplitOptionChanged(this.splitOption);

  final String splitOption;

  @override
  List<Object> get props => [splitOption];
}

class FirstChannelLoadingFrequencyChanged extends Setting18ConfigureEvent {
  const FirstChannelLoadingFrequencyChanged({
    required this.firstChannelLoadingFrequency,
    required this.currentDetectedSplitOption,
  });

  final String firstChannelLoadingFrequency;
  final String currentDetectedSplitOption;

  @override
  List<Object> get props => [
        firstChannelLoadingFrequency,
        currentDetectedSplitOption,
      ];
}

class FirstChannelLoadingLevelChanged extends Setting18ConfigureEvent {
  const FirstChannelLoadingLevelChanged(this.firstChannelLoadingLevel);

  final String firstChannelLoadingLevel;

  @override
  List<Object> get props => [firstChannelLoadingLevel];
}

class LastChannelLoadingFrequencyChanged extends Setting18ConfigureEvent {
  const LastChannelLoadingFrequencyChanged(this.lastChannelLoadingFrequency);

  final String lastChannelLoadingFrequency;

  @override
  List<Object> get props => [lastChannelLoadingFrequency];
}

class LastChannelLoadingLevelChanged extends Setting18ConfigureEvent {
  const LastChannelLoadingLevelChanged(this.lastChannelLoadingLevel);

  final String lastChannelLoadingLevel;

  @override
  List<Object> get props => [lastChannelLoadingLevel];
}

class PilotFrequencyModeChanged extends Setting18ConfigureEvent {
  const PilotFrequencyModeChanged(this.pilotFrequencyMode);

  final String pilotFrequencyMode;

  @override
  List<Object> get props => [pilotFrequencyMode];
}

class PilotFrequency1Changed extends Setting18ConfigureEvent {
  const PilotFrequency1Changed(this.pilotFrequency1);

  final String pilotFrequency1;

  @override
  List<Object> get props => [pilotFrequency1];
}

class PilotFrequency2Changed extends Setting18ConfigureEvent {
  const PilotFrequency2Changed(this.pilotFrequency2);

  final String pilotFrequency2;

  @override
  List<Object> get props => [pilotFrequency2];
}

class AGCModeChanged extends Setting18ConfigureEvent {
  const AGCModeChanged(this.agcMode);

  final String agcMode;

  @override
  List<Object> get props => [agcMode];
}

class ALCModeChanged extends Setting18ConfigureEvent {
  const ALCModeChanged(this.alcMode);

  final String alcMode;

  @override
  List<Object> get props => [alcMode];
}

class LogIntervalChanged extends Setting18ConfigureEvent {
  const LogIntervalChanged(this.logInterval);

  final String logInterval;

  @override
  List<Object> get props => [logInterval];
}

class RFOutputLogIntervalChanged extends Setting18ConfigureEvent {
  const RFOutputLogIntervalChanged(this.rfOutputLogInterval);

  final String rfOutputLogInterval;

  @override
  List<Object> get props => [rfOutputLogInterval];
}

class TGCCableLengthChanged extends Setting18ConfigureEvent {
  const TGCCableLengthChanged(this.tgcCableLength);

  final String tgcCableLength;

  @override
  List<Object> get props => [tgcCableLength];
}

class EditModeEnabled extends Setting18ConfigureEvent {
  const EditModeEnabled();

  @override
  List<Object> get props => [];
}

class EditModeDisabled extends Setting18ConfigureEvent {
  const EditModeDisabled();

  @override
  List<Object> get props => [];
}

class SettingSubmitted extends Setting18ConfigureEvent {
  const SettingSubmitted();

  @override
  List<Object> get props => [];
}
